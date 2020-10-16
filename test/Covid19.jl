@testset "Parsing the age group information" begin
    @testset "parseage" begin
        age = Hamburg.Covid19.parseage("bis 12 Jahre")
        @test age == 0:12

        age = Hamburg.Covid19.parseage("bis 5 Jahre")
        @test age == 0:5

        age = Hamburg.Covid19.parseage("über 5 Jahre")
        @test age == 5
    end
end