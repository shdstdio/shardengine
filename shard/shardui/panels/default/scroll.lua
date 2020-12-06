--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

local PANEL = {}

PANEL.Name = "ShardScrollPanel";
PANEL.Base = "";

function PANEL:Init()
	self.Colors = {
		Color = shardui.getSkinAttribute("Color", "ScrollFrame"),
		BorderColor = shardui.getSkinAttribute("BorderColor", "ScrollFrame"),
		ButtonColor = shardui.getSkinAttribute("ScrollButtonColor", "ScrollFrame"),
		ButtonBorderColor = shardui.getSkinAttribute("ScrollButtonBorderColor", "ScrollFrame"),
		ScrollBarColor = shardui.getSkinAttribute("ScrollBarColor", "ScrollFrame")
	};
	self.Items = {};
	self.Parts = {};
	self.Padding = 4;
	self.NextPos = 2;
	self.ScrollPos = 18;
	self.MaxScrollDist = 40;
	self.MinScrollDist = 10;
end

function PANEL:OnMouseEnter()
	self.Entered = true;
	shardui.scrollEntered = self;
end

function PANEL:OnMouseExit()
	self.Entered = false;
	shardui.scrollEntered = false;
end

function PANEL:GetItemCount()
	return #self.Items;
end

function PANEL:VerticalItemPosition()
	if( self.Items[1] ) then
		local it = self.Items[#self.Items];
		local maxY = it.VerticalPosOld or 0;
		local maxH = it.Size.h;
		return maxY + maxH + self.Padding;
	end
	return self.NextPos;
end

function PANEL:TrackDistance()
	return self.Parts.ScrollFrame.Size.h - 72;
end

function PANEL:DistancePerPixel()
	local view = self.Size.h - 2;
	local hidden = self.NextPos - view;
	local track = self:TrackDistance();
	return hidden / track;
end

function PANEL:ScrollMove()
	return shardui.clamp(self:TrackDistance() / #self.Items, self.MinScrollDist, self.MaxScrollDist);
end

function PANEL:ScrollPercentage()
	return self.Parts.Grip.RealPos.y - self.ScrollPos;
end

function PANEL:Scroll()
	local move = self:ScrollPercentage();
	for k,v in pairs(self.Items) do
		v:SetPos(v.RealPos.x, v.VerticalPosOld - ( self:DistancePerPixel()*move ));
	end
end

-- Alt 30 - ▲ ]
-- Alt 31 - ▼ }
--			  > Alt codes for scroll buttons, don't mind me.
-- Alt 16 - ► }
-- Alt 17 - ◄ ] -- Looking at these arrows now it appears i was thinking about horizonatal scrolling too.. hahahahahahahaha....
function PANEL:ScrollToBottom()
	if( self.Parts.Grip ) then
		self.Parts.Grip:SetPos(0, self.ScrollPos + self:TrackDistance());
		self:Scroll();
	end
end

function PANEL:AddItem(item)
	item:SetScissor(true);
	self.NextPos = self:VerticalItemPosition();
	item:SetPos(self.Padding + (item.RealPos.x or 0), self.NextPos);
	item.VerticalPosOld = self.NextPos;
	self.NextPos = self.NextPos + item.Size.h + self.Padding;
	--item:SetVisible(true);
	table.insert(self.Items, item);

	if( self.NextPos > self.Size.h-2 ) then
		if( self.ScrollEnabled and not self.Parts.ScrollFrame ) then
			self:MakeParts();
		end
	end
end

function PANEL:EnableVerticalScrollBar(b)
	self.ScrollEnabled = b;
end

function PANEL:MakeParts()
	self.Parts.ScrollFrame = shardui.createPanel("ShardPanel", self);
	self.Parts.ScrollFrame:SetSize(18, self.Size.h);
	self.Parts.ScrollFrame:SetPos(self.Size.w-18, 0);
	self.Parts.ScrollFrame:EnableBorder(false);
	self.Parts.ScrollFrame.Colors.Color = self.Colors.ScrollBarColor;
	self.Parts.ScrollFrame.OnMouseReleased = function( sf )
		local pX, pY = love.mouse.getPosition()
		pY = pY - self.Parts.ScrollFrame.Pos.y;
		if( self.Parts.Grip ) then
			self.Parts.Grip:SetPos(0, shardui.clamp(pY - 18, self.ScrollPos, self.ScrollPos+self:TrackDistance()));
			self:Scroll();
		end
	end

	self.Parts.UpButton = shardui.createPanel("ShardButton", self.Parts.ScrollFrame);
	self.Parts.UpButton:SetSize(18, 18);
	self.Parts.UpButton:SetPos(0, 0);
	self.Parts.UpButton:EnableBorder(false);
	self.Parts.UpButton:SetText("▲");
	self.Parts.UpButton.OnMouseReleased = function()
		self.Parts.Grip:SetPos(0, shardui.clamp(self.Parts.Grip.RealPos.y - self:ScrollMove(), self.ScrollPos, self.ScrollPos + self:TrackDistance()));
		self:Scroll();
	end

	self.Parts.DwButton = shardui.createPanel("ShardButton", self.Parts.ScrollFrame);
	self.Parts.DwButton:SetSize(18, 18);
	self.Parts.DwButton:SetPos(0, self.Size.h - 18);
	self.Parts.DwButton:EnableBorder(false);
	self.Parts.DwButton:SetText("▼");
	self.Parts.DwButton.OnMouseReleased = function()
		self.Parts.Grip:SetPos(0, shardui.clamp(self.Parts.Grip.RealPos.y + self:ScrollMove(), self.ScrollPos, self.ScrollPos + self:TrackDistance()));
		self:Scroll();
	end

	self.Parts.Grip = shardui.createPanel("ShardButton", self.Parts.ScrollFrame);
	self.Parts.Grip:SetSize(18, 36);
	self.Parts.Grip:SetPos(0, 18);
	self.Parts.Grip:EnableBorder(false);
	self.Parts.Grip:SetText("=");
	self.Parts.Grip.OnMousePressed = function(btn)
		btn.Dragging = true;
		local pY = btn.RealPos.y;
		local mX, mY = love.mouse.getPosition();
		btn.DirY = mY - pY;
	end
	self.Parts.Grip.OnMouseReleased = function(btn)
		btn.Dragging = false;
	end
	self.Parts.Grip.Think = function(btn)
		if( btn.Dragging ) then
			local moveX, moveY = love.mouse.getPosition();
			moveY = moveY - btn.DirY;
			btn:SetPos( 0, shardui.clamp(moveY, self.ScrollPos, self.ScrollPos+self:TrackDistance()));
			self:Scroll();
		end
	end
end

function PANEL:PaintItems(p)
	p:Paint();
	for k, v in pairs(p.Children) do
		if( v.Children ) then
			self:PaintItems(v);
		end
		v:Paint();
	end
end

function PANEL:Paint()
	love.graphics.setColor(self.Colors.BorderColor);
	love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	love.graphics.setColor(self.Colors.Color);
	love.graphics.rectangle("fill", self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);

	shardui.scissorStart(self.Pos.x+1, self.Pos.y+1, self.Size.w - 2, self.Size.h - 2);
		for k, v in pairs(self.Items) do
			self:PaintItems(v);
		end
	shardui.scissorEnd();

end

return PANEL;