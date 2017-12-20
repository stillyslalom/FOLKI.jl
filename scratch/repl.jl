using FileIO, Glob
rawdir = normpath((@__DIR__)*"/../raw/piv1B/")
rawpaths = glob("B001*tif", rawdir)
I1, I2 = float.([load(f) for f in rawpaths])

folki(I1, I2; J = 1, N = 2)
