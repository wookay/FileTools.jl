using FileTools
using Base.Test

@testset "FileTools" begin
  @testset "JSONFile" begin
    include("jsonfile.jl")
  end
  
  @testset "TXTFile" begin
    include("txtfile.jl")
  end
end
