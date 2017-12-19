using Images, ImageView, TestImages, FileIO
using CLArrays
CLArrays.init(CLArrays.default_device())

img = testimage("cameraman");
@time pyramid = gaussian_pyramid(img, 2, 2, 1.0);

pyramid[2]

@edit gaussian_pyramid(img, 2, 2, 1.0);
