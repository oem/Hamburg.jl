@testset "Parsing the age group information" begin
    @testset "parseage" begin
        @test Hamburg.Covid19.parseage("bis 12 Jahre") == 0:12
        @test Hamburg.Covid19.parseage("bis 5 Jahre") == 0:5
        @test Hamburg.Covid19.parseage("über 5 Jahre") == 5
        @test Hamburg.Covid19.parseage("40 bis 49 Jahre") == 40:49
        @test_throws ArgumentError Hamburg.Covid19.parseage("moo")
    end
end