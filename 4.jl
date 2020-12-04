const part1_required_keys = Set([ :byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid ])

data = map(split.(split(read("4.input",String),"\n\n"), Ref(['\n',' ']), keepempty=false)) do ent
    Dict(let x=split(e,":")
             Symbol(x[1])=>x[2]
             end for e in ent)
end

part1_valid(ent) = issubset(part1_required_keys,keys(ent))
count(part1_valid.(data))

const re_eye_colors = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
is_valid(::Val{:byr},value) = length(value) == 4 && ( 1920 ≤  parse(Int,value) ≤ 2002)
is_valid(::Val{:iyr},value) = length(value) == 4 && ( 2010 ≤  parse(Int,value) ≤ 2020)
is_valid(::Val{:eyr},value) = length(value) == 4 && ( 2020 ≤  parse(Int,value) ≤ 2030)
is_valid(::Val{:hgt},value) = endswith(value,"cm") ? (150 ≤ parse(Int,value[1:end-2]) ≤ 193) : (59 ≤ parse(Int,value[1:end-2]) ≤ 76)
is_valid(::Val{:hcl},value) = match(r"^#[a-f0-9]{6}$",value) != nothing
is_valid(::Val{:ecl},value) = value in re_eye_colors
is_valid(::Val{:pid},value) = match( r"^\d{9}$", value) != nothing

function part2_valid(ent)
    part1_valid(ent) || return false
    for k in part1_required_keys
        is_valid(Val(k), ent[k]) || return false
    end
    return true
end

count(part2_valid.(data))
