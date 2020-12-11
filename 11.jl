const floor = '.'
const empty_seat = 'L'
const occup_seat = '#'

function should_occupie_seat(grid, r, c)
    for Δc in -1:1
        _c = c+Δc
        0 < _c <= size(grid, 2) || continue
        for Δr in -1:1
            _r = r+Δr
            0 < _r <= size(grid, 1) || continue
            Δc == Δr == 0 && continue
            grid[_r,_c] == occup_seat && return false
        end
    end
    return true
end

function should_empty_seat(grid, r, c)
    occ = 0
    for Δc in -1:1
        _c = c+Δc
        0 < _c <= size(grid, 2) || continue
        for Δr in -1:1
            _r = r+Δr
            0 < _r <= size(grid, 1) || continue
            Δc == Δr == 0 && continue
            occ += (grid[_r,_c] == occup_seat)
            occ >= 4 && return true
        end
    end
    return false
end

function sim_step!(grid, working_grid)
    change = false
    working_grid .= grid
    for c in 1:size(grid,2)
        for r in 1:size(grid,1)
            if grid[r,c] == empty_seat && should_occupie_seat(grid,r,c)
                working_grid[r,c] = occup_seat
                change = true
            elseif grid[r,c] == occup_seat && should_empty_seat(grid,r,c)
                working_grid[r,c] = empty_seat
                change = true
            end
        end
    end
    grid .= working_grid
    return change
end

d = strip(read("11.input",String))

grid = mapreduce(vcat, split.(split(d,"\n"),Ref(""))) do l
    permutedims(getindex.(l,Ref(1)))
end

function part1(grid)
    working_grid = copy(grid)
    while sim_step!(grid, working_grid)
    end
    return count(==(occup_seat), grid)
end

part1(grid)

# part 2

function should_occupie_seat_part2(grid, r, c, seats)
    for idx in seats
        grid[idx] == occup_seat && return false
    end
    return true
end

function should_empty_seat_part2(grid, r, c, seats)
    occ = 0
    for idx in seats
        occ += (grid[idx] == occup_seat)
        occ >= 5 && return true
    end
    return false
end

function sim_step_part2!(grid, working_grid, seat_map)
    change = false
    working_grid .= grid
    for c in 1:size(grid,2)
        for r in 1:size(grid,1)
            if grid[r,c] == empty_seat && should_occupie_seat_part2(grid,r,c,seat_map[(r,c)])
                working_grid[r,c] = occup_seat
                change = true
            elseif grid[r,c] == occup_seat && should_empty_seat_part2(grid,r,c,seat_map[(r,c)])
                working_grid[r,c] = empty_seat
                change = true
            end
        end
    end
    grid .= working_grid
    return change
end

function gen_related_seats(grid,r,c)
    directions = ((1,0),(-1,0),(0,1),(0,-1),(-1,-1),(-1,1),(1,-1),(1,1))
    (r,c) => filter(!(==(nothing)),search_for_seat.(Ref(grid),Ref(r),Ref(c),directions))
end

function search_for_seat(grid,r,c,direction)
    x = CartesianIndex(r,c)
    Δx = CartesianIndex(direction...)
    try
        while grid[x+Δx] == floor
            x += Δx
        end
        return x+Δx
    catch e
        e isa BoundsError && return nothing
        rethrow(e)
    end
end

function part2(grid)
    seat_map = Dict(gen_related_seats.(Ref(grid), 1:size(grid,1), (1:size(grid,2))'))
    working_grid = copy(grid)
    while sim_step_part2!(grid, working_grid, seat_map)
    end
    return count(==(occup_seat), grid)
end

part2(grid)
