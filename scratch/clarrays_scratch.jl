using CLArrays
CLArrays.init(CLArrays.default_device())

A = rand(Float32,1024,1024)
B = similar(A)
dA = CLArray(A)
dB = similar(dA)

dA.ptr

@time dA * dB
