function parse_line(l)
    rfrom, rto, character, password = match(r"^(\d+)-(\d+) (\w+): (\w+)$",l).captures
    (nrange=parse.(Int,[rfrom, rto]), character=character, password=password)
end

data = readlines("2.input")
parsed = parse_line.(data)

# part 1

is_valid_p1(p) = p.nrange[1] ≤ count(p.character, p.password) ≤ p.nrange[2]
count(is_valid_p1.(parsed))

# part 2

is_valid_p2(p) = (p.password[p.nrange[1]] == p.character[1]) ⊻ (p.password[p.nrange[2]] == p.character[1])
count(is_valid_p2.(parsed))
