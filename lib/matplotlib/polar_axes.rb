module Matplotlib
  PolarAxes = PyCall.import_module('matplotlib.projections.polar').PolarAxes
  PolarAxes.__send__ :register_python_type_mapping
end
