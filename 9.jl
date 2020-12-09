data = parse.(Int,readlines("9.input"))

function position_valid(code, pos, n)
    @inbounds for i in pos-n:pos-1
        for j in (i+1):pos-1
            code[i]+code[j] == code[pos] && return true
        end
    end
    return false
end

function part_1(code,n=5)
    for pos in (n+1):length(code)
        position_valid(code, pos, n) || return code[pos]
    end
end
part_1(data,25)

function part_2(code,target_number)
    start_index = 1
    end_index = 2
    while sum(code[start_index:end_index]) != target_number
        while sum(code[start_index:end_index]) < target_number
            end_index += 1
        end
        sum(code[start_index:end_index]) == target_number && break
        while sum(code[start_index:end_index]) > target_number && start_index < end_index
            start_index += 1
        end
    end
    return sum(extrema(code[start_index:end_index]))
end
part_2(data,part_1(data,25))

