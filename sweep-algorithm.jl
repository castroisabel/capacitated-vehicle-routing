using LinearAlgebra

# Coordinates of 16 cities
coord = [ 228 1;
          912 1;
          1 80;
          114 80;
          570 160;
          798 160;
          342 240;
          684 240;
          570 400;
          912 400;
          114 480;
          228 480;
          342 560;
          684 560;
          1 640;
          798 640]

# Demand of each city
demand = [1, 1, 2, 4, 2, 4, 8, 8, 1, 2, 1, 2, 4, 4, 8, 8]
# Vehicle capacity
capacity = 20
global available_capacity = capacity
global route = []

n = length(demand)
teta = zeros(Float64,n)
for i in 1:n
    teta[i] = atan(coord[i,1]/coord[i,2])
end

sequence = sortperm(teta)
println("Sequence: ",sequence)
append!(route,[0])

for i in 1:n
    if demand[sequence[i]] <= available_capacity
        append!(route,sequence[i])
        global available_capacity = available_capacity - demand[sequence[i]]
    else
        append!(route,[0])
        available_capacity = capacity
        append!(route,sequence[i])
        global available_capacity = available_capacity - demand[sequence[i]]
    end
end

append!(route,[0])
println("Route: ",route)

# Distance matrix
matrix = rand(n,n)
for i in 1:n
    for j in 1:n
        matrix[i,j] = round(sqrt((coord[i,1]-coord[j,1])^2 + (coord[i,2]-coord[j,2])^2),digits=1)
    end
end 

function calculate_cost(c, way)
    #= Function to calculate the total cost value (total distance).

    Args: 
        c (matrix of floats): cost matrix
        way (list of integers): transport route

    Returns: 
        float: total distance =#

    cost = 0
    for i=1:length(way)-1
        city_A = way[i]
        city_B = way[i+1]
        if (city_A!=0) & (city_B!=0)   
            cost = cost + c[city_A,city_B]
        elseif (city_A==0)
            cost = cost + round(sqrt(coord[way[i+1],1]^2 + coord[way[i+1],2]^2),digits=1)
        else
            cost = cost + round(sqrt(coord[way[i],1]^2 + coord[way[i],2]^2),digits=1)
        end
    end
    return cost
end 

total = calculate_cost(matrix, route)
println("Total distance: ", total)
