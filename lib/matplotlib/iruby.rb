require 'pycall'

module Matplotlib
  module IRuby
    AGG_FORMATS = {
      "image/png" => "png",
      "application/pdf" => "pdf",
      "application/eps" => "eps",
      "image/eps" => "eps",
      "application/postscript" => "ps",
      "image/svg+xml" => "svg"
    }

    module Helper
      def register_formats
        bytes_io = PyCall.import_module('io').BytesIO
        type { Figure }
        AGG_FORMATS.each do |mime, format|
          format mime do |fig|
            unless fig.canvas.get_supported_filetypes.().has_key?(format)
              raise Error, "Unable to display a figure in #{format} format"
            end
            io = bytes_io.()
            fig.canvas.print_figure.(io, format: format, bbox_inches: 'tight')
            io.getvalue.()
          end
        end
      end
    end

    class << self
      # NOTE: This method is translated from `IPython.core.activate_matplotlib` function.
      def activate(gui=:inline)
        require 'matplotlib/pyplot'
      end
    end
  end
end

::IRuby::Display::Registry.module_eval do
  extend Matplotlib::IRuby::Helper
  register_formats
end
