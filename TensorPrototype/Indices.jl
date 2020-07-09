include("Node.jl")
include("VectorSpace.jl")

abstract type Index end

struct FreeIndex <: Index
    name::String
    V::AbstractVectorSpace
end

Base.adjoint(i::FreeIndex) = FreeIndex(i.name, dual(i.V))

struct FixedIndex <: Index
    value::Int
    V::AbstractVectorSpace
    function FixedIndex(value::Int, V::AbstractVectorSpace)
        if value < 1 || value > dim(V)
            error("Index not in range")
        end
        new(value, V)
    end
end

Base.adjoint(i::FixedIndex) = FixedIndex(i.value, dual(i.V))

struct Indices <: Node
    indices
    children
end

Indices(indices::Vararg{Index}) = Indices(indices, ())

function toindex(i::Int, V::AbstractVectorSpace)
    return FixedIndex(i, V)
end

function toindex(s::String, V::AbstractVectorSpace)
    return FreeIndex(s, V)
end
