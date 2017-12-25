using BenchmarkTools, CLArrays

function bmark_matmul()
    t_cpu = zeros(8)
    t_ocl = zeros(8)
    for (i, n) in enumerate(5:12)
        v = rand(Float32,n,n)
        d_v = CLArray(v)

        t_cpu[i] = @belapsed $v*$v
        t_ocl[i] = @belapsed $d_v*$d_v
    end
    return t_cpu, t_ocl
end

t_cpu_matmul, t_ocl_matmul = bmark_matmul()
