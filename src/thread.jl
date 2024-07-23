"""
    tmap(f, A, T)
    tmap(f, A::AbstractArray{T}) where {T}

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
    a = Array{T}(undef, size(A)...)
    Threads.@threads for (i, x) in enumerate(A) |> collect
        a[i] = f(x)
    end
    a
end
tmap(f, A::AbstractArray{T}) where {T} = tmap(f, A, T)

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