--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

-- Never want to write on of these again.
-- Someone please find a way to port native text entries to love2d.

local PANEL = {}

PANEL.Name = "ShardTextEntry";
PANEL.Base = "";

function PANEL:Init()
	self.Colors = {
		Color = shardui.getSkinAttribute("Color", "TextEntry"),
		BorderColor = shardui.getSkinAttribute("BorderColor", "TextEntry"),
		TextColor = shardui.getSkinAttribute("TextColor", "TextEntry")
	}
	self.Font = shardui.getSkinAttribute("Font", "TextEntry")
	self.Text = "";
	self.TextPos = 0;
	self.CarratPos = 0;
	self.CarratSplice = 0;
	self.Carrat = "|";
	self.LastCarrat = 0;
	self.Password = false;
	self.TextPos = 0;
	self.Padding = 2;
	self.OnCount = false;
	self.TextHeight = self.Font:getHeight("|");
	self.TextWide = self.Font:getWidth("m");
	self.NumberOnly = false;
	self.Lines = {}
end

function PANEL:SetNumerical(b)
	self.NumberOnly = b;
end

function PANEL:GetValue()
	return self.Text;
end

function PANEL:SetValue(t)
	self.Text = tostring(t);
end

function PANEL:PasswordField(b)
	self.Password = b;
end

function PANEL:OnMouseReleased()
	shardui.Focused = self;
	self.OnCount = true;
end

function PANEL:Clear()
	self.Text = "";
	self.CarratPos = 0;
	self.CarratSplice = 0;
end

function PANEL:OnEnter()
end

function PANEL:OnTextChanged()
end

function PANEL:Think()
	-- This melted my fucking brain bro.
	if( self.Font:getWidth(self.Text) > (self.Size.w-self.Padding*2) ) then
		self.TextPos = self.Font:getWidth(self.Text) - (self.Size.w-self.Padding*2) + self.Font:getWidth(self.Carrat);
	else
		self.TextPos = 0;
	end
	self.CarratPos = ((self.Pos.x+self.Padding-self.TextPos)+self.Font:getWidth(self.Text)) - (self.TextWide*self.CarratSplice)-self.TextWide/2;
	if( self.CarratPos < self.Pos.x + self.Padding ) then
		if(self.TextPos > 0) then
			local splice = self.CarratSplice * self.TextWide;
			splice = splice - self.Size.w-self.Padding*2;
			local size =  self.TextWide*#self.Text - self.Size.w-self.Padding*2
			self.TextPos = (size-splice);
		end
		self.CarratPos = (self.Pos.x + self.Padding) - self.TextWide/2;
	end
end

function PANEL:Paint()
	love.graphics.setColor(self.Colors.BorderColor);
	love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	love.graphics.setColor(self.Colors.Color);
	love.graphics.rectangle("fill", self.Pos.x + 1, self.Pos.y + 1, self.Size.w - 2, self.Size.h - 2);
	love.graphics.setColor(self.Colors.TextColor);
	love.graphics.setFont(self.Font)
	shardui.scissorStart(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
		if( shardui.Focused == self ) then
			if( self.LastCarrat <= love.timer.getTime()) then
				self.OnCount = not self.OnCount;
				self.LastCarrat = love.timer.getTime() + 0.7;
			end
			if( self.OnCount ) then
				love.graphics.print(self.Carrat, self.CarratPos, self.Pos.y+(self.Size.h/2 - self.TextHeight/2)-2);
			end
		end
		local str = self.Text;
		if( self.Password ) then
			str = "";
			for i = 1, string.len(self.Text) do
				str = str.."*";
			end
		end
		love.graphics.print(str, (self.Pos.x+self.Padding)-self.TextPos, self.Pos.y+(self.Size.h/2 - self.TextHeight/2)-2);
	shardui.scissorEnd();
end

return PANEL;


	