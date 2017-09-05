require "spec_helper"

RSpec.describe Matplotlib do
  it "has a version number" do
    expect(Matplotlib::VERSION).not_to be nil
  end

  describe Matplotlib::Axis::XAxis do
    specify do
      fig = Matplotlib::Pyplot.figure
      ax = fig.add_axes(PyCall.tuple([0.1, 0.2, 0.8, 0.7]))
      expect(ax.xaxis).to be_a(Matplotlib::Axis::XAxis)
    end
  end

  describe Matplotlib::Axis::YAxis do
    specify do
      fig = Matplotlib::Pyplot.figure
      ax = fig.add_axes(PyCall.tuple([0.1, 0.2, 0.8, 0.7]))
      expect(ax.yaxis).to be_a(Matplotlib::Axis::YAxis)
    end
  end

  describe Matplotlib::Spine do
    specify do
      fig = Matplotlib::Pyplot.figure
      ax = fig.add_axes(PyCall.tuple([0.1, 0.2, 0.8, 0.7]))
      expect(ax.spines['right']).to be_a(Matplotlib::Spine)
    end
  end
end
