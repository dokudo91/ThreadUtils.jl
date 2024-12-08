"""
    tmap(f, A, T)
    tmap(f, A::AbstractArray{T}) where {T}
    tmap!(f, A::AbstractArray)

# Example
```jldoctest
julia> tmap(x->x*2, 1:5)
5-element Vector{Int64}:
  2
  4
  6
  8
 10
```
"""
function tmap(f, A, T)
    enumA = enumerate(A) |> collect
    a = Array{T}(undef, size(enumA)...)
    Threads.@threads for (i, x) in enumA
        a[i] = f(x)
    end
    a
end
tmap(f, A::AbstractArray{T}) where {T} = tmap(f, A, T)
function tmap!(f, A::AbstractArray)
    Threads.@threads for (i, x) in enumerate(A) |> collect
        A[i] = f(x)
    end
    A
end

"""
    pick(predicate, A)

# Example
```jldoctest
julia> pick(==(15), 10:20)
15
```
"""
function pick(predicate, A)
    index = Threads.Atomic{Int}()
    Threads.@threads for (i, x) in enumerate(A) |> collect
        index[] > 0 && break
        if predicate(x)
            index[] = i
        end
    end
    if index[] > 0
        A[index[]]
    end
end

"""
    tfilter(f, A)

# Example
```jldoctest
julia> tfilter(isodd, 1:5)
3-element Vector{Int64}:
 1
 3
 5
```
"""
function tfilter(f, A)
    collectA = A |> collect
    bools = tmap(f, collectA, Bool)
    collectA[bools]
end