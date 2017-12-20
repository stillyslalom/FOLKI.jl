using FileIO, Glob, ImageView
rawdir = normpath((@__DIR__)*"/../raw/piv1B/")
rawpaths = glob("B002*tif", rawdir)
I1, I2 = float.([load(f) for f in rawpaths])

folki(I1, I2; J = 5, N = 10)
