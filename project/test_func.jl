function f(x)
	a = 1;
	b = 1;
	for i=1:length(x)
		y = 0.3*sin(a)+0.4*b;
		z = 0.1*a+0.3*cos(b)+x[i];
		a = y;
		b = z;
	end
	return [a;b];
end