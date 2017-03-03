module Matplotlib
  class Axes
    include PyCall::PyObjectWrapper
    wrap_class PyCall.import_module('matplotlib.axes').Axes
  end
end
