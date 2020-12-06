--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

local PANEL = {}

PANEL.Name = "ShardTextButton";
PANEL.Base = "";

function PANEL:Init()
	self.Text = {
		Text = "",
		TextW = 0,
		TextH = 0,
		PosX = 0,
		PosY = 0
	}
	self.Font = shardui.getSkinAttribute("Font", "TextButton");
	self.Colors = {
		TextColor = shardui.getSkinAttribute("TextColor", "TextButton"),
		TextColorHovered = shardui.getSkinAttribute("TextColorHovered", "TextButton")
	}
	self.Align = 1;
	self.Padding = 0;
end

function PANEL:SetPadding(p)
	self.Padding = p;
end

function PANEL:SetAlign(al)
	self.Align = al;
end

function PANEL:GetPadding()
	return self.Padding;
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

function PANEL:CalculatePosition()
	local w, h = self.Font:getWidth(self.Text.Text), self.Font:getHeight(self.Text.Text);
	local sW, sH = self:GetSize();
	if( self.Align == 1 ) then
		self.Text.PosX, self.Text.PosY = self.Pos.x + (sW/2 - w/2), self.Pos.y + (sH/2 - h/2);
	elseif( self.Align == 2 ) then
		self.Text.PosX, self.Text.PosY = self.Pos.x + self.Padding, self.Pos.y + (sH/2 - h/2);
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

function PANEL:OnMouseReleased()
end

function PANEL:Paint()
	self:CalculatePosition();
	love.graphics.setFont(self.Font)
	love.graphics.setColor(self.Hovered and self.Colors.TextColorHovered or self.Colors.TextColor);
	love.graphics.print(self.Text.Text, self.Text.PosX, self.Text.PosY);
end

return PANEL;