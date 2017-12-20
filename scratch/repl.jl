using FileIO, Glob, ImageView
rawdir = normpath((@__DIR__)*"/../raw/piv1B/")
rawpaths = glob("B001*tif", rawdir)
I1, I2 = float.([load(f) for f in rawpaths])
U, V = folki(I1, I2; J = 2, N = 10)

imshow(sqrt(U[1].^2 + V[1].^2))
