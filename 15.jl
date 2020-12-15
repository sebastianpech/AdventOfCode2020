function part01(input; until_turn)
    no_spoken = Dict(zip(input,zip(zeros(Int,length(input)),1:length(input))))
    last_number = input[end]
    turn = length(input)
    for i in turn+1:until_turn
        n1, n2 = no_spoken[last_number]
        if n1 == 0
            new_number = 0
        else
            new_number = n2-n1
        end
        n1, n2 = get(no_spoken,new_number, (0,0))
        no_spoken[new_number] = (n2, i)
        last_number = new_number
    end
    return last_number
end

# part 01
input = [12,1,16,3,11,0]

part01(input, until_turn=2020)

# part 02

part01(input, until_turn=30000000)
