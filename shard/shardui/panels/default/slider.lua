local PANEL = {}

PANEL.Name = "ShardSlider";
PANEL.Base = "";

function PANEL:Init()
	self.Min = 0;
	self.Max = 100;
	self.Cur = 0;
	
	self.Colors = {
		MainColor = shardui.getSkinAttribute("MainColor", "Slider"),
		BorderColor = shardui.getSkinAttribute("BorderColor", "Slider"),
		TextColor = shardui.getSkinAttribute("TextColor", "Slider")
	}	
	self.Font = shardui.getSkinAttribute("Font", "Slider");
	self.Padding = 2;
	self.MinSize = love.graphics.getFont():getWidth(self.Min);
end

function PANEL:SetMax(m)
	self.Max = tonumber(m);
end

function PANEL:SetMin(m)
	self.Min = tonumber(m)
	self.Cur = self.Min;
	self.MinSize = love.graphics.getFont():getWidth(self.Min);
end

function PANEL:SetBounds(m, ma)
	self:SetMin(m);
	self:SetMax(ma);
end

function PANEL:TrackDistance()
	return (self.Size.w - 29);
end

function PANEL:GetValue()
	return self.Cur;
end

function PANEL:SlidePercentage()
	local Moved = self.Slider.RealPos.x - self.Padding;
	return Moved / self:TrackDistance();
end

function PANEL:Slide()
	self.Cur = shardui.clamp(math.ceil(self.Max*self:SlidePercentage()), self.Min, self.Max);
end

function PANEL:OnSlideFinished(n)
end


function PANEL:MakeParts()
	if( self.PartsMade ) then
		return
	end
--	self.Frame = shardui.createPanel("ShardPanel", self)
--	self.Frame:SetSize(self.Size.w-11, 5);
--	self.Frame.Colors.BorderColor = self.Colors.BorderColor;
--	self.Frame:SetPos(0, 8);

	self.Label = shardui.createPanel("ShardLabel", self);
	self.Label:SetText(self.Cur);
	self.Label:SetFont(shardui.getSkinAttribute("Font", "TextEntry"));
	self.Label:SetPos(self.Size.w-8, 4);

	self.Slider = shardui.createPanel("ShardButton", self)
	self.Slider:SetSize(15, 20);
	self.Slider:SetPos(self.Padding, 0)
	self.Slider:SetText("=");
	self.Slider.Colors.MainColor = self.Colors.MainColor;
	self.Slider.Colors.BorderColor = self.Colors.BorderColor;
	function self.Slider.OnMousePressed(btn)
		btn.Dragging = true;
		local pX = btn.RealPos.x;
		local mX, mY = love.mouse.getX(), love.mouse.getY();
		btn.DirX = mX - pX; -- Allstars
	end
	function self.Slider.OnMouseReleased(btn)
		btn.Dragging = false;
		self:OnSlideFinished(self.Cur);
	end
	function self.Slider.Think(btn)	
		if( btn.Dragging ) then
			local moveX, moveY = love.mouse.getX(), love.mouse.getY();
			moveX = moveX - btn.DirX;
			btn:SetPos( shardui.clamp(moveX, self.Padding, self.Padding+self:TrackDistance()), 0);
			self:Slide();
			self.Label:SetText(self.Cur);
		end
	end
	self.PartsMade = true;
end

function PANEL:Think()
	if( not self.PartsMade ) then
		self:MakeParts();
		self.Size.h = 20;
	end
end

function PANEL:GetPointPos(num)
	return num/self.Max <= 1 and num/self.Max or self.Max;
end

function PANEL:SetPoint(pt)
	self.Cur = shardui.clamp(self.Max*pt, self.Min, self.Max);
	self.Slider:SetPos(self.Padding+(self:TrackDistance()*pt), 0);
	self.Label:SetText(self.Cur);
end

function PANEL:Paint()
	love.graphics.setColor(self.Colors.BorderColor);
	love.graphics.rectangle("line", self.Pos.x, self.Pos.y + 8, self.Size.w-11, 5);
	love.graphics.setColor(self.Colors.MainColor);
	love.graphics.rectangle("fill", self.Pos.x+1, self.Pos.y+9, self.Size.w-13, 3);
end
	

return PANEL;