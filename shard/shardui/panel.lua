--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

--  File: panel.lua
--  Author: Averice
--  Purpose: This is the base panel object

-- Our panel object.
Panel = {}
Panel.__index = Panel;

-------------------
-- Creates a new instance of our panel.
-- newPanel();
-------------------
function newPanel()
	local pnl = {}
	setmetatable(pnl, Panel);
	pnl:__init();
	return pnl;
end


-------------------
-- Called automatically, initializes basic variables for the panel.
-- myPanel:__init();
-- CORE FUNCTION
-------------------
function Panel:__init()
	-- General settings 'NilFix'
	self.Size = { w = 0, h = 0 };
	self.Pos = { x = 0, y = 0 };
	self.RealPos = { x = 0, y = 0 };
	self.Visible = false;
	self.Children = {}
	self.Parent = false;
	self.Scissor = false;
	self.__shouldPaint = true;

	-- Colors.
	self.Colors = {
		Color = shardui.getSkinAttribute('Color'),
		BorderColor = shardui.getSkinAttribute('BorderColor'),
		TextColor = shardui.getSkinAttribute('TextColor')
	}
	self.ShareZ = false; -- Share Z plane with parent for sorting. -- Preferably internal use only. But if you're seeing this, yfio.
	-- Fonts
	self.Font = shardui.getSkinAttribute('Font');
end

-------------------
-- To be overwridden, initialises your custom variables for the panel
-- myPanel:Init()
-- THIS IS CALLED AUTOMATICALLY
-------------------
function Panel:Init() end


-------------------
-- Sets the size of the panel, can also take percentages if 'p' is 'true'
-- myPanel:SetSize(width, height, bool[use percentages]);
-------------------
function Panel:SetSize(w, h, p)
	local Width, Height = w, h;
	-- Is 'p' is true then we're dealing in percentages.
	if( p ) then
		Width = shardui.clamp(Width, 0, 100);
		Height = shardui.clamp(Height, 0, 100);
		if( self.Parent ) then
			-- We have a parent, let's measure it up.
			local pWidth, pHeight = self.Parent:GetSize()
			Width = (pWidth/100)*Width;
			Height = (pHeight/100)*Height;
		else
			-- No parent, get the windows size as it's parent.
			local pWidth, pHeight = love.window.getWidth(), love.window.getHeight();
			Width = (pWidth/100)*Width;
			Height = (pHeight/100)*Height;
		end
	end
	self.Size = { w = Width, h = Height };
end

function Panel:SetToolTip(t)
	self.ToolTip = t;
end

function Panel:GetToolTip()
	return self.ToolTip;
end


-------------------
-- Gets panel sizes
-- myPanel:GetSize();
-------------------
function Panel:GetSize()
	return self.Size.w, self.Size.h;
end


-------------------
-- Sets the parent of the panel ( Inherits positions )
-- myPanel:SetParent(parentPanel);
-------------------
function Panel:SetParent(pr)
	self.Parent = pr;
	table.insert(pr.Children, self)
	self:SetPos(self.RealPos.x, self.RealPos.y);
	for i = 1, #shardui.panels do
		if( shardui.panels[i] == self ) then
			table.remove(shardui.panels, i);
		end
	end
end


-------------------
-- Gets panel parent
-- myPanel:GetParent();
-------------------
function Panel:GetParent()
	return self.Parent;
end


-------------------
-- Sets the panels position relative to any parents
-- also updates children position, this function can take percentages
-- myPanel:SetPos(xPos, yPos, bool[percentage value?]);
-------------------
function Panel:SetPos(x, y, p)
	local xPos, yPos = x, y;
	-- If p is true we are once again dealing in percentages, think of it as a 'css margin:NUM%;'.
	if( p ) then
		xPos, yPos = shardui.clamp(xPos, 0, 100), shardui.clamp(yPos, 0, 100);
		if( self.Parent ) then
			-- Measure our parent.
			local pX, pY = self.Parent:GetSize();
			xPos = (pX/100)*xPos;
			yPos = (pY/100)*yPos;
		else
			-- Using the window as our parent. we have an orphan frame.
			local pX, pY = love.window.getWidth(), love.window.getHeight();
			xPos = (pX/100)*xPos;
			yPos = (pY/100)*yPos;
		end
	end
	-- Now the usual stuff since we have our percentages sorted.
	self.Pos.x, self.Pos.y = xPos, yPos;
	self.RealPos.x, self.RealPos.y = xPos, yPos;
	if( self.Parent ) then
		self.Pos.x = self.Parent.Pos.x + xPos;
		self.Pos.y = self.Parent.Pos.y + yPos;
	end
	for k, v in pairs(self.Children) do
		v:SetPos(v.RealPos.x, v.RealPos.y);
	end
end


-------------------
-- Gets panel position
-- myPanel:GetPos()
-------------------
function Panel:GetPos()
	return self.Pos.x, self.Pos.y;
end


-------------------
-- Sets the panels visibility, if false the panel and its children
-- will not be drawn
-- myPanel:SetVisible(bool[draw?])
-------------------
function Panel:SetVisible(b)
	self.Visible = b or false;
	self.Clicked = false;
	self.rClicked = false;
	for k, v in pairs(self.Children) do
		v:SetVisible(b);
	end
end


-------------------
-- Is the item inside a ScissorRect? If so it needs to draw itself.
-- myPanel:SetScissor(bool[yes?]);
-------------------
function Panel:SetScissor(b)
	self.Scissor = b;
end


-------------------
-- Is it inside a ScissorRect?
-- myPanel:GetScissor()
-------------------
function Panel:GetScissor()
	return self.Scissor
end


-------------------
-- Checks if the panel should be drawn
-- myPanel:IsVisible();
-------------------
function Panel:IsVisible()
	return self.Visible;
end


-------------------
-- Self explanatory
-------------------
function Panel:SetColor(col)
	self.Colors.Color = col or self.Colors.Color;
end


-------------------
-- Self explanatory
-------------------
function Panel:SetBorderColor(col)
	self.Colors.BorderColor = col or self.Colors.BorderColor;
end


-------------------
-- Self explanatory
-------------------
function Panel:SetTextColor(col)
	self.Colors.TextColor = col or self.Colors.TextColor;
end


-------------------
-- Self explanatory
-------------------
function Panel:SetFont(font)
	self.Font = font or self.Font;
end


-------------------
-- Self explanatory
-------------------
function Panel:GetColor()
	return self.Colors.Color;
end


-------------------
-- Self explanatory
-------------------
function Panel:GetBorderColor()
	return self.Colors.BorderColor;
end


-------------------
-- Self explanatory
-------------------
function Panel:GetTextColor()
	return self.Colors.TextColor;
end


-------------------
-- Self explanatory
-------------------
function Panel:GetFont()
	return self.Font;
end


-------------------
-- Checks if the item is visible while in a scrolling list
-- because we can't click things we can't see can we?
-- myPanel:Clickable();
-- DEPRECATED left in for backwards compatibility
-------------------
function Panel:Clickable()
	if( self.InScroll ) then
		local pW, pH = self:GetParent():GetSize();
		local pX, pY = self:GetParent():GetPos();
		return ( self.Pos.x > pX and self.Pos.x < pX+pW and self.Pos.y > pY and self.Pos.y+(self.Size.h/2) < pY+pH );
	end
	return true;
end


-------------------
-- These are just here to avoid them being nil
-- These have been explained inside the panel creation
-- although they are pretty self explanatory based on
-- what you would have read getting down to this part.
-------------------
function Panel:PostInit() end
function Panel:Paint() end
function Panel:Think() end
function Panel:OnMouseEnter() end
function Panel:OnMouseExit() end
function Panel:OnMousePressed() end
function Panel:OnMouseReleased() end
function Panel:OnMouseRightPressed() end
function Panel:OnMouseRightReleased() end


-------------------
-- CORE FUNCTION
-- Handles thinking and mouse events for parent and child.
-- CORE FUNCTION
-------------------
shardui.MouseClicked = false;
function Panel:__think(dt)
	if( shardui.hovering(self) ) then
		if( not self.Entered ) then
			self.Entered = true;
			self:OnMouseEnter();
			shardui.setToolTip(self)
		end
		if( love.mouse.isDown("l") ) then
			if( not self.Clicked and not shardui.MouseClicked and shardui.isNearestZ(self) == self) then
				shardui.MouseClicked = true;
				self.Clicked = true;
				if not( shardui.Focused == self ) then
					if( shardui.Focused and shardui.Focused.OnLoseFocus ) then
						shardui.Focused:OnLoseFocus();
					end 
					shardui.Focused = nil;
				end
				shardui.paintOver(shardui.getTopParent(self));
				shardui.panelDown = true;
				if( shardui.dropDown and shardui.dropDown.scPanel ~= self:GetParent() and shardui.dropDown.scPanel ~= self ) then
					shardui.dropDown.scPanel:SetVisible(false);
					shardui.dropDown = nil;
				end
				self:OnMousePressed();
			end
		end
		if( love.mouse.isDown("r") ) then
			if( not self.rClicked and not shardui.MouseClicked and shardui.isNearestZ(self) == self ) then
				shardui.MouseClicked = true;
				self.rClicked = true;
				if not( shardui.Focused == self ) then
					if( shardui.Focused and shardui.Focused.OnLoseFocus ) then
						shardui.Focused:OnLoseFocus();
					end
					shardui.Focused = nil;
				end
				shardui.paintOver(shardui.getTopParent(self));
				shardui.panelDown = true;
				if( shardui.dropDown and shardui.dropDown.scPanel ~= self:GetParent() and shardui.dropDown.scPanel ~= self ) then
					shardui.dropDown.scPanel:SetVisible(false);
					shardui.dropDown = nil;
				end
				self:OnMouseRightPressed();
			end
		end
	elseif( self.Entered ) then
		self.Entered = false;
		if( shardui.toolTip and shardui.toolTip.panel == self ) then
			shardui.toolTip = nil;
		end
		self:OnMouseExit();
	end
	if( self.Children[1] ) then
		for i = 1, #self.Children do
			if( self.Children[i]:IsVisible() ) then
				self.Children[i]:Think(dt);
				self.Children[i]:__think(dt);
			end
		end
	end
	if( self.Clicked and not love.mouse.isDown("l") ) then
		self:OnMouseReleased();
		shardui.MouseClicked = false;
		self.Clicked = false;
		shardui.panelDown = false;
	end
	if( self.rClicked and not love.mouse.isDown("r") ) then
		self:OnMouseRightReleased();
		shardui.MouseClicked = false;
		self.rClicked = false;
		shardui.panelDown = false;
	end
end


-------------------
-- CORE FUNCTION
-- Handles painting for parent and child.
-- CORE FUNCTION
-------------------
function Panel:__paint()
	if( self.Children[1] and self:IsVisible() ) then
		for i = 1, #self.Children do
			if( self.Children[i]:IsVisible() and not self.Children[i]:GetScissor() ) then
				self.Children[i]:Paint();
				self.Children[i]:__paint();
			end
		end
	end
end

