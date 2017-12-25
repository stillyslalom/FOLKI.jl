using Images, ImageView, TestImages, GtkReactive
using FileIO, Glob
using AxisArrays, Unitful
import Unitful: s, m
using CLArrays

CLArrays.init(CLArrays.default_device())
img = testimage("cameraman")

v = CLArray(reinterpret.(channelview(img)))
@time d2(v)

Cfloat.(img)
dimg = CLArray(Cfloat.(img))
CartesianRange(indices(img))
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
