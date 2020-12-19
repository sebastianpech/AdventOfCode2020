raw_data = read("19.input",String)

function parse_rule(rule)
    id, val = strip.(split(rule,":"))
    rules = map(strip.(split(val,"|"))) do subrule
        parsed = tryparse.(Int,strip.(split(subrule," ")))
        nothing in parsed && return (replace(subrule,"\""=>""),)
        Tuple(parsed)
    end
    parse(Int,id) => rules
end
function parse_input(raw_data)
    rules, data = split(raw_data, "\n\n")
    Dict(parse_rule.(split(rules,"\n"))),split(data, "\n")
end

@inline tuplejoin(x) = x
@inline tuplejoin(x, y) = (x..., y...)
@inline tuplejoin(x, y, z...) = tuplejoin(tuplejoin(x, y), z...)
@inline combinetuples(x) = tuplejoin(x...)

is_resolveable(val::Vector{NTuple{N,String}}) where N = true
is_resolveable(val) = false

function resolve_rules!(rules)
    not_resolved_ids = Set(keys(rules))
    while length(not_resolved_ids) > 0
        for id in not_resolved_ids
            if is_resolveable(rules[id])
                delete!(not_resolved_ids, id)
            elseif all(x->all(x->is_resolveable(rules[x]), x),rules[id])
                # Do it
                resolve_rule!(rules,id)
                delete!(not_resolved_ids, id)
            end
        end
    end
end

function resolve_rule(rules, val)
    mapreduce(vcat,val) do v
        # Chain
        combinetuples.(collect(Iterators.product(map(sid->get(rules,sid,sid), v)...))[:])
    end
end
function resolve_rule!(rules, id)
    rules[id] = resolve_rule(rules, rules[id])
    nothing
end

rules, data = parse_input(raw_data)
resolve_rules!(rules)
length(Set(data) ∩ Set(join.(rules[0])))

# part 2
# 8: 42 changes to 8: 42 | 42 8
# 11: 42 31 changes to  11: 42 31 | 42 11 31
# This result in the following or cases:
# For 8 this a essentially 42 | 42 42 | 42 42 42 | ...
# For 11 42 31 | 42 42 31 31 | 42 42 42 31 31 31 | ...
# As 0 is the only rule affected by those it's the only that changes.
# Rule 0: 8 11
# So expaning one level meanns
# 0: (42 | 42 42 | 42 42 42 | ...) ( 42 31 | 42 42 31 31 | 42 42 42 31 31 31 | ...)
# So it can be all possible combinations of the above two which can simpy be expressed by
# 0: n*42 followed by m*31 where n >= 2 and m >= 1 and n > m
# With both rules having the same length of 8, the strings can be checked in steps of 8

rules, data = parse_input(raw_data)
resolve_rules!(rules)

# Extract the resolved rules 42 and 31
r42 = join.(rules[42])
r31 = join.(rules[31])

function check_string(r42,r31, s)
    n = 0
    m = 0
    N = length(r42[1])
    for i in N:N:length(s)
        mat= s[i-N+1:i] in r42
        n += mat
        !(mat) && break
    end
    n == 0 && return false
    for i in (n+1)*N:N:length(s)
        mat = s[i-N+1:i] in r31
        m += mat
        !(mat) && break
    end
    full_string = length(s) == N*(n+m)
    return n >= 2 && m >= 1 && n > m && full_string
end
count(check_string.(Ref(r42),Ref(r31),data))


