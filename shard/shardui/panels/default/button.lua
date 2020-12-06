--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

local PANEL = {}

PANEL.Name = "ShardButton";
PANEL.Base = "";

function PANEL:Init()
	self.Text = {
		Text = "",
		TextW = 0,
		TextH = 0,
		PosX = 0,
		PosY = 0
	}
	self.Font = shardui.getSkinAttribute("IfButtonFont", "TextButton");
	self.Colors = {
		TextColor = shardui.getSkinAttribute("TextColor", "TextButton"),
		TextColorHovered = shardui.getSkinAttribute("TextColorHovered", "TextButton"),
		Color = shardui.getSkinAttribute("Color", "TextButton"),
		BorderColor = shardui.getSkinAttribute("BorderColor", "TextButton")
	}
	self.Align = 1;
	self.Padding = 0;
	self.Border = true;
end

function PANEL:SetPadding(p)
	self.Padding = p;
end

function PANEL:EnableBorder(b)
	self.Border = b;
end

function PANEL:SetAlign(al)
	self.Align = al;
end

function PANEL:GetPadding()
	return self.Padding;
end

function PANEL:SetImage(img, scale)
	self.Image = {
		Img = img,
		Scale = scale or 1
	}
	self.Image.PosX = self.Padding or 2;
	if( type(self.Image.Img) == "string" ) then
		self.Image.PosY = (self.Size.h/2) - (self.Font:getHeight(self.Image.Img)/2);
	else
		self.Image.PosY = (self.Size.h/2) - (self.Image.Img:getHeight()/2);
	end
end

function PANEL:SetText(t)
	self.Text.Text = t;
end

function PANEL:SetFont(font)
	self.Font = font;
end

function PANEL:GetFont()
	return self.Font;
end

function PANEL:SetImageButton(b)
	self.ImageButton = b;
end

function PANEL:CalculatePosition()
	local w, h = self.Font:getWidth(self.Text.Text), self.Font:getHeight(self.Text.Text);
	local sW, sH = self:GetSize();
	if( self.Align == 1 ) then
		self.Text.PosX, self.Text.PosY = self.Pos.x + (sW/2 - w/2), self.Pos.y + (sH/2 - h/2);
	elseif( self.Align == 2 ) then
		self.Text.PosX, self.Text.PosY = self.Pos.x + self.Padding, self.Pos.y + (sH/2 - h/2);
		if( self.Image ) then
			if( type(self.Image.Img) == "string" ) then
				self.Text.PosX = self.Text.PosX + self.Font:getWidth(self.Image.Img) + 2;
			else
				self.Text.PosX = self.Text.PosX + self.Image.Img:getWidth() + 2;
			end
		end
	elseif( self.Align == 3 ) then
		self.Text.PosX, self.Text.PosY = self.Pos.X + ((sW - self.Padding) - w), self.Pos.y + (sH/2 - h/2);
	end
end

function PANEL:GetText()
	return self.Text;
end

function PANEL:OnMouseEnter()
	self.Hovered = true;
end

function PANEL:OnMouseExit()
	self.Hovered = false;
end

function PANEL:SetImageColor(col)
	self.ImageColor = col or Color(255,255,255,255);
end

function PANEL:OnMouseReleased()
end

function PANEL:Paint()
	if not( self.ImageButton ) then
		if( self.Border ) then
			love.graphics.setColor(self.Colors.BorderColor);
			love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
			love.graphics.setColor( self.Colors.Color );
			love.graphics.rectangle("fill", self.Pos.x + 1, self.Pos.y + 1, self.Size.w - 2, self.Size.h - 2);
		else
			love.graphics.setColor( self.Colors.Color );
			love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
		end
	end
	self:CalculatePosition();
	if(self.Image) then
		love.graphics.setColor(self.ImageColor or Color(255,255,255,255));
		if( type(self.Image.Img) == "string" ) then
			love.graphics.print(self.Image.Img, self.Pos.x + self.Image.PosX, self.Pos.y + self.Image.PosY)
		else
			love.graphics.draw(self.Image.Img, self.Pos.x + self.Image.PosX, self.Pos.y + self.Image.PosY, 0, self.Image.Scale, self.Image.Scale);
		end
	end
	love.graphics.setFont(self.Font)
	love.graphics.setColor(self.Hovered and self.Colors.TextColorHovered or self.Colors.TextColor);
	love.graphics.print(self.Text.Text, self.Text.PosX, self.Text.PosY);
end

return PANEL;