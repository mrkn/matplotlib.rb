module Matplotlib
  class Axes3D
    include PyCall::PyObjectWrapper
    wrap_class PyCall.import_module('mpl_toolkits.mplot3d').Axes3D
  end
end
