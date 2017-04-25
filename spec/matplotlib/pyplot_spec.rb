require 'spec_helper'
require 'matplotlib/pyplot'

module Matplotlib
  ::RSpec.describe Pyplot do
    describe '.xkcd' do
      specify do
        saved_font_family = Matplotlib.rcParams['font.family']
        saved_path_sketch = Matplotlib.rcParams['path.sketch']
        expect { |b|
          Pyplot.xkcd(scale: 42, length: 43, randomness: 44) do
            lambda(&b).call
            expect(Matplotlib.rcParams['font.family']).to include('xkcd')
            expect(Matplotlib.rcParams['path.sketch']).to eq(PyCall.tuple(42, 43, 44))
          end
        }.to yield_control
        expect(Matplotlib.rcParams['font.family']).to eq(saved_font_family)
        expect(Matplotlib.rcParams['path.sketch']).to eq(saved_path_sketch)
      end
    end
  end
end
