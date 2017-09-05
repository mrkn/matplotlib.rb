module Matplotlib
  Axes3D = PyCall.import_module('mpl_toolkits.mplot3d').Axes3D
  Axes3D.__send__ :register_python_type_mapping
end
