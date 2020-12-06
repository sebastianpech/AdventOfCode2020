data = split(read("6.input",String),"\n\n",keepempty=false)

# part 1
answ_yes_p_group = map(data) do group
    setdiff(Set(split(group,"")),Set(["\n"]))
end

sum(length.(answ_yes_p_group))

# part 2

answ_yes_p_group_all = map(data) do group
    reduce(∩,Set.(split.(split(group,"\n",keepempty=false),Ref(""))))
end

sum(length.(answ_yes_p_group_all))

