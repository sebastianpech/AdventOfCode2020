function parse_input(raw_input)
    _rules, _my_ticket, _nearby_tickes = strip.(split(raw_input,"\n\n"))
    rules = map(eachmatch(r"([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)",_rules)) do r
        (name=r[1], ranges=(parse(Int,r[2]):parse(Int,r[3]), parse(Int,r[4]):parse(Int,r[5])))
    end
    my_ticket = map(split(_my_ticket,"\n")[2:end]) do l
        parse.(Int,split(l, ","))
    end
    nearby_tickets = map(split(_nearby_tickes,"\n")[2:end]) do l
        parse.(Int,split(l, ","))
    end
    return rules, my_ticket, nearby_tickets
end

matches_rule(no, rule) = any(x->no in x, rule.ranges)

function part01(raw_data)
    rules, my_ticket, nearby_tickets = parse_input(raw_data)
    invalid = Int[]
    for t in nearby_tickets
        for no in t
            any(x->matches_rule(no, x), rules) || push!(invalid, no)
        end
    end
    sum(invalid)
end
part01(read("16.input", String))

function is_valid(ticket, rules)
    for no in ticket
        any(x->matches_rule(no, x), rules) || return false
    end
    return true
end

function part02(raw_data)
    rules, my_ticket, nearby_tickets = parse_input(raw_data)
    match_count = zeros(Int, length(rules), length(my_ticket[1]))
    no_valid = 0
    for t in nearby_tickets
        is_valid(t, rules) || continue
        no_valid += 1
        for (i,no) in enumerate(t)
            for (j,rule) in enumerate(rules)
                if matches_rule(no, rule)
                    match_count[j,i] += 1
                end
            end
        end
    end
    A = Int.(match_count.==no_valid)
    x = Dict{Int,Int}()
    open_rows = Set(collect(1:size(A,1)))
    while length(open_rows) > 0
        for r in open_rows
            if count(==(1),A[r,:]) == 1
                idx = findfirst(==(1),A[r,:])
                x[r] = idx
                A .-= repeat(transpose(A[r,:]),size(A,1),1)
                delete!(open_rows, r)
            end
        end
    end
    prod(my_ticket[1][get.(Ref(x), 1:6,nothing)])
end
part02(read("16.input", String))

