x = 8 + 5
print(x)

#y::Float64 = 3.14

#name::String = "Hola!!"
#print("Nombre: " + name)

# Type declarations on global variables not yet supported.

for i in 1:10
    println(i)
end

arr = Array{Int64}(undef, 10)
println(arr)

arr2 = collect(1:6)
println(arr2)
push!(arr2, 15)
println(arr2)

arr3 = [1,2,6,8]
for x in arr3
    println(x)
end

append!(arr3, [10,15])
println(arr3)

# Producto punto a punto.
a1 = [1,2,4]
a2 = [2,6,10]
println(a1.*a2)

# Dot algebra.
using LinearAlgebra
x = LinearAlgebra.dot(a1,a2)
println(x)
