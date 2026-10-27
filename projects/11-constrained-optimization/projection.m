function proj = projection(X)
%PROJECTIOΝ : suppose a given space of values for our variables
%and a vector with 2 elements. If any one of the vector elements
%are out of bounds we use this function to project it in the nearest edge
%of the given space.
a=[-10,5];
b=[-8,12];

if X(1)<a(1)
    X(1)=a(1);
elseif X(1)>a(2)
    X(1)=a(2);
end

if X(2)<b(1)
    X(2)=b(1);
elseif X(2)>b(2)
    X(2)=b(2);
end

proj=X;
end