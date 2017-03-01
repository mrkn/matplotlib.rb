module Matplotlib
  class Axes3D
    include PyCall::PyObjectWrapper

    @__pyobj__ = PyCall.import_module('mpl_toolkits.mplot3d').Axes3D

    PyCall.dir(@__pyobj__).each do |name|
      obj = PyCall.getattr(@__pyobj__, name)
      next unless obj.kind_of?(PyCall::PyObject) || obj.kind_of?(PyCall::PyObjectWrapper)
      next unless PyCall.callable?(obj)

      define_method(name) do |*args, **kwargs|
        PyCall.getattr(__pyobj__, name).(*args, **kwargs)
      end
    end

    class << self
      attr_reader :__pyobj__

      def method_missing(name, *args, **kwargs)
        return super unless PyCall.hasattr?(__pyobj__, name)
        PyCall.getattr(__pyobj__, name)
      end
    end

    PyCall::Conversions.python_type_mapping(__pyobj__, self)
  end
end
