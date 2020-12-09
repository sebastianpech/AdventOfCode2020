using Base.Iterators
data = parse.(Int,readlines("9.input"))

function position_valid(code, pos, n)
    number_pool = sort(code[pos-n:pos-1])
    smalles_pos = number_pool[1]+number_pool[2]
    largest_pos = number_pool[end-1]+number_pool[end]
    target_no = code[pos]
    target_no < smalles_pos && return false
    target_no > largest_pos && return false
    for i in 1:n
        rem = target_no-number_pool[i]
        for j in (i+1):n
            number_pool[j] > rem && break
            number_pool[j] == rem && return true
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
        # Increase end until at target or higher
        while sum(code[start_index:end_index]) < target_number
            end_index += 1
        end
        # Check if at the number
        sum(code[start_index:end_index]) == target_number && break
        # Redact start 
        while sum(code[start_index:end_index]) > target_number && start_index < end_index
            start_index += 1
        end
    end
    return sum(extrema(code[start_index:end_index]))
end
part_2(data,part_1(data,25))

