--By Trey Reynolds

--A simple vector3 class.
--Make a new v3 with: v3(x,y,z)
--Supports unm, add, sub, mul, div, pow, tostring, and concat.
--Supports unit with vec:unit()
--Supports magnitude with vec^1
--mul is defined as dot product
--cross product is done with vec^vec

local v3 do
	local type=type
	local setmt=setmetatable
	local meta={}
	local unit

	local function new(x,y,z)
		local self={
			x=x or 0;
			y=y or 0;
			z=z or 0;
			unit=unit;
		}
		return setmt(self,meta)
	end

	function unit(a)
		local ax,ay,az=a.x,a.y,a.z
		local m=(ax*ax+ay*ay+az*az)^0.5
		return new(ax/m,ay/m,az/m)
	end

	meta.__metatable="v3"

	function meta.__unm(a)
		return new(-a.x,-a.y,-a.z)
	end

	function meta.__add(a,b)
		return new(a.x+b.x,a.y+b.y,a.z+b.z)
	end

	function meta.__sub(a,b)
		return new(a.x-b.x,a.y-b.y,a.z-b.z)
	end

	function meta.__mul(a,b)
		if type(a)=="number" then
			return new(a*b.x,a*b.y,a*b.z)
		elseif type(b)=="number" then
			return new(b*a.x,b*a.y,b*a.z)
		else
			return a.x*b.x+a.y*b.y+a.z*b.z
		end
	end

	function meta.__div(a,b)
		if type(a)=="number" then
			local bx,by,bz=b.x,b.y,b.z
			local c=a/(bx*bx+by*by+bz*bz)
			return new(c*bx,c*by,c*bz)
		elseif type(b)=="number" then
			return new(a.x/b,a.y/b,a.z/b)
		else
			local bx,by,bz=b.x,b.y,b.z
			return (a.x*bx+a.y*by+a.z*bz)/(bx*bx+by*by+bz*bz)
		end
	end

	--Actual justifyable math ends here
	--Bullshit starts here
	function meta.__pow(a,b)
		if type(b)=="number" then
			local ax,ay,az=a.x,a.y,a.z
			return (ax*ax+ay*ay+az*az)^(b/2)
		else
			local ax,ay,az=a.x,a.y,a.z
			local bx,by,bz=b.x,b.y,b.z
			return new(ay*bz-az*by,az*bx-ax*bz,ax*by-ay*bx)
		end
	end

	--Bullshit ends here
	function meta.__tostring(a)
		return "("..a.x..", "..a.y..", "..a.z..")"
	end

	function meta.__concat(a,b)
		return tostring(a)..tostring(b)
	end

	v3=new
end

return v3
