module Matplotlib
  Spine = PyCall.import_module('matplotlib.spines').Spine
  Spine.__send__ :register_python_type_mapping
end
