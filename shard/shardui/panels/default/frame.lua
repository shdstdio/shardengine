--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

local PANEL = {}

PANEL.Name = "ShardFrame";
PANEL.Base = "";

function PANEL:Init()
	self.Colors = {
		Color = shardui.getSkinAttribute('Color', 'Frame'),
		BorderColor = shardui.getSkinAttribute('BorderColor', 'Frame')
	}
	self.Parts = {}
	self.TitleText = "";
	self.CanClose = true;
	self.CanPin = true;
	self.Border = true;
	self.RemoveOnClose = false;
	self.SysButtons = {}
end

function PANEL:RemoveOnClosed(b)
	self.RemoveOnClose = b;
end

function PANEL:EnableBorder(b)
	self.Border = b;
end

function PANEL:Pinnable(b)
	self.CanPin = b;
	self:MakeParts();
end

function PANEL:Closeable(b)
	self.CanClose = b;
	self:MakeParts();
end

function PANEL:SetTitle(t)
	self.TitleText = t;
	if( self.Parts.Title ) then
		self.Parts.Title:SetText(t);
	end
end

function PANEL:SetVisible(b)
	Panel.SetVisible(self, b)
	if not self.PartsMade then
		self:MakeParts()
	end
end

function PANEL:AddSystemButton(t, tip, func, ...)
	self.SysButtons[t] = {
		Tip = tip or "",
		Func = func,
		Args = {...}
	}
end

function PANEL:OnClose()
end

function PANEL:MakeParts()
	self.PartsMade = true;
	local SysPos = 16;
	if( self.Parts.Bar ) then
		shardui.removeChild(self, self.Parts.Bar);
		self.Parts.Bar = nil;
		self.Parts.CloseButton = nil;
		self.Parts.PinButton = nil;
		self.Parts.Title = nil;
	end
	self.Parts.Bar = shardui.createPanel("ShardTitleBar", self)
	self.Parts.Bar:SetSize(self.Size.w, 20);
	self.Parts.Bar:SetPos(0, 0);

	if( self.CanClose ) then
		self.Parts.CloseButton = shardui.createPanel("ShardTextButton", self.Parts.Bar);
		self.Parts.CloseButton:SetSize(16, 20);
		self.Parts.CloseButton:SetPos(self.Size.w - SysPos, 0);
		self.Parts.CloseButton:SetText("x");
		self.Parts.CloseButton.OnMouseReleased = function()
			if( self.RemoveOnClose ) then
				self:OnClose()
				shardui.removePanel(self);
			else
				self:OnClose();
				self:SetVisible(false);
			end
		end
		SysPos = SysPos + 14;
	end
	if( self.CanPin ) then
		self.Parts.PinButton = shardui.createPanel("ShardTextButton", self.Parts.Bar);
		self.Parts.PinButton:SetSize(16, 20);
		self.Parts.PinButton:SetPos(self.Size.w - SysPos, 0);
		self.Parts.PinButton:SetText("o");
		self.Parts.PinButton:SetToolTip("Pin");
		self.Parts.PinButton.OnMouseReleased = function()
			self.Parts.Bar.Draggable = not self.Parts.Bar.Draggable;
			self.Parts.PinButton:SetToolTip(self.Parts.Bar.Draggable and "Pin" or "Un-Pin");
			self.Parts.PinButton:SetText(self.Parts.Bar.Draggable and "o" or "{}");
		end
		SysPos = SysPos + 14;
	end
	for k,v in pairs(self.SysButtons) do
		local newButtons = shardui.createPanel("ShardTextButton", self.Parts.Bar);
		newButtons:SetSize(16, 20);
		newButtons:SetPos(self.Size.w - SysPos, 0);
		newButtons:SetText(k);
		newButtons:SetToolTip(v.Tip);
		newButtons.OnMouseReleased = function()
			v.Func(unpack(v.Args));
		end
		SysPos = SysPos + 14;
	end

	self.Parts.Title = shardui.createPanel("ShardTextButton", self.Parts.Bar);
	self.Parts.Title:SetSize(self.Size.w - 38, 20);
	self.Parts.Title:SetPos(4, 0);
	self.Parts.Title:SetAlign(2);
	self.Parts.Title.ShareZ = true;
	self.Parts.Title:SetText(self.TitleText);
	self.Parts.Title.OnMouseEnter = function() end;
end

function PANEL:EnableDragging(b)
	if( self.Parts and self.Parts.Bar ) then
		self.Parts.Bar.Draggable = b;
	end
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