# TXTFile.jl

import Base: ==, getindex
import Base: length, filesize, start, next, done, parse, open, push!, keys, values, map, endof
export TXTFile, save

type TXTFile <: AbstractFile
  path::AbstractString
  data::Union{AbstractArray,Void}
  TXTFile(path) = new(path, nothing)
end

type TXTFileIO
  file::TXTFile
  isdirty::Bool
end

function support(filename::AbstractString, ::Type{Val{symbol(".txt")}})
  TXTFile(filename)
end

function ==(a::TXTFile, b::TXTFile)
  a.path == b.path
end

function parse(file::TXTFile)
  if nothing == file.data
    f = open(file.path)
    file.data = map(rstrip, readlines(f))
    close(f)
  end
  file.data
end

function open(fn::Function, file::TXTFile)
  parse(file)
  io = TXTFileIO(file, false) 
  fn(io)
  if io.isdirty
    save(file, join(io.file.data, '\n'))
  end
end

function save(file::TXTFile, data)
  f = open(file.path, "w")
  write(f, data)
  close(f)
end

function push!(file::TXTFile, data::Any)
  open(file) do io
    push!(io, data)
  end
end

function push!(io::TXTFileIO, data::Any)
  push!(io.file.data, data)
  io.isdirty = true
end

map(fn::Function, file::TXTFile) = map(fn, parse(file))

length(file::TXTFile) = length(parse(file))
filesize(file::TXTFile) = filesize(file.path) 

# indexing
getindex(file::TXTFile, a::Any) = getindex(parse(file), a)

# iterators
start(f::TXTFile) = start(parse(f))
next(file::TXTFile, i) = next(parse(file), i)
done(file::TXTFile, i) = done(parse(file), i)
endof(file::TXTFile) = endof(parse(file))


# dict
keys(file::TXTFile) = collect(keys(parse(file)))
values(file::TXTFile) = collect(values(parse(file)))
