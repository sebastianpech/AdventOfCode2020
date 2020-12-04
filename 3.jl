grid = reduce(vcat,permutedims.(split.(readlines("3.input"),Ref(""))))

function next_position(grid, current_position, (Δr, Δc))
    trial_c = current_position[2] + Δc
    s = size(grid,2)
    CartesianIndex(current_position[1]+Δr,(trial_c-1)%s+1)
end

function part01(grid, slope=(1,3))
    current_position = CartesianIndex(1,1)
    trees = 0
    while (current_position = next_position(grid, current_position, slope))[1] <= size(grid,1)
        trees += (grid[current_position] == "#")
    end
    return trees
end
part01(grid)

function part02(grid)
    map([(1,1), (1,3), (1,5), (1,7), (2,1)]) do slope
        part01(grid, slope)
    end |> prod
end
part02(grid)

