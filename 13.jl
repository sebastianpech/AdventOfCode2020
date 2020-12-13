inp = split("""939
            7,13,x,x,59,x,31,19""","\n")
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
    ta = 0
    tb = 0
    n = 0
    found_start = false
    while true
        target = na+ma*ta
        while nb+tb*mb < target+Δ
            tb += 1
        end
        if nb+tb*mb == target+Δ 
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
    init = merge_periodic.(Ref(0),Ref(buses[1]),Ref(0),buses[2:end],Δ[2:end])
    while length(init) > 2
        init = [ merge_periodic(init[1]...,init[i]...,0) for i in 2:length(init)]
    end
    merge_periodic(init[1]...,init[2]...,0, ignore_period=true)[1]
end

buses = tryparse.(Int,split(inp[2],","))
part02(buses)
