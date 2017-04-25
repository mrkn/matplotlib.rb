require 'spec_helper'
require 'matplotlib/pyplot'

module Matplotlib
  ::RSpec.describe Pyplot do
    describe '.xkcd' do
      specify do
        expect { |b| Pyplot.xkcd(&b) }.to yield_control
      end

      specify do
        saved_font_family = Matplotlib.rcParams['font.family']
        saved_path_sketch = Matplotlib.rcParams['path.sketch']
        Pyplot.xkcd(scale: 42, length: 43, randomness: 44) do
          expect(Matplotlib.rcParams['font.family']).to include('xkcd')
          expect(Matplotlib.rcParams['path.sketch']).to eq(PyCall.tuple(42, 43, 44))
        end
        expect(Matplotlib.rcParams['font.family']).to eq(saved_font_family)
        expect(Matplotlib.rcParams['path.sketch']).to eq(saved_path_sketch)
      end
    end
  end
end
