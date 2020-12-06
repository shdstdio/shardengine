--[[
	Shard Engine
	Developed by Averice.
]]--

class "CVector";

function Vector(x, y)
	local vec = new "CVector";
	vec:Set(x, y);
	return vec;
end

function CVector:Init()
	self.x = 0;
	self.y = 0;
end

function CVector.__add(a, b)
	return Vector(a.x+b.x, a.y+b.y);
end

function CVector._mul(a, b)
	return Vector(a.x*b.x, a.y*b.y);
end

function CVector.__sub(a, b)
	return Vector(a.x-b.x, a.y-b.y);
end

function CVector.__div(a, b)
	return Vector(a.x/b.x, a.y/b.y);
end

function CVector.__eq(a, b)
	return (a.x == b.x and a.y == b.y);
end

function CVector:Set(x, y)
	self.x, self.y = x, y;
end

function CVector:Length()
	return math.sqrt(self.x*self.x + self.y*self.y);
end

function CVector:Distance(b)
	local x = b.x - self.x;
	local y = b.y - self.y;
	return math.sqrt(x*x+y*y);
end

function CVector:Normalize()
	local len = self:Length();
	if( len ~= 0 ) then
		return Vector(self.x / len, self.y / len);
	end
end

function CVector:Dot(b)
	return self.x*b.x+self.y*b.y;
end

function CVector:HasNegative()
	return self.x < 0 or self.y < 0;
end

function CVector:ZeroNegatives(x, y)
	self.x = self.x < (x or 0) and (x or 0) or self.x;
	self.y = self.y < (y or 0) and (y or 0) or self.y;
end

function CVector:Zero()
	self.x, self.y = 0, 0;
end

function CVector:__tostring()
	return "x: "..self.x.." y: "..self.y;
end

