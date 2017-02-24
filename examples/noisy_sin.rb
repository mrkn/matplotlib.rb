require 'matplotlib/pyplot'

plt = Matplotlib::Pyplot

xs = [*1..100]
ys = xs.map {|x| Math.sin(Math::PI * x / 20.0) + 0.1 * (rand - 0.5) }
plt.plot(xs, ys)
plt.show
