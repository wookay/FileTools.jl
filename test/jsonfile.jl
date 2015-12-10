using FileTools
using Base.Test

# array.json
@test JSONFile("array.json") == f"array.json"
@test JSONFile == typeof(f"array.json")
@test 20 == length(f"array.json")
@test 413 == filesize(f"array.json")
@test f"array.json"[1] == json"""[[1,"hello","world"]]"""[1]
@test 210 == sum(map(a->a[1], f"array.json"))

# dict.json
@test JSONFile("dict.json") == f"dict.json"
@test JSONFile == typeof(f"dict.json")
@test 2 == length(f"dict.json")
@test 25 == filesize(f"dict.json")
@test parse(f"dict.json") == json"""{"id": 1, "value": true}"""
@test 1 == f"dict.json"["id"]
@test true == f"dict.json"["value"]
@test 1 == json"""{"id": 1, "value": true}"""["id"]

@test ["id", "value"] == keys(f"dict.json")
@test [1, true] == values(f"dict.json")

# int-array.json
save(f"int-array.json", [1,2,3])
@test [1,2,3] == parse(f"int-array.json")

open(f"int-array.json") do a
  push!(a, 5)
  push!(a, 6)
end
@test [1,2,3,5,6] == parse(f"int-array.json")

push!(f"int-array.json", 7)
@test [1,2,3,5,6,7] == parse(f"int-array.json")

# int-dict.json
save(f"int-dict.json", Dict(2=>3))
@test Dict("2"=>3) == parse(f"int-dict.json")
open(f"int-dict.json") do d
  push!(d, 5=>6)
end
@test Dict("2"=>3, "5"=>6) == parse(f"int-dict.json")


# 0.5
for a ∈ f"array.json"
  idx,hello,world = a
  #println(idx, hello, world)
  break
end


for (k,v) ∈ f"dict.json"
  #println(k, v)
  break
end
