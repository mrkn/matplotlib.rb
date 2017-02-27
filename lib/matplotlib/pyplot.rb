require 'matplotlib'

module Matplotlib
  module Pyplot
    @pyplot = PyCall.import_module('matplotlib.pyplot')
    PyCall.dir(@pyplot).each do |name|
      obj = PyCall.getattr(@pyplot, name)
      next unless obj.kind_of? PyCall::PyObject
      next unless obj.kind_of? PyCall::LibPython.PyFunction_Type

      define_singleton_method(name) do |*args, **kwargs|
        obj.(*args, **kwargs)
      end
    end

    class << self
      def __pyobj__
        @pyplot
      end

      def method_missing(name, *args, **kwargs)
        return super unless PyCall.hasattr?(@pyplot, name)
        PyCall.getattr(@pyplot, name)
      end
    end
  end
end
