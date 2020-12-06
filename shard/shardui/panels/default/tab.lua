--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

local PANEL = {}

PANEL.Name = "ShardTab";
PANEL.Base = "";

function PANEL:Init()
	self.Tabs = {}
	self.Buttons = {}
	self.Colors = {
		Color = shardui.getSkinAttribute("Color", "Tab"),
		BorderColor = shardui.getSkinAttribute("BorderColor", "Tab")
	}
end

function PANEL:AddTab(name, panel, img, sizeX)
	local newTab = {
		Name = name,
		Image = img or nil,
		Panel = panel,
		SizeX = sizeX or nil
	}
	table.insert(self.Tabs, newTab)
	if( #self.Tabs == 1 ) then
		self.ActiveTab = self.Tabs[1];
	end
end

function PANEL:SetVisible(b)
	Panel.SetVisible(self, b)
	if not self.PartsMade then
		self:MakeParts()
	end
end

function PANEL:Think()
	for k,v in pairs(self.Tabs) do
		if( v.Panel:IsVisible() ) then
			if( self.ActiveTab ~= self.Tabs[k] ) then
				v.Panel:SetVisible(false);
			end
		end
	end
end

function PANEL:MakeParts()
	local fnt = love.graphics.newFont(10)
	if not self.Tabs[1] then return end
	local sX = 0;
	local pX = 0;
	for k, v in pairs(self.Tabs) do
		sX = self.Size.w/#self.Tabs;
		if( v.SizeX and v.SizeX < sX ) then
			sX = v.SizeX;
		end
		self.Buttons[#self.Buttons+1] = shardui.createPanel("ShardTabButton", self);
		self.Buttons[#self.Buttons]:SetFont(fnt);
		self.Buttons[#self.Buttons]:SetSize(sX, 20);
		self.Buttons[#self.Buttons]:SetPadding(2);
		self.Buttons[#self.Buttons]:SetPos(pX, 0);
		self.Buttons[#self.Buttons]:SetText(v.Name);
		self.Buttons[#self.Buttons].Tab = k;
		if( self.Tabs[k].Image ) then
			self.Buttons[#self.Buttons]:SetImage(self.Tabs[k].Image)
		end
		self.Buttons[#self.Buttons]:SetAssociatedTab(self.Tabs[k]);
		self.Buttons[#self.Buttons]:SetAlign(2);
		pX = pX + sX;
	end
	if( self.Buttons[1] ) then
		self.Buttons[1]:OnMouseReleased();
	end
end

function PANEL:SetActiveTab(tn)
	if( self.Tabs[tn] ) then
		if( self.ActiveTab ) then
			self.ActiveTab.Panel:SetVisible(false);
		end
		self.ActiveTab = self.Tabs[tn]
		self.ActiveTab.Panel:SetVisible(true);
	end
end

return PANEL;