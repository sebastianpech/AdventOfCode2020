data = sort(parse.(Int,readlines("10.input")))

# part 1 

d = copy(data)
insert!(d,1,0)
push!(d,d[end]+3)
diff = d[2:end]-d[1:end-1]
count(==(1),diff)*count(==(3),diff)

# part 2
function get_pos_comb(n)
    n == 1 && return 1
    n == 1 && return 1
    n == 2 && return 2
    n == 3 && return 4
    last_three = [1,2,4]
    for i in 4:n
        x = sum(last_three)
        last_three[1] = last_three[2]
        last_three[2] = last_three[3]
        last_three[3] = x
    end
    return last_three[3]
end

function part2(diff)
    N = length(diff)
    threes = collect(1:N)[diff .== 3]
    insert!(threes,1,0)
    distances = threes[2:end]-threes[1:end-1].-1
    prod(get_pos_comb.(distances))
end

part2(diff)
