--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

local PANEL = {}

PANEL.Name = "ShardTabButton";
PANEL.Base = "ShardButton";

function PANEL:SetAssociatedTab(tab)
	self.AssosciatedTab = tab;
end

function PANEL:OnMouseReleased()
	if( self:GetParent() ) then
		for k,v in pairs(self:GetParent().Buttons) do
			v.Colors.Color = shardui.getSkinAttribute("BorderColor", "TextButton");
			v.Colors.BorderColor = shardui.getSkinAttribute("Color", "TextButton");
		end
		self.Colors.BorderColor = shardui.getSkinAttribute("BorderColor", "TextButton");
		self.Colors.Color = shardui.getSkinAttribute("Color", "TextButton");
		self:GetParent():SetActiveTab(self.Tab);
	end
end

function PANEL:Paint()
	if( self.Border ) then
		love.graphics.setColor(self.Colors.BorderColor);
		love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
		love.graphics.setColor( self.Colors.Color );
		love.graphics.rectangle("fill", self.Pos.x + 1, self.Pos.y + 1, self.Size.w - 2, self.Size.h - 1);
	else
		love.graphics.setColor( self.Colors.Color );
		love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	end
	self:CalculatePosition();
	if(self.Image) then
		love.graphics.setColor(Color(255,255,255,255));
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