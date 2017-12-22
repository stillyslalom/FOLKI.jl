using FileIO, Glob, ImageView, ImageFiltering
import Plots: plot, pdf

include("../src/folki-cpu.jl")
using FOLKI

rawdir = normpath((@__DIR__)*"/../raw/piv1B/")
rawpaths = glob("B002*tif", rawdir)
I1, I2 = float.([load(f) for f in rawpaths])

U, V, err = folki(I1, I2; J = 3, N = 10, w = Kernel.gaussian(3))

plot(err)
imshow(U[3])
