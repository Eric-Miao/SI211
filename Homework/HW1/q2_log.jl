using Plots
gr()
function q2(x)
	(1-cos(x))/x^2;
end

x1=exp10.(range(-15, -1, length=5000));
y1=zeros(0);

for i=1:length(x1)
	append!(y1,q2(x1[i]));
end

x2=(range(1e-15, 1e-1, length=5000));
y2=zeros(0);

for i=1:length(x2)
        append!(y2,q2(x2[i]));
end

p1=plot(x1,y1,xaxis=:log,label="LogRange");
p2=plot(x2,y2,xaxis=:log,label="LinRange");
plot(p1,p2,layout=(2,1));
