local PANEL = {}

PANEL.Name = "ShardDropList";
PANEL.Base = "";

function PANEL:Init()
	self.Colors = {
		MainColor = shardui.getSkinAttribute("MainColor", "DropList"),
		BorderColor = shardui.getSkinAttribute("BorderColor", "DropList"),
		TextColor = shardui.getSkinAttribute("TextColor", "DropList")
	}
	self.Font = shardui.getSkinAttribute("Font", "DropList");
	self.Selection = {
		Text = "",
		Value = 1
	}
	self.Name = "Select..";
	self.PartsMade = false;
	self.Items = {}
	self.DropSize = 80;
end

function PANEL:SetDropSize(n)
	self.DropSize = n;
end

function PANEL:AddItem(name, val)
	table.insert(self.Items, { Text = name, Value = val });
end

function PANEL:GetValue()
	return self.Selection.Value;
end

function PANEL:SetValue(val)
	self.Selection.Value = val;
end

function PANEL:SetName(n)
	self.Name = n;
end

function PANEL:OnSelect(val)
end

function PANEL:OnMouseReleased()
	if( self.PartsMade ) then
		self.Button:OnMouseReleased();
	end
end

function PANEL:MakeParts()
	if( self.PartsMade ) then
		return
	end
	self.Button = shardui.createPanel("ShardButton", self);
	self.Button:SetPos(self.Size.w-19, 0);
	self.Button:SetSize(19, 16);
	self.Button:SetText("▼");
	self.Button.OnMouseReleased = function()
		self.scPanel:SetVisible(not self.scPanel:IsVisible());
		if( self.scPanel:IsVisible() ) then
			shardui.dropDown = self;
			shardui.paintOver(self.scPanel)
		else
			shardui.dropDown = nil;
		end
	end
	
	self.scPanel = shardui.createPanel("ShardScrollPanel");
	self.scPanel:SetPos(self.Pos.x, self.Pos.y + 16);
	self.scPanel.Colors.BorderColor = self.Colors.BorderColor;
	self.scPanel.Colors.MainColor = self.Colors.MainColor;
	self.scPanel:SetSize(self.Size.w, self.DropSize); --shardui.clamp(#self.Items*14, 128, 256));
	self.scPanel:EnableVerticalScrollBar(true);
	self.scPanel:SetVisible(false);
	
	
	local itemLabel
	if( self.Items[1] ) then
		for i = 1, #self.Items do
			itemLabel = shardui.createPanel("ShardTextButton", self.scPanel);
			itemLabel.Colors.MainColor = self.Colors.TextColor;
			itemLabel:SetSize(self.Size.w-20, 14);
			itemLabel:SetAlign(2);
			itemLabel:SetText(self.Items[i].Text);
			itemLabel:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
			itemLabel.OnMouseReleased = function()
				self.Name = self.Items[i].Text;
				self:SetValue(self.Items[i].Value);
				self.scPanel:SetVisible(false);
				self:OnSelect(self.Items[i].Value)
			end
			self.scPanel:AddItem(itemLabel);
		end
	end
	
	self.PartsMade = true;
	
end

function PANEL:Think()
	if( self:IsVisible() and not self.PartsMade ) then
		self:MakeParts();
		--self:SetSize(self.Size.w, 272)
	end
	if( self.scPanel:IsVisible() ) then
		self:SetSize(self.Size.w, 16+self.DropSize);
	else
		self:SetSize(self.Size.w, 16);
	end
end

function PANEL:Paint()
	love.graphics.setColor(self.Colors.BorderColor);
	love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, 16);
	love.graphics.setColor(self.Colors.MainColor);
	love.graphics.rectangle("fill", self.Pos.x+1, self.Pos.y+1, self.Size.w-2, 14);
	
	love.graphics.setFont(self.Font);
	love.graphics.setColor(self.Colors.TextColor);
	love.graphics.print(self.Name, self.Pos.x+2, self.Pos.y+1);
	
end

return PANEL;