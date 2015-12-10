module FileTools

__precompile__(true)

export @f_str

abstract AbstractFile

macro f_str(filename)
  name,format = splitext(filename)
  support(filename, Val{symbol(format)})
end


include("jsonfile.jl")

end # module
