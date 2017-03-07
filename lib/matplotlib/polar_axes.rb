module Matplotlib
  class PolarAxes
    include PyCall::PyObjectWrapper
    wrap_class PyCall.import_module('matplotlib.projections.polar').PolarAxes
  end
end
