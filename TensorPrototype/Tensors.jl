include("Node.jl")
include("VectorSpace.jl")
include("Indices.jl")

import Base

abstract type AbstractTensor <: Node end

struct ScalarVariable
    name::String
end

Scalar = Union{ScalarVariable, Base.Complex, Base.Real}

struct VariableTensor <: AbstractTensor
    shape::Tuple{Vararg{AbstractVectorSpace}}
    children::Tuple{}
    freeindices::Tuple{Vararg{FreeIndex}}
    # Field information?
end

VariableTensor(shape::Vararg{AbstractVectorSpace}) = VariableTensor(shape, (), ())

function checktensordimensions(x::AbstractArray, Vs::Vararg{AbstractVectorSpace})
    if size(x) == (1,) && length(Vs) == 0
    elseif ndims(x) != length(Vs)
        error("Wrong number of vector spaces")
    else
        for i in 1:ndims(x)
            if size(x)[i] != dim(Vs[i])
                error("Dimension does not match with vector space rank")
            end
        end
    end
end

struct Tensor{T<:Scalar} <: AbstractTensor
    value::Array{T}
    shape::Tuple{Vararg{AbstractVectorSpace}}
    children::Tuple{}
    freeindices::Tuple{Vararg{FreeIndex}}
    # TODO Check x consists of scalars, if possible
    function Tensor(x::Array{T}, Vs::Vararg{AbstractVectorSpace}) where (T<:Scalar)
        checktensordimensions(x, Vs...)
        new{T}(x, Vs, (), ())
    end
end

struct MixedTensor <: AbstractTensor
    value::AbstractArray
    shape::Tuple{Vararg{AbstractVectorSpace}}
    children::Tuple{}
    freeindices::Tuple{Vararg{FreeIndex}}
    # TODO Check x consists of scalars, if possible
    function MixedTensor(x::AbstractArray, Vs::Vararg{AbstractVectorSpace})
        checktensordimensions(x, Vs...)
        new(x, Vs,  (), ())
    end
end

function printtensor(io, s::String, A::AbstractTensor)
    print(io, typeof(A), ", ", s, "shape: ")
    if A.shape == ()
        print(io, "()")
    else
        print(io, A.shape[1])
        for V in A.shape[2:end]
            print(io, "⊗ ",V)
        end
    end
end

Base.show(io::IO, A::Union{Tensor, MixedTensor}) = printtensor(io, string(A.value, ", "), A)

Base.show(io::IO, A::VariableTensor) = printtensor(io, "", A)
