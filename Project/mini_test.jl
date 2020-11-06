
function minif(x)
	f1=x[3]*x[3]+10*x[1]+x[1]*x[2]+cos(x[2])
	f2=x[1]*x[2]*x[3]
	f3=0
	a=1
	b=1
	for i=1:length(x)
		f3+=x[i]*x[1]
		b=cos(x[i])+a
		a=10.24*b
	end
	f4=b;
	return [f1,f2,f3,f4]
end	