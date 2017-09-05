require 'matplotlib/version'
require 'pycall'

Matplotlib = PyCall.import_module('matplotlib')

module Matplotlib
  VERSION = MATPLOTLIB_VERSION
  Object.class_eval { remove_const :MATPLOTLIB_VERSION }

  # FIXME: MacOSX backend is unavailable via pycall.
  #        I don't know why it is.
  if get_backend == 'MacOSX'
    use('TkAgg')
  end

  class Error < StandardError
  end
end

require 'matplotlib/axis'
require 'matplotlib/axes'
require 'matplotlib/polar_axes'
require 'matplotlib/figure'
require 'matplotlib/spines'

PyCall.sys.path.insert(0, File.expand_path('../matplotlib/python', __FILE__))
