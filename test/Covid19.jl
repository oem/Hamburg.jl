using Dates

@testset "Parsing the age group information" begin
    @testset "parseage" begin
        @test Hamburg.Covid19.parseage("bis 12 Jahre") == 0:12
        @test Hamburg.Covid19.parseage("bis 5 Jahre") == 0:5
        @test Hamburg.Covid19.parseage("über 5 Jahre") == 5
        @test Hamburg.Covid19.parseage("40 bis 49 Jahre") == 40:49
        @test_throws ArgumentError Hamburg.Covid19.parseage("moo")
    end
end

@testset "parsing dates that are written in german" begin
    @test Hamburg.Covid19.DatesInGerman.parsefrom("Stand: Sonnabend, 17. Oktober 2020") == Date(2020, 10, 17)
    @test Hamburg.Covid19.DatesInGerman.parsefrom("Stand: 12. Oktober 2020;") == Date(2020, 10, 12)
    @test Hamburg.Covid19.DatesInGerman.parsefrom("(Stand: 03.11.20)", inwords=false) == Date(2020, 11, 3)
end
