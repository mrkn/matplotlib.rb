module Matplotlib
  Axis = PyCall.import_module('matplotlib.axis')
  module Axis
    XTick = self.XTick
    XTick.__send__ :register_python_type_mapping

    YTick = self.YTick
    YTick.__send__ :register_python_type_mapping

    XAxis = self.XAxis
    XAxis.__send__ :register_python_type_mapping

    YAxis = self.YAxis
    YAxis.__send__ :register_python_type_mapping
  end
end
