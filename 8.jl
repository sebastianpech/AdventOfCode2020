data = readlines("8.input")

instructions = map(data) do instr
    op, arg = split(instr," ")
    (operation=Symbol(op), argument=parse(Int,arg))
end

function run_inst(seq)
    point = 1
    accumulator = 0
    lines_ran = Set{Int}()
    while !(point in lines_ran) && point <= length(seq)
        push!(lines_ran, point)
        point, accumulator = run_op(seq[point], point, accumulator)
    end
    return point, accumulator
end

run_op(op, point, accumulator) = run_op(Val(op.operation), op.argument, point, accumulator)
run_op(::Val{:acc}, arg, point, acc) = point+1, acc+arg
run_op(::Val{:jmp}, arg, point, acc) = point+arg, acc
run_op(::Val{:nop}, arg, point, acc) = point+1, acc

function run_part1(instructions)
    seq = Dict(zip(1:length(instructions), instructions))
    _, accumulator = run_inst(seq)
    return accumulator
end

run_part1(instructions)

function run_part2(instructions)
    seq = Dict(zip(1:length(instructions), instructions))
    possible_changes = [k for k in keys(seq) if seq[k].operation in (:jmp, :nop) && !(seq[k].operation == :nop && seq[k].argument == 0)]
    for c in possible_changes
        original_inst = seq[c]
        new_inst = (operation=seq[c].operation == :jmp ? :nop : :jmp, argument=seq[c].argument)
        seq[c] = new_inst
        position, accumulator = run_inst(seq)
        if position >= length(seq)
            return accumulator
        end
        seq[c] = original_inst
    end
end

run_part2(instructions)


