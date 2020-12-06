--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

local PANEL = {}

PANEL.Name = "ShardTitleBar";
PANEL.Base = "";

function PANEL:Init()
	self.Colors = {
		Color = shardui.getSkinAttribute("Color", "Title"),
		GradientColor = shardui.getSkinAttribute("GradientImageColor", "Title"),
		LineColor = shardui.getSkinAttribute("LineColor", "Title")
	}
	self.Image = shardui.getSkinAttribute("GradientImage", "Title");
	self.UseGradient = shardui.getSkinAttribute("UseGradient", "Title");
	self.Draggable = true;
	self.Dragging = false;
end

function PANEL:OnMousePressed()
	if( self.Draggable ) then
		self.Dragging = true;
		local pX, pY = self:GetParent():GetPos();
		local mX, mY = love.mouse.getPosition();
		self.DirX = mX - pX; -- mXpX All stars haha
		self.DirY = mY - pY;
	end
end

function PANEL:OnMouseReleased()
	if( self.Draggable ) then
		self.Dragging = false;
	end
end

function PANEL:Think()
	if( self.Dragging ) then
		local moveX, moveY = love.mouse.getPosition();
		moveX = moveX - self.DirX;
		moveY = moveY - self.DirY;
		self:GetParent():SetPos(moveX, moveY);
	end
end

function PANEL:Paint()
	if( self.UseGradient ) then
		love.graphics.setColor( self.Colors.GradientColor );
		shardui.scissorStart(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
			love.graphics.draw(self.Image, self.Pos.x, self.Pos.y)
		shardui.scissorEnd()
	end
	love.graphics.setColor(self.Colors.LineColor);
	love.graphics.rectangle('fill', self.Pos.x, self.Pos.y + 19, self.Size.w, 1);
end

return PANEL;
