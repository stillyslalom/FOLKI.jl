module FOLKI
using Images, ImageFiltering, Interpolations

medianwindow(img,n) = mapwindow(median, img, (n,n))
"""
    u, v = folki(args...)

Compute the displacement field of a pair of input images I1 and I2
"""
function folki(I1raw, I2raw; J=3, N=10, mask=trues(I1raw), w=Kernel.gaussian(4))
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

    for j in J:-1:1
        # i2 is overwritten, necessitating a copy to avoid altering inputs
        i1, i2 = P1[j], copy(P2[j])
        u, v = U[j], V[j]
        np, nq = size(i1)
        iy, ix = imgradients(i1, KernelFactors.ando3)
        itp = interpolate(i2, BSpline(Quadratic(Flat())), OnGrid())
        extrapolate(itp, zero(eltype(i2)))
        ixx, iyy, ixy = imfilter(ix.*ix, w), imfilter(iy.*iy, w), imfilter(ix.*iy, w)
        d = @. ixx*iyy - ixy^2

        for n = 1:N
            @show extrema(u), extrema(v)
            for q = 1:nq, p = 1:np
                i2[p,q] = itp[p + v[p,q], q + u[p,q]]
            end
            didt = @. u*ix + v*iy + i1 - i2
            ixt, iyt = imfilter(ix.*didt, w), imfilter(iy.*didt, w)
            @. u = (iyy*ixt - ixy*iyt)/d
            @. v = (ixx*iyt - ixy*ixt)/d

            # Outlier rejection
            invalid = .!(isfinite.(u) .& isfinite.(v))
            u[invalid] = zero(u[1])
            v[invalid] = zero(v[1])

            u595, v595 = quantile(u, [0.05, 0.95]), quantile(v, [0.05, 0.95])
            
            u .= medianwindow(u,3)
            v .= medianwindow(v,3)
        end

        if j > 1
            U[j-1] .= 2*imresize(u, size(U[j-1]))
            V[j-1] .= 2*imresize(v, size(V[j-1]))
        end
    end
    return U, V
end

end
