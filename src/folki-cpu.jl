module FOLKI

using Images, ImageFiltering, Interpolations
export folki

medianwindow(img,n) = mapwindow(median, img, (n,n))

"""
    u, v = folki(args...)

Compute the displacement field of a pair of input images I1 and I2
"""
function folki(I1raw, I2raw; J=3, N=10, mask=trues(I1raw), w=Kernel.gaussian(4),
               medfilt=false)
    # Input verification
    if size(I1raw) != size(I2raw)
        error("""Input images must have identical dimensions.
                 size(I1) = $(size(I1raw))
                 size(I2) = $(size(I2raw))""")
    end

    I1, I2 = I1raw, I2raw # Float32.(I1raw), Float32.(I2raw)
    P1, P2 = Images.gaussian_pyramid.([I1, I2], J-1, 2, 1.0)
    # TODO: fix inefficient alloc of u, v
    U, V = Images.gaussian_pyramid.([zeros(I1), zeros(I2)], J-1, 2, 1.0)
    err = zeros(N, J)

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
            for q = 1:nq, p = 1:np
                i2[p,q] = itp[clamp(p + v[p,q], 1, np),
                              clamp(q + u[p,q], 1, nq)]
            end
            didt = @. u*ix + v*iy + i1 - i2
            ixt, iyt = imfilter(ix.*didt, w), imfilter(iy.*didt, w)
            u_old, v_old = copy(u), copy(v)
            @. u = (iyy*ixt - ixy*iyt)/d
            @. v = (ixx*iyt - ixy*ixt)/d

            err[n, j] = (vecnorm(u - u_old) + vecnorm(v - v_old))/length(u)

            # Outlier rejection
            # Set infinite & NaN values to zero
            invalid = .!(isfinite.(u) .& isfinite.(v))
            u[invalid] = zero(u[1])
            v[invalid] = zero(v[1])

            # Reject global outliers: set displacements below the 1st percentile
            # to the the fifth percentile value; likewise for the 99th %
            ulim, vlim = quantile(vec(u), [0.01, 0.99]), quantile(vec(v), [0.01, 0.99])
            u[u .< ulim[1]] = ulim[1]; u[u .> ulim[2]] = ulim[2]
            v[v .< vlim[1]] = vlim[1]; v[v .> vlim[2]] = vlim[2]

            # Local median filter
            if medfilt
                u .= medianwindow(u,3)
                v .= medianwindow(v,3)
            end
        end

        # TODO: allow for rescaling of arbitrary image pyramids (not just 2x)
        if j > 1
            U[j-1] .= 2*imresize(u, size(U[j-1]))
            V[j-1] .= 2*imresize(v, size(V[j-1]))
        end
    end
    return U, V, err
end

end
