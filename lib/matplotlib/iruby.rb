require 'matplotlib'
require 'matplotlib/pyplot'

module Matplotlib
  module IRuby
    module HookExtension
      def self.extended(obj)
        @event_registry ||= {}
        @event_registry[obj] = {}
      end

      def self.register_event(target, event, hook)
        @event_registry[target][event] ||= []
        @event_registry[target][event] << hook
      end

      def register_event(event, hook=nil, &block)
        HookExtension.register_event(self, event, [hook, block].compact)
      end

      def self.unregister_event(target, event, hook)
        return unless @event_registry[target]
        return unless @event_registry[target][event]
        @event_registry[target][event].delete(hook)
      end

      def unregister_event(event, hook)
        HookExtension.unregister_event(self, event, hook)
      end

      def self.trigger_event(target, event)
        return unless @event_registry[target][event]
        @event_registry[target][event].each do |hooks|
          hooks.to_a.each do |hook|
            hook.call if hook
          end
        end
      rescue Exception
        $stderr.puts "Error occurred in triggerred event: target=#{target} event=#{event}", $!.to_s, *$!.backtrace
      end

      def trigger_event(event)
        HookExtension.trigger_event(self, event)
      end

      def execute_request(msg)
        code = msg[:content]['code']
        @execution_count += 1 if msg[:content]['store_history']
        @session.send(:publish, :execute_input, code: code, execution_count: @execution_count)

        trigger_event(:pre_execute)

        content = {
          status: :ok,
          payload: [],
          user_expressions: {},
          execution_count: @execution_count
        }
        result = nil
        begin
          result = @backend.eval(code, msg[:content]['store_history'])
        rescue SystemExit
          content[:payload] << { source: :ask_exit }
        rescue Exception => e
          content = error_content(e)
          @session.send(:publish, :error, content)
        end

        trigger_event(:post_execute)

        @session.send(:reply, :execute_reply, content)
        @session.send(:publish, :execute_result,
                      data: ::IRuby::Display.display(result),
                      metadata: {},
                      execution_count: @execution_count) unless result.nil? || msg[:content]['silent']
      end
    end

    AGG_FORMATS = {
      "image/png" => "png",
      "application/pdf" => "pdf",
      "application/eps" => "eps",
      "image/eps" => "eps",
      "application/postscript" => "ps",
      "image/svg+xml" => "svg"
    }.freeze

    module Helper
      BytesIO = PyCall.import_module('io').BytesIO

      def register_formats
        type { Figure }
        AGG_FORMATS.each do |mime, format|
          format mime do |fig|
            unless fig.canvas.get_supported_filetypes.has_key?(format)
              raise Error, "Unable to display a figure in #{format} format"
            end
            io = BytesIO.new
            fig.canvas.print_figure(io, format: format, bbox_inches: 'tight')
            io.getvalue
          end
        end
      end
    end

    class << self
      # NOTE: This method is translated from `IPython.core.activate_matplotlib` function.
      def activate(gui=:inline)
        enable_matplotlib(gui)
      end

      GUI_BACKEND_MAP = {
        tk: :TkAgg,
        gtk: :GTKAgg,
        gtk3: :GTK3Agg,
        wx: :WXAgg,
        qt: :Qt4Agg,
        qt4: :Qt4Agg,
        qt5: :Qt5Agg,
        osx: :MacOSX,
        nbagg: :nbAgg,
        notebook: :nbAgg,
        agg: :agg,
        inline: 'module://matplotlib_rb.backend_inline',
      }.freeze

      BACKEND_GUI_MAP = Hash[GUI_BACKEND_MAP.select {|k, v| v }].freeze

      private_constant :GUI_BACKEND_MAP, :BACKEND_GUI_MAP

      def available_gui_names
        GUI_BACKEND_MAP.keys
      end

      private

      # This method is based on IPython.core.interactiveshell.InteractiveShell.enable_matplotlib function.
      def enable_matplotlib(gui=nil)
        gui, backend = find_gui_and_backend(gui, @gui_select)

        if gui != :inline
          if @gui_select.nil?
            @gui_select = gui
          elsif gui != @gui_select
            $stderr.puts "Warning: Cannot change to a different GUI toolkit: #{gui}. Using #{@gui_select} instead."
            gui, backend = find_gui_and_backend(@gui_select)
          end
        end

        activate_matplotlib(backend)
        configure_inline_support(backend)
        # self.enable_gui(gui)
        # register matplotlib-aware execution runner for ExecutionMagics

        [gui, backend]
      end

      # Given a gui string return the gui and matplotlib backend.
      # This method is based on IPython.core.pylabtools.find_gui_and_backend function.
      #
      # @param [String, Symbol, nil] gui can be one of (:tk, :gtk, :wx, :qt, :qt4, :inline, :agg).
      # @param [String, Symbol, nil] gui_select can be one of (:tk, :gtk, :wx, :qt, :qt4, :inline, :agg).
      #
      # @return A pair of (gui, backend) where backend is one of (:TkAgg, :GTKAgg, :WXAgg, :Qt4Agg, :agg).
      def find_gui_and_backend(gui=nil, gui_select=nil)
        gui = gui.to_sym if gui.kind_of? String

        if gui && gui != :auto
          # select backend based on requested gui
          backend = GUI_BACKEND_MAP[gui]
          gui = nil if gui == :agg
          return [gui, backend]
        end

        backend = Matplotlib.rcParamsOrig['backend']&.to_sym
        gui = BACKEND_GUI_MAP[backend]

        # If we have already had a gui active, we need it and inline are the ones allowed.
        if gui_select && gui != gui_select
          gui = gui_select
          backend = backend[gui]
        end

        [gui, backend]
      end

      # Activate the given backend and set interactive to true.
      # This method is based on IPython.core.pylabtools.activate_matplotlib function.
      #
      # @param [String, Symbol] backend a name of matplotlib backend
      def activate_matplotlib(backend)
        Matplotlib.interactive(true)

        backend = backend.to_s
        Matplotlib.rcParams['backend'] = backend

        Matplotlib::Pyplot.switch_backend(backend)

        # TODO: should support wrapping python function
        # plt = Matplotlib::Pyplot
        # plt.__pyobj__.show._needmain = false
        # plt.__pyobj__.draw_if_interactive = flag_calls(plt.__pyobj__.draw_if_interactive)
      end

      # This method is based on IPython.core.pylabtools.configure_inline_support function.
      #
      # @param shell an instance of IRuby shell
      # @param backend a name of matplotlib backend
      def configure_inline_support(backend)
        # Temporally monky-patching IRuby kernel to enable flushing and closing figures.
        # TODO: Make this feature a pull-request for sciruby/iruby.
        kernel = ::IRuby::Kernel.instance
        kernel.extend HookExtension
        if backend == GUI_BACKEND_MAP[:inline]
          kernel.register_event(:post_execute, method(:flush_figures))
          # TODO: save original rcParams and overwrite rcParams with IRuby-specific configuration
          new_backend_name = :inline
        else
          kernel.unregister_event(:post_execute, method(:flush_figures))
          # TODO: restore saved original rcParams
          new_backend_name = :not_inline
        end
        if new_backend_name != @current_backend
          # TODO: select figure formats
          @current_backend = new_backend_name
        end
      end

      # This method is based on ipykernel.pylab.backend_inline.flush_figures function.
      def flush_figures
        # TODO: I want to allow users to turn on/off automatic figure closing.
        show_figures(true)
      end

      # This method is based on ipykernel.pylab.backend_inline.show function.
      #
      # @param [true, false] close  If true, a `plt.close('all')` call is automatically issued after sending all the figures.
      def show_figures(close=false)
        _pylab_helpers = PyCall.import_module('matplotlib._pylab_helpers')
        gcf = _pylab_helpers.Gcf
        kernel = ::IRuby::Kernel.instance
        gcf.get_all_fig_managers.each do |fig_manager|
          data = ::IRuby::Display.display(fig_manager.canvas.figure)
          kernel.session.send(:publish, :execute_result,
                              data: data,
                              metadata: {},
                              execution_count: kernel.instance_variable_get(:@execution_count))
        end
      ensure
        unless gcf.get_all_fig_managers.nil?
          Matplotlib::Pyplot.close('all')
        end
      end
    end
  end

  Pyplot.module_eval do
    def self.show(close=true)
      _pylab_helpers = PyCall.import_module('matplotlib._pylab_helpers')
      gcf = _pylab_helpers.Gcf
      gcf.get_all_fig_managers.each do |fig_manager|
        ::IRuby::display(fig_manager.canvas.figure)
      end
      return
    ensure
      if close && gcf.get_all_fig_managers.length > 0
        close('all')
      end
    end
  end
end

::IRuby::Display::Registry.module_eval do
  extend Matplotlib::IRuby::Helper
  register_formats
end
