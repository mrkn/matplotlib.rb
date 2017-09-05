require 'matplotlib'

module Matplotlib
  Pyplot = PyCall.import_module('matplotlib.pyplot')
  module Pyplot
    def self.xkcd(scale: 1, length: 100, randomness: 2, &block)
      ctx = super(scale: scale, length: length, randomness: randomness)
      PyCall.with(ctx, &block)
    end
  end
end
