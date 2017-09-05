module Matplotlib
  Axes = PyCall.import_module('matplotlib.axes').Axes
  Axes.__send__ :register_python_type_mapping
end
