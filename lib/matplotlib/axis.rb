module Matplotlib
  class XTick
    include PyCall::PyObjectWrapper
    wrap_class PyCall.import_module('matplotlib.axis').XTick
  end

  class YTick
    include PyCall::PyObjectWrapper
    wrap_class PyCall.import_module('matplotlib.axis').XTick
  end

  class XAxis
    include PyCall::PyObjectWrapper
    wrap_class PyCall.import_module('matplotlib.axis').XAxis
  end

  class YAxis
    include PyCall::PyObjectWrapper
    wrap_class PyCall.import_module('matplotlib.axis').XAxis
  end
end
