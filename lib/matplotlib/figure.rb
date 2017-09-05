module Matplotlib
  Figure = PyCall.import_module('matplotlib.figure').Figure
  Figure.__send__ :register_python_type_mapping
end
