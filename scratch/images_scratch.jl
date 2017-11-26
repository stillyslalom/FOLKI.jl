using Images, ImageView, TestImages, GtkReactive
using FileIO, Glob
using AxisArrays, Unitful
import Unitful: s, m

img = testimage("cameraman")
sz = size(img)
img2 = AxisArray(cat(3, img, img),
                        Axis{:y}(linspace(0m,0.1m,sz[1])),
                        Axis{:x}(linspace(0m,0.1m,sz[2])),
                        Axis{:img}([:a, :b]))
img2[0m .. 0.05m, 0m .. 0.07m, :a]



rawdir = normpath((@__DIR__)*"/../raw/piv1B/")
rawpaths = glob("*tif", rawdir)
rawimgs = [load(f) for f in rawpaths]
sz = size(rawimgs[1])
AxisArray(cat(3, rawimgs[1], rawimgs[2]),
                        Axis{:y}(linspace(0m,0.1m,sz[1])),
                        Axis{:x}(linspace(0m,0.1m,sz[2])),
                        Axis{:img}([:a, :b]))
guidata = imshow(mri, axes=(1,2))
zr = guidata["roi"]["zoomregion"]
slicedata = guidata["roi"]["slicedata"]
imshow(mriseg, nothing, zr, slicedata)
