data = readlines("5.input")

end_of_lower_half((lower,upper)) = lower+div((upper-lower+1),2)-1

function reduce_midpoint!(rng, descr; lower_half)
    for l in descr
        if l == lower_half
            rng[2] = end_of_lower_half(rng)
        else
            rng[1] = end_of_lower_half(rng)+1
        end
    end
end

function compute_seat(boardingpass)
    row_range = [0,127]
    reduce_midpoint!(row_range,boardingpass[1:7], lower_half='F')
    col_range = [0,7]
    reduce_midpoint!(col_range,boardingpass[8:end], lower_half='L')
    return row_range[1],col_range[1] 
end
seat_id((row,col)) = row*8+col

# part 1

maximum(seat_id.(compute_seat.(data)))

# part 2

ids = seat_id.(compute_seat.(data))
sort!(ids)
ids[findfirst(i->ids[i]-ids[i+1]!=-1,1:length(ids))]+1



