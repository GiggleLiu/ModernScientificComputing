using Printf

types = [
    ComplexF64,
    Complex{AbstractFloat},
    Complex{<:AbstractFloat},
    AbstractFloat,
    Union{Float64, ComplexF64},
    Int32,
    Matrix{Float32},
    Base.RefValue
]

println("| Type | Concrete | Primitive | Abstract | Bits type | Mutable |")
println("|------|----------|-----------|----------|-----------|---------|")

for T in types
    concrete = isconcretetype(T)
    primitive = isprimitivetype(T)
    abstract = isabstracttype(T)
    bits_type = isbitstype(T)
    mutable = ismutabletype(T)
    
    @printf("| %-24s| %-8s | %-9s | %-8s | %-9s | %-7s |\n", string(T), concrete, primitive, abstract, bits_type, mutable)
end

