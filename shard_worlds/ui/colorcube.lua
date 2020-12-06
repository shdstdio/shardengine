--[[
	Shard Engine
	Developed by Averice.
]]--

local PANEL = {}
PANEL.Name = "ColorCube";
PANEL.Base = "";


function PANEL:Init()
	self.Image = ResourceManager:NewImage("textures/ui/colorcube.png");
	self.ImageData = self.Image:getData();
	self.Selected = { x = 0, y = 0 };
	self.Selected.Color = Color(self.ImageData:getPixel(0, 0));
	self.Scale = { x = 1, y = 1 };
	self.Size = { w = 130, h = 130 };
	self.BorderColor = shardui.getSkinAttribute("BorderColor", "Frame");

end

function PANEL:SetSize(x, y)
	self.Size = { w = x, h = y };
	self.Scale = { x = x / 128, y = y / 128 };
end

function PANEL:GetColor()
	return self.Selected.Color;
end

function PANEL:GetPixel(x,y)
	local x, y = x or love.mouse.getX(), y or love.mouse.getY();

	local ix, iy = self.Image:getDimensions();
	ix, iy = ix * self.Scale.x, iy * self.Scale.y;

	local px, py = (x - self.Pos.x), (y - self.Pos.y);
	px, py = px > ix and ix or px, py > iy and iy or py;
	px, py = px < 1 and 1 or px, py < 1 and 1 or py; 

	return px, py;
end

function PANEL:OnMousePressed()
	self.mLeftDown = true;
end

local px, py
function PANEL:Think()
	if( self.Entered ) then
		if( self.mLeftDown ) then
			px, py = self:GetPixel();
			if( px and py ) then
				self.Selected.Color = Color(self.ImageData:getPixel(px-1, py-1));
				self.Selected.x, self.Selected.y = px, py;
				self:OnColorSelected(self.Selected.Color);
			end
		end
	end
end

function PANEL:OnMouseReleased()
	self.mLeftDown = false;
end

function PANEL:OnColorSelected(color)
end

function PANEL:Paint()

	love.graphics.setColor(self.BorderColor);
	love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	love.graphics.setColor(255,255,255,255);
	love.graphics.draw(self.Image, self.Pos.x+1, self.Pos.y+1, 0, self.Scale.x, self.Scale.y);

	love.graphics.setColor(33, 33, 33, 255);
	love.graphics.circle("line", self.Pos.x + self.Selected.x, self.Pos.y + self.Selected.y, 3);

	--end
end

shardui.registerPanel(PANEL, PANEL.Name, PANEL.Base);