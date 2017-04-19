module Matplotlib
  class Spine
    include PyCall::PyObjectWrapper
    wrap_class PyCall.import_module('matplotlib.spines').Spine
  end
end
