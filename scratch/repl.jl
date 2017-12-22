using FileIO, Glob, ImageView, ImageFiltering
import Plots: plot, pdf, heatmap

include("../src/folki-cpu.jl")
using FOLKI

rawdir = normpath((@__DIR__)*"/../raw/piv1B/")
rawpaths = glob("B002*tif", rawdir)
I1, I2 = float.([load(f) for f in rawpaths])

U, V, err = folki(I1, I2; J = 3, N = 10, w = Kernel.gaussian(3))

plot(flipdim(err,2), xticks="Iterations", ylab="||u^k - u^{k-1}||/N",
        xticks=1:10, yticks=0:.001:.008)
pdf((@__DIR__)*"../report/gfx/error")

heatmap(0:0.1:1, 0:0.1:1, flipdim(sqrt(U[2].^2 + V[2].^2),1)),
 xlab="x", ylab="y", legendtitle="U^2+V^2"
pdf((@__DIR__)*"../report/gfx/velocity")
