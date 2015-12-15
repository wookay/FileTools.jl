# JSONFile.jl

using JSON, DataStructures

import Base: ==, getindex
import Base: length, filesize, start, next, done, parse, open, push!, keys, values, map, endof
export JSONFile, save, @json_str

type JSONFile <: AbstractFile
  path::AbstractString
  data::Any
  JSONFile(path) = new(path, nothing)
end

type JSONFileIO
  file::JSONFile
  isdirty::Bool
end

function support(filename::AbstractString, ::Type{Val{symbol(".json")}})
  JSONFile(filename)
end

macro json_str(data::AbstractString)
  JSON.parse(data)
end

function ==(a::JSONFile, b::JSONFile)
  a.path == b.path
end

function parse(file::JSONFile)
  if nothing == file.data
    file.data = JSON.parsefile(file.path, dicttype=DataStructures.OrderedDict)
  end
  file.data
end

function open(fn::Function, file::JSONFile)
  parse(file)
  io = JSONFileIO(file, false) 
  fn(io)
  if io.isdirty
    save(file, io.file.data)
  end
end

function save(file::JSONFile, data)
  f = open(file.path, "w")
  write(f, JSON.json(data))
  close(f)
end

function push!(file::JSONFile, data::Any)
  open(file) do io
    push!(io, data)
  end
end

function push!(io::JSONFileIO, data::Any)
  if isa(io.file.data, AbstractArray)
    push!(io.file.data, data)
    io.isdirty = true
  elseif isa(io.file.data, Associative)
    if isa(data, Pair)
      setindex!(io.file.data, data.second, string(data.first))
      io.isdirty = true
    end
  else
    # error
  end
end

map(fn::Function, file::JSONFile) = map(fn, parse(file))

length(file::JSONFile) = length(parse(file))
filesize(file::JSONFile) = filesize(file.path) 

# indexing
getindex(file::JSONFile, a::Any) = getindex(parse(file), a)

# iterators
start(f::JSONFile) = start(parse(f))
next(file::JSONFile, i) = next(parse(file), i)
done(file::JSONFile, i) = done(parse(file), i)
endof(file::JSONFile) = endof(parse(file))


# dict
keys(file::JSONFile) = collect(keys(parse(file)))
values(file::JSONFile) = collect(values(parse(file)))
