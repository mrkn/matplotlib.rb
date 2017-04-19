require "matplotlib/version"
require 'pycall/import'

module Matplotlib
  @matplotlib = PyCall.import_module('matplotlib')
  PyCall.dir(@matplotlib).each do |name|
    obj = PyCall.getattr(@matplotlib, name)
    next unless obj.kind_of?(PyCall::PyObject) || obj.kind_of?(PyCall::PyObjectWrapper)
    next unless PyCall.callable?(obj)

    define_singleton_method(name) do |*args, **kwargs|
      obj.(*args, **kwargs)
    end
  end

  class << self
    def __pyobj__
      @matplotlib
    end

    def method_missing(name, *args, **kwargs)
      return super unless PyCall.hasattr?(@matplotlib, name)
      PyCall.getattr(@matplotlib, name)
    end
  end

  # FIXME: MacOSX backend is unavailable via pycall.
  #        I don't know why it is.
  if Matplotlib.get_backend() == 'MacOSX'
    Matplotlib.use('TkAgg')
  end

  class Error < StandardError
  end
end

require 'matplotlib/axis'
require 'matplotlib/axes'
require 'matplotlib/polar_axes'
require 'matplotlib/figure'
require 'matplotlib/spines'

PyCall.append_sys_path(File.expand_path('../matplotlib/python', __FILE__))
