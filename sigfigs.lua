--By Trey Reynolds

--A simple significant figures class for Lua.
--Plays well with numbers, and is pretty short and simple. Optimized for LuaJIT.
--To make a new sigfig number, do newsigfig(num,sigfigs)
--Supports unm, add, sub, mod, mul, div, pow, tostring, concat, and all single-argument math functions
--To call a math function on a sigfig, do sigfig.funcname
--Example: newsigfig(5,1).sin

--The getrg function could be replaced with something faster. But it's quite simple and I like that.

local newsigfig do
	local defaultsig=16
	local mingr=-1024

	local setmt=setmetatable
	local format=string.format
	local math=math

	local meta={}

	local function getgr(num)
		local abs=num<0 and -num or num
		local gr=0
		if abs==0 then
			return mingr
		elseif abs<1 then
			while abs<1 do
				abs,gr=10*abs,gr-1
			end
		elseif 1<abs then
			while 10<=abs do
				abs,gr=abs/10,gr+1
			end
		end
		return gr
	end

	function newsigfig(num,sig,gr)
		local self={}
		self.num=num
		self.sig=sig or defaultsig
		self.gr=gr or getgr(num)
		return setmt(self,meta)
	end

	function meta.__unm(a)
		return newsigfig(-a.num,a.sig,-a.gr)
	end

	function meta.__add(a,b)
		if type(a)=="number" then
			local num=a+b.num
			local gr=getgr(num)
			return newsigfig(num,b.sig+gr-b.gr,gr)
		elseif type(b)=="number" then
			local num=a.num+b
			local gr=getgr(num)
			return newsigfig(num,a.sig+gr-a.gr,gr)
		else
			local ale=a.gr-a.sig
			local ble=b.gr-b.sig
			local le=ale<ble and ble or ale
			local num=a.num+b.num
			local gr=getgr(num)
			return newsigfig(num,gr-le,gr)
		end
	end

	function meta.__sub(a,b)
		if type(a)=="number" then
			local num=a-b.num
			local gr=getgr(num)
			return newsigfig(num,b.sig+gr-b.gr,gr)
		elseif type(b)=="number" then
			local num=a.num-b
			local gr=getgr(num)
			return newsigfig(num,a.sig+gr-a.gr,gr)
		else
			local ale=a.gr-a.sig
			local ble=b.gr-b.sig
			local le=ale<ble and ble or ale
			local num=a.num-b.num
			local gr=getgr(num)
			return newsigfig(num,gr-le,gr)
		end
	end

	function meta.__mod(a,b)
		if type(a)=="number" then
			local num=a%b.num
			local gr=getgr(num)
			return newsigfig(num,b.sig+gr-b.gr,gr)
		elseif type(b)=="number" then
			local num=a.num%b
			local gr=getgr(num)
			return newsigfig(num,a.sig+gr-a.gr,gr)
		else
			local ale=a.gr-a.sig
			local ble=b.gr-b.sig
			local le=ale<ble and ble or ale
			local num=a.num%b.num
			local gr=getgr(num)
			return newsigfig(num,gr-le,gr)
		end
	end

	function meta.__mul(a,b)
		if type(a)=="number" then
			return newsigfig(a*b.num,b.sig)
		elseif type(b)=="number" then
			return newsigfig(a.num*b,a.sig)
		else
			return newsigfig(a.num*b.num,a.sig<b.sig and a.sig or b.sig)
		end
	end

	function meta.__div(a,b)
		if type(a)=="number" then
			return newsigfig(a/b.num,b.sig)
		elseif type(b)=="number" then
			return newsigfig(a.num/b,a.sig)
		else
			return newsigfig(a.num/b.num,a.sig<b.sig and a.sig or b.sig)
		end
	end

	function meta.__pow(a,b)
		if type(a)=="number" then
			return newsigfig(a^b.num,b.sig)
		elseif type(b)=="number" then
			return newsigfig(a.num^b,a.sig)
		else
			return newsigfig(a.num^b.num,a.sig<b.sig and a.sig or b.sig)
		end
	end

	function meta.__index(a,index)
		if math[index] then
			return newsigfig(math[index](a.num),a.sig)
		end
	end

	function meta.__tostring(a)
		--return a.num.."["..a.sig.."]"
		return format("%."..(a.sig-1).."e",a.num)
	end

	function meta.__concat(a,b)
		return tostring(a)..tostring(b)
	end
end

return newsigfig
