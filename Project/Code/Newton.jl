include("adf.jl")
function Newton(f,x0)
    x=[];
    append!(x,x0);
    h=10^(-5.0);
    J=Jacobian(f)
    while true
        lastx=last(x)
        j=J(lastx)
        newx=lastx-f(lastx)/j[1]
        append!(x,newx)
        if abs(lastx-newx)<h
            break
        end
        println(lastx,' ',f(lastx),' ',j[1],' ',newx,' ')
        if length(x)>4
            break
        end
    end
    return x
end

