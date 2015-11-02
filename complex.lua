--By Trey Reynolds

--This is one of my more 'proper' classes with actual documentation.
--Plays well with numbers.
--Optimized for Lua

--[[
Constructor Functions
	complex.new([Real,Imaginary])
		>complex Number

	complex.FromPolar(Radius,Angle)
		>complex Number constructed from a Radius and Angle

Print Function
	complex.Print(...)
		Works exactly as print does, but works with complex library
		>nil

Object Functions
	complexNumber:topolar()
		>Radius, Angle								(Number Types)

	complexNumber:floor(n)
		If n is provided, rounds complexNumber down to nearest multiple of n
		>Rounded down components of complexNumber	(complex Type)

	complexNumber:ceil(n)
		If n is provided, rounds complexNumber up to nearest multiple of n
		>Rounded up components of complexNumber		(complex Type)

	complexNumber:round(n)
		If n is provided, rounds complexNumber to nearest multiple of n
		>Rounded components of complexNumber		(complex Type)

	complexNumber:arg()
		>complex argument of complexNumber			(Number Type)

	complexNumber:conjugate()
		>complex conjugate of complexNumber			(complex Type)

	complexNumber:log()
		>complex Natural logorithm of complexNumber	(complex Type)

	complexNumber:magnitude()
		>complex Magnitude of <Real,Imaginary>		(Number Type)

	complexNumber:tostring([Number Accuracy])
		>String of the form Real+Imaginaryi			(String type)

Supported Operators:
	-	Unary
	+	Addition
	-	Subtraction
	%	Modulus
	*	Multiplication
	/	Division
	^	Exponentiation
	..	Concatination
	
	Operators work exactly as their native Lua counterparts
]]

local complex={}
do
	local meta={}

	local setmt=setmetatable
	local getmt=getmetatable
	local type=type
	local atan2=math.atan2
	local cos=math.cos
	local sin=math.sin
	local ln=math.log
	local unpack=unpack
	local print=print

	local newcomplex

	local function topolar(c)
		local r,i=c.r,c.i
		return (r*r+i*i)^0.5,atan2(i,r)
	end
	local function floor(c,n)
		n=n or 1
		local r,i=c.r,c.i
		return newcomplex(r-r%1,i-i%1)
	end
	local function ceil(c,n)
		n=n or 1
		local r,i=c.r,c.i
		return newcomplex(r+-r%1,i+-i%1)
	end
	local function round(c,n)
		n=n or 1
		local hn=n/2
		local r,i=c.r+hn,c.i+hn
		return newcomplex(r-r%n,i-i%n)
	end
	local function arg(c)
		return atan2(c.i,c.r)
	end
	local function log(c)
		local r,i=c.r,c.i
		return newcomplex(ln(r*r+i*i)/2,atan2(i,r))
	end
	local function magnitude(c)
		local r,i=c.r,c.i
		return (r*r+i*i)^0.5
	end
	local function conjugate(c)
		return newcomplex(c.r,-c.i)
	end
	local function tostring(c,n)
		n=n and 10^-n or 0.0001
		local hn=n/2
		local r,i=c.r+hn,c.i+hn
		r,i=r-r%n,i-i%n
		return r..(i<0 and "-"..-i or "+"..i).."i"
	end

	function newcomplex(r,i)
		return setmt({
			r=r,i=i;
			topolar=topolar;
			floor=floor;
			ceil=ceil;
			round=round;
			arg=arg;
			log=log;
			magnitude=magnitude;
			conjugate=conjugate;
			tostring=tostring;
		},meta)
	end

	complex.i=newcomplex(0,1)

	function complex.new(r,i)
		return newcomplex(r or 0,i or 0)
	end
	function complex.FromPolar(r,t)
		return newcomplex(r*cos(t),r*sin(t))
	end
	function complex.Print(...)
		local l={...}
		for i=1,#l do local li=l[i]
			if type(li)=="table" and getmt(li)==meta then
				local lii=li.i
				l[i]=li.r..(lii<0 and "-"..-lii or "+"..lii).."i"
			end
		end
		print(unpack(l))
	end

	complex.topolar=topolar
	complex.floor=floor
	complex.ceil=ceil
	complex.round=round
	complex.arg=arg
	complex.log=log
	complex.magnitude=magnitude
	complex.conjugate=conjugate
	complex.tostring=tostring

	function meta.__unm(c)
		return newcomplex(-c.r,-c.i)
	end
	function meta.__add(a,b)
		if type(a)=="number" then
			return newcomplex(a+b.r,b.i)
		elseif type(b)=="number" then
			return newcomplex(a.r+b,a.i)
		else
			return newcomplex(a.r+b.r,a.i+b.i)
		end
	end
	function meta.__sub(a,b)
		if type(a)=="number" then
			return newcomplex(a-b.r,-b.i)
		elseif type(b)=="number" then
			return newcomplex(a.r-b,a.i)
		else
			return newcomplex(a.r-b.r,a.i-b.i)
		end
	end
	function meta.__mod(a,b)--May or may not work properly
		if type(a)=="number" then
			local br,bi=b.r,b.i
			local bri2=br*br+bi*bi
			local qr,qi=a*br/bri2,-a*bi/bri2
			local fr,fi=qr-qr%1,qi-qi%1
			return newcomplex(a-(br*fr-bi*fi),-(br*fi+bi*fr))
		elseif type(b)=="number" then
			local ar,ai=a.r,a.i
			local qr,qi=ar/b,ai/b
			local fr,fi=qr-qr%1,qi-qi%1
			return newcomplex(ar-b*fr,ai-b*fi)
		else
			local ar,ai,br,bi=a.r,a.i,b.r,b.i
			local bri2=br*br+bi*bi
			local qr,qi=(ar*br+ai*bi)/bri2,(ai*br-ar*bi)/bri2
			local fr,fi=qr-qr%1,qi-qi%1
			return newcomplex(ar-(br*fr-bi*fi),ai-(br*fi+bi*fr))
		end
	end
	function meta.__mul(a,b)
		if type(a)=="number" then
			return newcomplex(a*b.r,a*b.i)
		elseif type(b)=="number" then
			return newcomplex(a.r*b,a.i*b)
		else
			local ar,ai,br,bi=a.r,a.i,b.r,b.i
			return newcomplex(ar*br-ai*bi,ar*bi+ai*br)
		end
	end
	function meta.__div(a,b)
		if type(a)=="number" then
			local br,bi=b.r,b.i
			local bri2=br*br+bi*bi
			return newcomplex(a*br/bri2,-a*bi/bri2)
		elseif type(b)=="number" then
			return newcomplex(a.r/b,a.i/b)
		else
			local ar,ai,br,bi=a.r,a.i,b.r,b.i
			local bri2=br*br+bi*bi
			return newcomplex((ar*br+ai*bi)/bri2,(ai*br-ar*bi)/bri2)
		end
	end
	function meta.__pow(a,b)
		if type(a)=="number" then
			local br,bi=b.r,b.i
			local c=a^br
			local t=bi*ln(a)
			return newcomplex(c*cos(t),c*sin(t))
		elseif type(b)=="number" then
			local ar,ai=a.r,a.i
			local c=(ai*ai+ar*ar)^(b/2)
			local t=b*atan2(ai,ar)
			return newcomplex(c*cos(t),c*sin(t))
		else
			local ar,ai,br,bi=a.r,a.i,b.r,b.i
			local air2=ai*ai+ar*ar
			local arg=atan2(ai,ar)
			local c=air2^(br/2)/2.718281828459045^(bi*arg)
			local t=br*arg+bi*ln(air2)/2
			return newcomplex(c*cos(t),c*sin(t))
		end
	end
	function meta.__len(c)
		local r,i=c.r,c.i
		return (r*r+i*i)^0.5
	end
	function meta.__concat(a,b)
		if type(b)~="table" then
			local i=a.i
			return a.r..(i<0 and "-"..-i or "+"..i).."i"..b
		elseif type(a)~="table" then
			local i=b.i
			return a..b.r..(i<0 and "-"..-i or "+"..i).."i"
		else
			local ai,bi=a.i,b.i
			return a.r..(ai<0 and "-"..-ai or "+"..ai).."i"..b.r..(bi<0 and "-"..-bi or "+"..bi).."i"
		end
	end
	function meta.__tostring(c)
		local r,i=c.r+0.00005,c.i+0.00005
		r,i=r-r%0.0001,i-i%0.0001
		return r..(i<0 and "-"..-i or "+"..i).."i"
	end
	function meta.__eq(a,b)
		return a.r==b.r and a.i==b.i
	end
end

return complex
