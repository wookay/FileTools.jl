using FileTools
using Base.Test

# hello.txt
@test TXTFile("hello.txt") == f"hello.txt"
@test TXTFile == typeof(f"hello.txt")
@test 2 == length(f"hello.txt")
@test 12 == filesize(f"hello.txt")
@test f"hello.txt"[1] == split("""hello\nworld""",'\n')[1]
@test f"hello.txt"[1:end] == split("""hello\nworld""",'\n')

# int-array.txt
save(f"int-array.txt", "1\n2\n3")
@test ["1","2","3"] == parse(f"int-array.txt")

open(f"int-array.txt") do a
  push!(a, "5")
  push!(a, "6")
end
@test ["1","2","3","5","6"] == parse(f"int-array.txt")

push!(f"int-array.txt", "7")
@test ["1","2","3","5","6","7"] == parse(f"int-array.txt")

# 0.5 
# for a ∈ f"hello.txt"
for a in f"hello.txt"
  (word,) = a
  println(word)
  break
end
