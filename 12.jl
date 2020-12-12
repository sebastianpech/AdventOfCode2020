data = map(readlines("12.input")) do x
    (action=Symbol(x[1]), value=parse(Int,x[2:end]))
end

move(instruction, location, orientation) = move(Val(instruction.action), instruction.value, location, orientation)
move(::Val{:N}, value, location, orientation) = location+value*im,  orientation
move(::Val{:E}, value, location, orientation) = location+value,  orientation
move(::Val{:S}, value, location, orientation) = location-value*im, orientation
move(::Val{:W}, value, location, orientation) = location-value, orientation
move(::Val{:L}, value, location, orientation) = location, orientation*(im^(value/90))
move(::Val{:R}, value, location, orientation) = location, orientation/(im^(value/90))
move(::Val{:F}, value, location, orientation) = location+value*orientation, orientation

function part01(instructions)
    location, orientation = complex(0), 1
    for instr in instructions
         location, orientation = move(instr, location, orientation)
    end
    return abs(real(location)) + abs(imag(location))
end
part01(data)

# orientation is not used here anymore.
# The rotation functions need to be adapted to rotate around a point instead
# of just altering an angle.
move(::Val{:L}, value, location, orientation) = location*(im^(value/90)), orientation
move(::Val{:R}, value, location, orientation) = location/(im^(value/90)), orientation

function part02(instructions)
    ship, waypoint, orientation = complex(0), 10+im, 1
    for instr in instructions
        if instr.action == :F
            ship += instr.value*waypoint
        else
            waypoint, orientation = move(instr, waypoint, orientation)
        end
    end
    return abs(real(ship)) + abs(imag(ship))
end
part02(data)

