# 1.
What is the einsum notation for outer product of two vectors?
The einsum notation for the outer product of two vectors is:
$$i,j\to ij$$

# 2. 
What does the einsum notation "jk,kl,lm,mj->" stands for?

It stands for trace of multipulication of four matrices, given by

The einsum notation "jk,kl,lm,mj->" represents a tensor contraction operation between four tensors. Each letter represents a dimension of the corresponding tensor. Also, it stands for trace of multipulication of four matrices, where:

$$Tr(ABCD)=\sum_{j,k,l,m}A_{jk}B_{kl}C_{lm}D_{mj}$$


# 3 
The tensor network "abc,cde,efg,ghi,ijk,klm,mno->abdfhjlno" is known as matrix product state in physics or tensor train in mathematics. Please
## 1. 
see 1.png

## 2.
Step 1: 
$$
abc,pbq \to acpq\\
cde,pdr \to ceqr\\
efr,gfs \to egrs\\
ghi,sht \to gist\\
ijk,tju \to iktu\\
klm,ulv \to kmuv\\
mno,vnw \to movw\\
$$
time cost: $7\times n^{5}$
Step 2:
$$
acpq,ceqr \to aepr
aepr,egrs \to agps
...
ampv,movw \to aopw
$$
time cost: $6\times n^{6}$
so, the total time cost will be $7\times n^{5}+6\times n^{6}$

## 3
```julia
julia> using LinearAlgebra

julia> using OMEinsum

julia> using Test
```

```julia
julia> eincode = ein"abc,cde,efg,ghi,ijk,klm,mno,pbq,qdr,rfs,sht,tju,ulv,vnw->apow"
abc, cde, efg, ghi, ijk, klm, mno, pbq, qdr, rfs, sht, tju, ulv, vnw -> apow
```

```julia
julia> optimized_eincode = optimize_code(eincode, uniformsize(eincode, 2), TreeSA())
SlicedEinsum{Char, DynamicNestedEinsum{Char}}(Char[], acpq, cqwo -> apow
├─ abc, pbq -> acpq
│  ├─ abc
│  └─ pbq
└─ cqit, tiwo -> cqwo
   ├─ ceqr, iert -> cqit
   │  ├─ cde, qdr -> ceqr
   │  │  ├─ cde
   │  │  └─ qdr
   │  └─ hief, rfht -> iert
   │     ├─ ghi, efg -> hief
   │     │  ├─ ghi
   │     │  └─ efg
   │     └─ rfs, sht -> rfht
   │        ├─ rfs
   │        └─ sht
   └─ tuik, ukwo -> tiwo
      ├─ tju, ijk -> tuik
      │  ├─ tju
      │  └─ ijk
      └─ uvkm, vwmo -> ukwo
         ├─ ulv, klm -> uvkm
         │  ├─ ulv
         │  └─ klm
         └─ vnw, mno -> vwmo
            ├─ vnw
            └─ mno
)
```



```julia
julia> contraction_complexity(optimized_eincode, uniformsize(optimized_eincode, 2))
Time complexity (number of element-wise multiplications) = 2^9.247927513443585
Space complexity (number of elements in the largest intermediate tensor) = 2^4.0
Read-write complexity (number of element-wise read and write) = 2^9.0

```

compare the result by OMEinsum and my result(n=2)

```julia

julia> 2^9.247927513443585 ≈ 19 * 2^5
true

```
Credits to Xuanzhao Gao