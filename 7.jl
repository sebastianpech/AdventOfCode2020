data = readlines("7.input")

outer_bag(line) = split(line," contain ")[1][1:end-1]

function contains_bag(line, bag)
    _, content = split(line," contain ")
    occursin(bag, content)
end

function content(line,fakt)
    _, content = split(line," contain ")
    d = Pair{String, Int}[]
    content == "no other bags." && return d
    for b in split(content,",")
        _b = strip(b)
        x = split(_b, " ")
        push!(d,join(x[2:end-1]," ")*" bag" => parse(Int,x[1])*fakt)
    end
    d
end

bags = Set{String}()
bags_to_check = ["shiny gold bag"]
while length(bags_to_check) > 0
    bag = pop!(bags_to_check)
    for l in data
        if contains_bag(l, bag)
            o = outer_bag(l)
            push!(bags, o)
            push!(bags_to_check, o)
        end
    end
end
length(bags)

bags_to_check = ["shiny gold bag"=>1]
counter = 0
while length(bags_to_check) > 0
    bag = pop!(bags_to_check)
    for l in data
        if startswith(l,bag[1])
            bags = content(l,bag[2]) 
            length(bags) == 0 && continue
            counter += sum(getindex.(bags,Ref(2)))
            append!(bags_to_check, bags)
        end
    end
end
counter
