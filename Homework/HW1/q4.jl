using Plots 
gr()

function q4(func,x,h)
	return(-25*func(x)+48*func(x+h)-36*func(x+2h)+16*func(x+3h)-3*func(x+4h))/(12*h);
end

func(x) = exp(x);

y1 = zeros(0);
y2 = zeros(0);
y3 = zeros(0);
y4 = zeros(0);

x1=exp10.(range(-3, -1, length=10000));
x2=exp10.(range(-20, -1, length=10000));
for i=1:length(x1)
	append!(y1,q4(func,1,x1[i]))
	append!(y2,exp(1)-y1[i])
	append!(y3,q4(func,1,x2[i]))
        append!(y4,exp(1)-y3[i])
end
p1=plot(x1,y1,xaxis=:log,label="h from 1e-3 to 1e-1");
p2=plot(x1,y2,xaxis=:log,label="error1");
p3=plot(x2,y3,xaxis=:log,label="h from 1e-20 to 1e-1");
p4=plot(x2,y4,xaxis=:log,label="error2");

plot(p1,p2,p3,p4,layout=(2,2));


