local PANEL = {}

PANEL.Name = "ShardCheckBox";
PANEL.Base = "";
 
function PANEL:Init()
	self.Checked = false;
	self.Colors = {
		MainColor = shardui.getSkinAttribute("MainColor", "CheckBox"),
		BorderColor = shardui.getSkinAttribute("BorderColor", "CheckBox"),
		TextColor = shardui.getSkinAttribute("TextColor", "CheckBox")
	}
	self.Font = shardui.getSkinAttribute("Font", "CheckBox");
	self.tPx = self.Font:getWidth("x");
	self.tPy = self.Font:getHeight();
	self.Size.w = 12;
	self.Size.h = 12;
end

function PANEL:Check(b)
	self.Checked = not self.Checked;
end

function PANEL:SetCheck(b)
	self.Checked = b or false;
end

function PANEL:GetChecked()
	return self.Checked;
end

function PANEL:OnCheck()
end

function PANEL:OnUnCheck()
end

function PANEL:OnMouseReleased()
	if( self.Checked ) then
		self.Checked = false;
		self:OnUnCheck();
	else
		self.Checked = true;
		self:OnCheck();
	end
end

function PANEL:Paint()
	love.graphics.setColor(self.Colors.BorderColor);
	love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	love.graphics.setColor(self.Colors.MainColor);
	love.graphics.rectangle("fill", self.Pos.x+1, self.Pos.y+1, self.Size.w-1, self.Size.h-1);
	if( self.Checked ) then
		love.graphics.setColor(self.Colors.TextColor);
		love.graphics.setFont(self.Font);
		love.graphics.print("x", (self.Pos.x+self.Size.w/2) - (self.tPx/2), (self.Pos.y+self.Size.h/2) - (self.tPy/2));
	end
end

return PANEL;