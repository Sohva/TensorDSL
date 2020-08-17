using TensorDSL

V4 = VectorSpace(4)
V67 = VectorSpace(67)
V3 = VectorSpace(3)

A = VariableTensor("A", V4, V4, V3, V67)
B = VariableTensor("B", V4, V4, V3, V67)
C = VariableTensor("C", V67', V3')

a = FreeIndex(V4, "a")
b = FreeIndex(V4, "b")
x = FreeIndex(V67, "x")
y = FreeIndex(V3, "y")

expr = componenttensor((A + B)[a, b, y, x] ⊗ C[x', y'], a, b) + componenttensor(B[a, b, 3, 1], a, b)
expr = (expr - expr)⊗A + (3*expr)⊗B
expr = ((expr[1] + expr[2])⊗B)[1, 3]⊗componenttensor(C[x', y'], y', x')
expr = (expr + expr + expr) ⊗ expr[1, 2]
@time assign(expr, B => Tensor(fill(2.4, (4,4,3,67)), V4, V4, V3, V67))
println(expr.shape)
println("Cool")
#  9.337623 seconds (12.96 M allocations: 648.051 MiB, 2.39% gc time)  with Robin Dict
# 7.041283 seconds (8.94 M allocations: 451.938 MiB, 2.16% gc time) with normal dictionary
# 4.905401 seconds (5.94 M allocations: 309.664 MiB, 2.16% gc time) without a dictionary