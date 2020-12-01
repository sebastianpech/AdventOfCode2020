s = parse.(Int,readlines("1.input"))

# part 1
first(x*y for x in s, y in s, z in s if x+y==2020)

# part 2
first(x*y*z for x in s, y in s, z in s if x+y+z==2020)

# Playing around with improving part 2
using BenchmarkTools

function part2(s)
    _s = sort(s)
    for x in _s
        for y in _s
            x+y >= 2020 && break
            for z in _s
                x+y+z > 2020 && break
                x+y+z == 2020 && return x*y*z
            end
        end
    end
end
