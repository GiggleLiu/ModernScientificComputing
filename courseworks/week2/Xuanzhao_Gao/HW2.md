#Homework2

Xuanzhao Gao

## Q1

|type of  |is concrete|is primitive	|is abstract	|is bits type	|is mutable|
|    :----:   |    :----:   |    :----:   |    :----:   |    :----:   | :----:   |
|ComplexF64| true | false | false | true | false | 
|Complex{AbstractFloat}| true | false | false | false | false | 
|Complex{<:AbstractFloat}| false | false | false | false | false | 
|AbstractFloat| false | false | true | false | false | 
|Union{Float64, ComplexF64}| false | false | false | false | false | 
|Int32| true | true | false | true | false | 
|Matrix{Float32}| true | false | false | false | true | 
|Base.RefValue| false | false | false | false | true | 

