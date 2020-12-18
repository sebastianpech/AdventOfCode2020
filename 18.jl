# part 01
const × = (x...) -> Base.:+(x...)
const ∘ = (x...) -> Base.:*(x...)

sum(eval.(Meta.parse.(replace.(replace.(readlines("18.input"), "+"=>"×"), "*" => "∘"))))

# part 02
const * = (x...) -> Base.:+(x...)
const - = (x...) -> Base.:*(x...)

sum(eval.(Meta.parse.(replace.(replace.(readlines("18.input"), "*"=>"-"), "+" => "*"))))
