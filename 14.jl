# part 01

function apply_mask(mask, no::Int)
    bs = bitstring(no)[end-35:end]
    parse(Int,mapreduce(*, 1:length(bs)) do idx
        mask[idx] == 'X' && return bs[idx]
        return mask[idx]
    end,base=2)
end

function part01(data)
    mask = ""
    mem = Dict{Int,Int}()
    for l in data
        if startswith(l, "mask = ")
            mask = l[end-35:end]
        elseif startswith(l, "mem")
            adr, val = parse.(Int,match(r"\[(\d+)\] = (\d+)$",l).captures)
            mem[adr] = apply_mask(mask,val)
        end
    end
    mem
end

data = readlines("14.input")
sum(values(part01(data)))

# part 02

function permutations(n)
    n == 1 && return [['0'],['1']]
    sub_perm = permutations(n-1)
    sub_perm_b = deepcopy(sub_perm)
    foreach(sub_perm) do x
        insert!(x,1,'0')
    end
    foreach(sub_perm_b) do x
        insert!(x,1,'1')
    end
    append!(sub_perm, sub_perm_b)
end

function apply_mem_mask(mask, no::Int)
    mask = collect(mask)
    bs = bitstring(no)[end-35:end]
    X_mask = mask.=='X'
    floating = @view mask[X_mask]
    perms = permutations(length(floating))
    mem_ids = Int[]
    sizehint!(mem_ids, length(perms))
    for perm in perms
        floating .= perm
        push!(mem_ids, parse(Int,mapreduce(*, 1:length(bs)) do idx
            X_mask[idx] && return mask[idx]
            mask[idx] == '0' && return bs[idx]
            return mask[idx]
        end,base=2))
    end
    return mem_ids
end

function part02(data)
    mask = ""
    mem = Dict{Int,Int}()
    for l in data
        if startswith(l, "mask = ")
            mask = l[end-35:end]
        elseif startswith(l, "mem")
            adr, val = parse.(Int,match(r"\[(\d+)\] = (\d+)$",l).captures)
            mem_adresses = apply_mem_mask(mask, adr)
            for m in mem_adresses
                mem[m] = val
            end
        end
    end
    mem
end

sum(values(part02(data)))
