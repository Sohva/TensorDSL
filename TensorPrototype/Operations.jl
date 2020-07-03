include("Node.jl")
include("Tensors.jl")
include("Indices.jl")

import Base

abstract type Operation <: Node end

struct Add <: Operation
    shape
    children::Tuple{Vararg{Node}}
end

function +(nodes::Vararg{Node})
    if length(nodes) > 1
        for node in nodes[2:length(nodes)]
            if node.shape != nodes[1].shape
                # TODO: Better error message
                error("Shapes don't match")
            end
        end
    end
    return Add(nodes[1].shape, nodes)
end

struct IndexOperation <: Operation
    shape
    children::Tuple{Vararg{Node}}
end

function Base.getindex(AbstractTensor, ConcreteIndex)
    println("Cool")
end
