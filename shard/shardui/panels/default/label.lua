--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

local PANEL = {}

PANEL.Name = "ShardLabel";
PANEL.Base = "";

function PANEL:Init()
	self.Text = {}
	self.Text.Text = "";
	self.Text.PosX = 0;
	self.Text.PosY = 0;
	self.Colors = {
		Color = shardui.getSkinAttribute("Color", "Label")
	}
	self.Font = shardui.getSkinAttribute("Font", "Label");
	self.MaxWidth = 0;
	self.Align = 2;
	self.Padding = 2;
end

function PANEL:SetMaxWidth(n)
	self.MaxWidth = n or 0;
end

function PANEL:Calculate()
	local w, lines = self.Font:getWrap(self.Text.Text, self.MaxWidth);
	self:SetSize(self.Size.w, self.Size.h * lines);
end

function PANEL:SetText(t)
	self.Text.Text = t or "";
	self:Calculate()
end

function PANEL:GetText()
	return self.Text.Text;
end

function PANEL:SetColor(col)
	self.Colors.Color = col;
end

function PANEL:SetFont(f)
	self.Font = f or self.Font;
end

function PANEL:Paint()
	love.graphics.setFont(self.Font)
	love.graphics.setColor(self.Colors.Color);
	love.graphics.printf(self.Text.Text, self.Pos.x, self.Pos.y, self.MaxWidth);
end

return PANEL;