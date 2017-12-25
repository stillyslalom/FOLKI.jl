using FileIO, Glob, ImageView, ImageFiltering, Plots
plotlyjs()

include((@__DIR__)*"/../src/folki-cpu.jl")
using FOLKI

rawdir = normpath((@__DIR__)*"/../raw/piv1B/")
rawpaths = glob("B002*tif", rawdir)
I1, I2 = float.([load(f) for f in rawpaths])

U, V, err = folki(I1, I2; J = 3, N = 10, w = Kernel.gaussian(3))

plot(flipdim(err,2), xlab="Iterations", ylab="Relative error",
        xticks=1:10, ylim=(0,0.008))

heatmap(flipdim(sqrt.(U[2].^2 + V[2].^2),1), xlab="x", ylab="y", aspectratio=0.8)
