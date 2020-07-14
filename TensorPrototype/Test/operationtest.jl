include("../Operations.jl")
using Test

V3 = VectorSpace(3)
V2 = VectorSpace(2)
Vi = VectorSpace()
Vj = VectorSpace()

x = FreeIndex(V3, "x")
y = FreeIndex(V2, "y")
z = FreeIndex(Vi, "z")
w = FreeIndex(Vj, "w")

A = VariableTensor(V3, V2)
B = Tensor(fill(1.2, (3, 2)), V3, V2)
C = VariableTensor(Vj, Vi, dual(Vi))
@testset "Operations" begin
    @testset "Addition" begin
        @test (A + B).shape == A.shape
        @test (A + B).children == (A, B)
        @test (A[x,1] + B[1, y]).freeindices == Set([x, y])
        @test_throws ErrorException A[x, y] + B
    end
    @testset "Index" begin
        @test A[x, 1].shape == ()
        @test A[x, 1].freeindices == Set([x])
        @test_throws ErrorException A[x, x]
        @test A[x].shape == (V2,)
        @test A[x] isa ComponentTensorOperation
    end
    @testset "Outer product" begin
        @test (A⊗B).shape == (V3, V2, V3, V2)
        @test (A⊗B).children == (A, B)
        @test (A[x,1] ⊗ B[1, y]).freeindices == Set([x, y])
        @test (A - B).shape == (V3, V2)
        @test (-B).shape == (V3, V2)
        @test (A - B) isa AddOperation
    end
    @testset "Component tensor" begin
        @test componentTensor(A[x, 1], x).shape == (V3,)
        @test componentTensor(A[x, y], y).shape == (V2,)
        @test componentTensor(componentTensor(A[x, y], y), x).shape == (V2, V3)
    end
    @testset "Index sum" begin
        @test indexsum(C[w, z, z'], z).shape == ()
        @test indexsum(C[w, z, z'], z).freeindices == Set([w])
        @test indexsum(C[w, z, z'], z).children[2] == Indices(z)
    end
end
