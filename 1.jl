s = parse.(Int,readlines("1.input"))

# part 1
first(x*y for x in s, y in s, z in s if x+y==2020)

# part 2
first(x*y*z for x in s, y in s, z in s if x+y+z==2020)

