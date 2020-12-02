Using Plot
function f(x,y)
    return (x-1)^2/2+(10*(y-x^2)^2)/2+y^2/2
end

function F(x,y)
    return [x-1;10*(y-x^2);y]
end

function grad(x,y)
    return [200*x^3-200*x*y+x-1 -100*x^2+101*y]
end

function H(x,y)
    return [600*x-200*y+1 -200*x;-200*x 101]
end

function R(x,y)
    return [x-1; 10*(y-x^2); y]
end

function J(x,y)
    return [1 0;-20*x 10; 0 1]
end

function delta(x,y)
    return -inv(H(x,y))*transpose(J(x,y))*f(x,y)
end

function GN(x0,y0)
    X=[]
    Y=[]
    append!(X,x0)
    append!(Y,y0)
    h=10^(-3.0)
    while true
        lastx=last(X)
        lasty=last(Y)
        j = J(lastx,lasty)
        M=transpose(j)*j 

        (delta_x,delta_y) = -inv(M)*transpose(j)*F(lastx,lasty)
        newx = delta_x+lastx
        newy = delta_y+lasty
        append!(X,newx)
        append!(Y,newy)
        gradian=grad(newx,newy)
        sum=0
        for d in gradian
            sum+=d^2
        end
        sum=sqrt(sum)
        if sum<h 
            break
        end
    end
    return (X,Y)
end

plot(X,Y)   