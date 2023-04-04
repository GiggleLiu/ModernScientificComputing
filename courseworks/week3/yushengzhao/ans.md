

# Problem 1

    begin
        type_arr = [ComplexF64;Complex{AbstractFloat};Complex{<:AbstractFloat};
                    AbstractFloat;Union{Float64, ComplexF64};
                    Int32;Matrix{Float32};Base.RefValue];
    
        for aType in type_arr
            print("|",aType)
            print("|",isconcretetype(aType))
            print("|",isprimitivetype(aType))
            print("|",isabstracttype(aType))
            print("|",isbitstype(aType))
            print("|",ismutable(aType))
            println("|")
        end
    end

    |ComplexF64|true|false|false|true|true|
    |Complex{AbstractFloat}|true|false|false|false|true|
    |Complex{<:AbstractFloat}|false|false|false|false|false|
    |AbstractFloat|false|false|true|false|true|
    |Union{Float64, ComplexF64}|false|false|false|false|false|
    |Int32|true|true|false|true|true|
    |Matrix{Float32}|true|false|false|false|true|
    |Base.RefValue|false|false|false|false|false|

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Types</th>
<th scope="col" class="org-left">isconcrete</th>
<th scope="col" class="org-left">isprimitive</th>
<th scope="col" class="org-left">isabstract</th>
<th scope="col" class="org-left">isbitstype</th>
<th scope="col" class="org-left">ismutable</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">ComplexF64</td>
<td class="org-left">true</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">true</td>
<td class="org-left">true</td>
</tr>


<tr>
<td class="org-left">Complex{AbstractFloat}</td>
<td class="org-left">true</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">true</td>
</tr>


<tr>
<td class="org-left">Complex{&lt;:AbstractFloat}</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
</tr>


<tr>
<td class="org-left">AbstractFloat</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">true</td>
<td class="org-left">false</td>
<td class="org-left">true</td>
</tr>


<tr>
<td class="org-left">Union{Float64, ComplexF64}</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
</tr>


<tr>
<td class="org-left">Int32</td>
<td class="org-left">true</td>
<td class="org-left">true</td>
<td class="org-left">false</td>
<td class="org-left">true</td>
<td class="org-left">true</td>
</tr>


<tr>
<td class="org-left">Matrix{Float32}</td>
<td class="org-left">true</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">true</td>
</tr>


<tr>
<td class="org-left">Base.RefValue</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
<td class="org-left">false</td>
</tr>
</tbody>
</table>


# Problem 2


## Part a

-   I did it.


## Part b

-   See `brownian.jl`

