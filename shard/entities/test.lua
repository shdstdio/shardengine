--[[
	Shard Engine
	Developed by Averice.
]]--

class "ETest" : extends "CEntity";

ETest.ENT_INFO = {

	Image = love.graphics.newImage("textures/globe.png"),
	Description = "A simple test entity.",

	UI_OPTIONS = {
		"Name:TextEntry:0:true",
		"Dicks:CheckBox:false:false",
		"Vags:Slider:1;100:false"
	}

}

function ETest:Init()
	self.Nigs = true;
	self.Position = { x = 0, y = 0 };
	self.ViewPosition = Vector(0, 0);
	self.Size = { w = 32, h = 32 };
end


function ETest:KeyPressed(k, u)
	self:UpdateViewPosition(terrain.List[self.terrain].Camera);
	if( k == "w" ) then
		self:SetPos(self:GetPos() - Vector(0, 5));
	end
	if( k == "a" ) then
		self:SetPos(self:GetPos() - Vector(5, 0));
	end
	if( k == "s" ) then
		self:SetPos(self:GetPos() + Vector(0, 5));
	end
	if( k == "d" ) then
		self:SetPos(self:GetPos() + Vector(5, 0));
	end
end

function ETest:Draw()
	love.graphics.setColor(255, 255, 0, 255);
	love.graphics.rectangle("fill", self.ViewPosition.x - 16, self.ViewPosition.y - 16, 32, 32);
end

return "ETest";