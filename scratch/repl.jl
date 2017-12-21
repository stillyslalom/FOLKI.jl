using FileIO, Glob, ImageView, Plots
using ProfileView

rawdir = normpath((@__DIR__)*"/../raw/piv1B/")
rawpaths = glob("B002*tif", rawdir)
I1, I2 = float.([load(f) for f in rawpaths])

U, V, err = folki(I1, I2; J = 3, N = 10)

plot(err)
imshow(U[1])
imshow(sqrt(U[1].^2 + V[1].^2))
