require 'pycall/import'

module Matplotlib
  module PyPlot
    dir = PyCall.eval('dir')
    @pyplot = PyCall.import_module('matplotlib.pyplot')

    dir.(@pyplot).each do |name|
      obj = @pyplot.__send__(name)
      next unless obj.kind_of? PyCall::PyObject
      next unless obj.__class__.__name__ == 'function'

      define_singleton_method(name) do |*args, **kwargs|
        obj.(*args, **kwargs)
      end
    end
  end
end
