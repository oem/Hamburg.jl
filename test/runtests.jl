using Hamburg
using DataFrames
using Test

include("Covid19.jl")

@testset "using `dataset()` to load datasets" begin
    @testset "loads existing datasets into a DataFrame" begin
        df = dataset("covid-19", "infected")
        @test isa(df, DataFrame)
        @test size(df)[1] > 0
    end

    @testset "throws an error when trying to load a non-existent dataset" begin
        @test_throws ArgumentError dataset("moo", "foo")
    end
end