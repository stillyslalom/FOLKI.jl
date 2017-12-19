module FOLKI
using Images, ImageFiltering, Interpolations

"""
    u, v = folki(args...)

Compute the displacement field of a pair of input images I1 and I2
"""
function folki(I1raw, I2raw; J=3, N=10, mask=trues(I1raw), w=Kernel.gaussian(2))
    # Input verification
    if size(I1raw) != size(I2raw)
        error("""Input images must have identical dimensions.
                 size(I1) = $(size(I1raw))
                 size(I2) = $(size(I2raw))""")
    end

    I1, I2 = I1raw, I2raw # Float32.(I1raw), Float32.(I2raw)
    P1, P2 = Images.gaussian_pyramid.([I1, I2], J-1, 2, 1.0)
    # TODO: fix inefficient alloc of u, v
    U, V = Images.gaussian_pyramid.([zeros(I1), zeros(I2)], J-1, 2, 1.0) #
    #X, Y = copy(U), copy(V)

    for j in J:-1:1
        i1, i2 = P1[j], P2[j]
        u, v = U[j], V[j]
        ni, nj = size(i1)
        ix, iy = imgradients(i1)
        itp = interpolate(i2, BSpline(Linear()), OnGrid())
        i2_warp = copy(i2)
        a, b, c = imfilter(ix.*ix, w), imfilter(iy.*iy, w), imfilter(ix.*iy, w)
        d = @. a*b - c*c

        for n = 1:N
            for j = 1:nj, i = 1:ni
                i2_warp[i,j] = itp[i + u[i,j], j + v[i,j]]
            end
            didt = @. u*ix + v*iy + i1 - i2_warp
            g, h = imfilter(ix.*didt, w), imfilter(iy.*didt, w)
            u = (b.*g - c.*h)./d
            v = (a.*h - c.*g)./d
            u[!isfinite.(u)] = zero(u[1])
            v[!isfinite.(v)] = zero(v[1])
        end

        if j > 1
            U[j-1] .= imresize(u, size(U[j-1]))
            V[j-1] .= imresize(v, size(V[j-1]))
        end
    end
    return u, v
end

end
