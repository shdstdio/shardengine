--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

local PANEL = {}

PANEL.Name = "ShardPanel";
PANEL.Base = "";

function PANEL:Init()
	self.Colors = {
		Color = shardui.getSkinAttribute("Color", "Frame"),
		BorderColor = shardui.getSkinAttribute("BorderColor", "Frame")
	}
	self.Border = true;
end

function PANEL:EnableBorder(b)
	self.Border = b;
end

function PANEL:Paint()
	if( self.Border ) then
		love.graphics.setColor(self.Colors.BorderColor);
		love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
		love.graphics.setColor(self.Colors.Color);
		love.graphics.rectangle("fill", self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
	else
		love.graphics.setColor(self.Colors.Color);
		love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	end
end

return PANEL;