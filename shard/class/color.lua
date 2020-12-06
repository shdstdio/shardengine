--[[
	Shard Engine
	Developed by Averice.
]]--

class "CColor";

function RGB(r, g, b, a)
	local col = new "CColor";
	col:Set(r, g, b, a);
	return col;
end

function CColor:Color()
	return { self.r, self.g, self.b, self.a };
end

function CColor:Set(r, g, b, a)
	self.r = clamp(r, 0, 255);
	self.g = clamp(g, 0, 255);
	self.b = clamp(b, 0, 255);
	self.a = clamp(a or 255, 0, 255);
end

function CColor:__add(b)
	return Color(self.r+b.r, self.g+b.g, self.b+b.b, self.a+b.a);
end

function CColor:__mul(b)
	return Color(self.r*b.r, self.g*b.g, self.b*b.b, self.a*b.a);
end

function CColor:__sub(b)
	return Color(self.r-b.r, self.g-b.g, self.b-b.b, self.a-b.a);
end

function CColor:__div(b)
	return Color(self.r/b.r, self.g/b.g, self.b/b.b, self.a/b.a);
end

function CColor:__eq(b)
	return self.r == b.r and self.g == b.g and self.b == b.b and self.a == b.a;
end

function CColor:Saturate(amnt)
	local sat = math.sqrt(self.r*self.r*0.289+self.g*self.g*0.587+self.b*self.b*0.114);
	return Color(clamp(sat+(self.r-sat)*amnt, 0, 255), clamp(sat+(self.g-sat)*amnt, 0, 255), clamp(sat+(self.b-sat)*amnt, 0, 255));
end

function CColor:Luminate(amnt)
	return Color(self.r + 255*(amnt/100), self.g + 255*(amnt/100), self.b + 255*(amnt/100), self.a);
end