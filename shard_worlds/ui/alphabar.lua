--[[
	Shard Engine
	Developed by Averice.
]]--

local PANEL = {}
PANEL.Name = "AlphaBar";
PANEL.Base = "";


function PANEL:Init()
	self.Image = ResourceManager:NewImage("textures/ui/alpha_bar.png");
	self.DrawColor = Color(255,255,255,255);
	self.AlphaImage = shard.__DEV_ALPHA_TEXTURE;
	self.ImageData = self.Image:getData();
	self.Selected = 0;
	self.SelectedColor = 255;
	self.Scale = { x = 1, y = 1 };
	self.Size = { w = 130, h = 22 };
	self.BorderColor = shardui.getSkinAttribute("BorderColor", "Frame");

end

function PANEL:SetSize(x, y)
	self.Size = { w = x, h = y };
	self.Scale = { x = (x-2) / 128, y = (y-2) / 20 };
	self.AlphaScale = (y-2) / 32;
end

function PANEL:GetColor()
	return self.Selected.Color;
end

function PANEL:GetPixel(x, y)
	local x, y = x or love.mouse.getX(), y or love.mouse.getY();

	local ix, iy = self.Image:getDimensions();
	ix, iy = ix * self.Scale.x, iy * self.Scale.y;

	local px, py = (x - self.Pos.x), (y - self.Pos.y);
	px, py = px > ix-1 and ix-1 or px, py > iy-1 and iy-1 or py;
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
				self.SelectedColor = Color(self.ImageData:getPixel(px-1, py-1))[4];
				self.Selected = px;
				self:OnAlphaSelected(self.SelectedColor);
			end
		end
	end
end

function PANEL:OnMouseReleased()
	self.mLeftDown = false;
end

function PANEL:OnAlphaSelected(alpha)
end

function PANEL:Paint()

	love.graphics.setColor(self.BorderColor);
	love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	love.graphics.setColor(255,255,255,255);
	for i = 0, 3 do
		love.graphics.draw(self.AlphaImage.Dsheet, self.AlphaImage.Dquad, 1+self.Pos.x+(32*i), 1+self.Pos.y, 0, 1, self.AlphaScale);
	end
	love.graphics.setColor(self.DrawColor);
	love.graphics.draw(self.Image, self.Pos.x+1, self.Pos.y+1, 0, self.Scale.x, self.Scale.y);

	love.graphics.setColor(33, 33, 33, 255);
	love.graphics.rectangle("line", self.Pos.x + self.Selected, self.Pos.y, 3, self.Size.h);

	--end
end

shardui.registerPanel(PANEL, PANEL.Name, PANEL.Base);