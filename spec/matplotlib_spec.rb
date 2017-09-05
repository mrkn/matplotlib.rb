require "spec_helper"

RSpec.describe Matplotlib do
  it "has a version number" do
    expect(Matplotlib::VERSION).not_to be nil
  end

  describe Matplotlib::XAxis do
    specify do
      fig = Matplotlib::Pyplot.figure
      ax = fig.add_axes(PyCall.tuple(0.1, 0.2, 0.8, 0.7))
      expect(ax.xaxis).to be_a(Matplotlib::XAxis)
    end
  end

  describe Matplotlib::YAxis do
    specify do
      fig = Matplotlib::Pyplot.figure
      ax = fig.add_axes(PyCall.tuple(0.1, 0.2, 0.8, 0.7))
      expect(ax.yaxis).to be_a(Matplotlib::YAxis)
    end
  end

  describe Matplotlib::Spine do
    specify do
      fig = Matplotlib::Pyplot.figure
      ax = fig.add_axes(PyCall.tuple(0.1, 0.2, 0.8, 0.7))
      expect(ax.spines['right']).to be_a(Matplotlib::Spine)
    end
  end

  describe Matplotlib::PolarAxes do
    specify do
      ax = Matplotlib::Pyplot.subplot(111, projection: :polar)
      expect(ax).to be_a(Matplotlib::PolarAxes)
    end
  end
end
