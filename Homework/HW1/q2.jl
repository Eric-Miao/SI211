import Pkg
using GR

function q2(x)
	(1-cos(x))/x^2;
end

x=LinRange(1e-15,1e-1,1000);
y=zeros(0);
for i=1:length(x)
	append!(y,q2(x[i]));
end
plot(x,y,xlog=true);
png("q2.png")
