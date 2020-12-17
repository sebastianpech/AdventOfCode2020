function parse_data(raw_data,z=0,w=nothing)
    d = split.(split(raw_data,"\n",keepempty=false),Ref(""))
    if w === nothing
        return Dict([(x,y,z)=>d[y][x]=="#" for y in 1:length(d), x in 1:length(d[1])])
    else
        return Dict([(x,y,z,w)=>d[y][x]=="#" for y in 1:length(d), x in 1:length(d[1])])
    end
end

function permute!(current_state, working_state, Δ_neighbors)
    for idx in keys(working_state)
        working_state[idx] = new_cube_state(idx, current_state, Δ_neighbors)
    end
    # Update current state
    for idx in keys(current_state)
        current_state[idx] = get!(working_state,idx,false)
    end
end

function expand_by_one(current_state, Δ_neighbors)
    working_state = deepcopy(current_state)
    for k in keys(working_state)
        for Δ in Δ_neighbors
            get!(current_state, k.+Δ, false)
        end
    end
end

function new_cube_state(idx, current_state, Δ_neighbors)
    count_inactive = 0
    count_active = 0
    
    for Δ in Δ_neighbors
        count_inactive += get!(current_state, idx.+Δ, false)
        count_active += current_state[idx.+Δ]
        count_inactive > length(Δ_neighbors)-2 && return false
        count_active > 3 && return false
    end
    # If a cube is active and exactly 2 or 3 of its neighbors are also active,
    # the cube remains active. Otherwise, the cube becomes inactive.
    if current_state[idx]
        return count_active == 2 || count_active == 3
    end
    # If a cube is inactive but exactly 3 of its neighbors are active, the cube
    # becomes active. Otherwise, the cube remains inactive.
    return count_active == 3
end

# part 1
Δ_neighbors = [(x,y,z) for x in -1:1, y in -1:1, z in -1:1 if (x,y,z) != (0,0,0)]
current_state = parse_data(read("17.input",String))
expand_by_one(current_state,Δ_neighbors)
working_state = deepcopy(current_state)
foreach(1:6) do _
    permute!(current_state, working_state, Δ_neighbors)
end
count(values(current_state))


# part 1
Δ_neighbors = [(x,y,z,w) for x in -1:1, y in -1:1, z in -1:1, w in -1:1 if (x,y,z,w) != (0,0,0,0)]
current_state = parse_data(read("17.input",String),0,0)
expand_by_one(current_state,Δ_neighbors)
working_state = deepcopy(current_state)
foreach(1:6) do _
    permute!(current_state, working_state, Δ_neighbors)
end
count(values(current_state))
