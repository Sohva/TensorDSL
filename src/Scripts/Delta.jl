using TensorDSL

function sign(per1, per2)
    changes = 0
    for i in 1:length(per1)
        if per1[i] != per2[i]
            changes += 1
            println(i, per1,  per2)
            j = findfirst(x -> (x == per1[i]), per2[(i+1):end]) + i
            per2[j] = per2[i]
            println(per2, j)
        end
    end
    return iseven(changes) ? 1 : -1
end

function getvalue(index, upper)
    upperindices = []
    lowerindices = []
    for i in 1:length(index)
        if upper[i]
            push!(upperindices, index[i])
        else
            push!(lowerindices, index[i])
        end
    end
    return (sort(upperindices) == sort(lowerindices) &&
            length(Set(upperindices)) == length(upperindices)) ? sign(lowerindices, upperindices) : 0
end

function shapetodelta(Vs::Vararg{AbstractVectorSpace})
    # Check the shape is legal
    DeltaTensor(Vs...)
    upper = [V isa DualVectorSpace for V in Vs]
    shape = [dim(V) for V in Vs]
    delta = Array{Int}(undef, shape...)
    indices = CartesianIndices(tuple(shape...))
    for index in indices
        delta[index] = getvalue(index, upper)
    end
    return delta
end



