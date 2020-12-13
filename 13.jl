inp = readlines("13.input")

# part 1

timestamp = parse(Int,inp[1])
buses = filter(!(==(nothing)),tryparse.(Int,split(inp[2],",")))
waittime = ceil.(timestamp./buses).*buses.-timestamp
minid = argmin(waittime)
busid = buses[minid]
waittime[minid]*busid

# part 2

function merge_periodic(na,ma,nb,mb,Δ=0; ignore_period=false)
    ta = div(nb-na,ma,RoundUp)
    n = 0
    found_start = false
    while true
        target = na+ma*ta
        tb = (target+Δ-nb)/mb
        if floor(tb) == tb
            found_start && return n, target-n
            n = target
            if ignore_period
                return n, 0
            end
            found_start = true
        end
        ta += 1
    end
end

function part02(buses)
    Δ = [i-1 for i in 1:length(buses) if buses[i] !== nothing]
    buses = filter(!(==(nothing)),buses)
    basef = merge_periodic(0,buses[1],0,buses[2],Δ[2])
    for i in 3:length(buses)-1
        basef = merge_periodic(basef...,0,buses[i],Δ[i])
    end
    return merge_periodic(basef...,0,buses[end],Δ[end], ignore_period=true)[1]
end

buses = tryparse.(Int,split(inp[2],","))
part02(buses)
