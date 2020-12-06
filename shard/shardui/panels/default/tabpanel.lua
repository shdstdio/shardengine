--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

local PANEL = {}

PANEL.Name = "ShardTabPanel";
PANEL.Base = "ShardPanel";

function PANEL:Init()
	self.Colors = {
		Color = shardui.getSkinAttribute("Color", "Tab"),
		BorderColor = shardui.getSkinAttribute("BorderColor", "Tab")
	}
	self.Border = true;
end

return PANEL;