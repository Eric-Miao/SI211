# This is the code for natural cubic spline
macro assert(ex)
	return :( $ex ? nothing : throw(AssertionError($(string(ex)))) )
end

# The following are algorithms from the book
function NCP(X,Y)
    Y = [convert(Float64,y) for y in Y]
    X = [convert(Float64,x) for x in X]

	n = length(X)
    h = (X[n]-X[1])/n
    convert(Float64,h)

	alpha=zeros(n-1)
	l=zeros(n)
	l[1]=1
	mu=zeros(n-1)
	z=zeros(n)
	
	a=Y
	b=zeros(n-1)
	c=zeros(n)
	d=zeros(n-1)

	for i=2:n-1
		alpha[i]=3*(a[i+1]+a[i-1])/h 
	end	
	
	for i=2:n-1
		l[i]=2(X[i+1]-X[i-1])-h*mu[i-1]
		mu[i]=h/l[i]
		z[i]=(alpha[i]-h*z[i-1])/l[i]
	end

	l[n]=1
	z[n]=0
	c[n]=0
	
	for i=n-1:1
		c[i]=z[i]-mu[i]*c[i+1]
		b[i]=(a[i+1]-a[i])/h-h*(c[i+1]+2*c[i])/3
		d[i]=(c[i+1]-c[i])/(3*h)
	end
	return [a,b,c,d]
end


# the function returns an array consisting arrays of coefficients.
function spline(X,Y)
	n = length(X)
	convert(Float64,n)
	#h = (X[n]-X[1])/n
	h=1
	convert(Float64,h)	
	Y = [convert(Float64,y) for y in Y]
	X = [convert(Float64,x) for x in X]

	# For simplification, all the h are identical 
	R=[]
	H=[]
	for i=2:n-1
		temp = zeros(Float64,1,n-2)
		if i == 2	
			temp[1] = 4*h
			temp[2] = h
			H = temp
		else
			temp[i-2] = h
			temp[i-1] = 4*h
			if i!= n-1
				temp[i] = h
			end
			H = [H;temp]
		end
		
		r = 3*(Y[i+1]-2*Y[i]+Y[i-1])/h
		if i== 2
			R=[r]
		else
			R=[R;r]
		end
	end

	C=H\R
	
	append!(C,0)
	pushfirst!(C,0)
	
	A = Y
	B=Float64[0]
	D=Float64[0]
	
	for i = 1:n-1
		b = (A[i+1]-A[i])/h - C[i]*h - (C[i+1]-C[i])*h/3
		d = (C[i+1]-C[i])/(3*h)
		if i==2
			B[1]=b
			D[1]=d
		else
			B = [B;b]
			D = [D;d]
		end
	end
	
	return [A,B,C,D]	

end
