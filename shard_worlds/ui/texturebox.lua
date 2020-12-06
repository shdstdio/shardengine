--[[
	Shard Engine
	Developed by Averice.
]]--

local PANEL = {}
PANEL.Name = "TextureBox";
PANEL.Base = "";
PANEL.Texture = "no_texture_selected";


function PANEL:Init()
	self.ImageSize = {}
	self.ImageSize.x, self.ImageSize.y = 0, 0;
	self.Grid = true;
	self.Selection ={};
	self.Colors = { 
		Color = Color(255,255,255,255),
		BorderColor = shardui.getSkinAttribute("BorderColor", "Frame"),
		BoxBorderColor = Color(176,25,25,255),
		BoxColor = Color(120,25,25,170),
		QuadBorderColor = Color(25,25,176,255),
		QuadBoxColor = Color(25, 25, 120, 170)
	}
	self.GridSize = 32;
	self.MovePos = { x= 0, y = 0 };
	self.SelectionOnce = false;
end

function PANEL:SetGridSize(n)
	self.GridSize = next_power_of_two(n);
end

function PANEL:SelectOneBlockOnly(b)
	self.SelectOnce = b;
end

function PANEL:SetTexture(tex)
	self.Texture = tex;
	if not( ResourceManager:GetResource("SpriteSheets", tex) ) then
		self.DrawTexture = ResourceManager:NewSpriteSheet(tex);
	else
		self.DrawTexture = ResourceManager:GetResource("SpriteSheets", tex);
	end
	self.ImageSize.x, self.ImageSize.y = self.DrawTexture:getDimensions();
end

function PANEL:ClearSelection()
	self.Selection = {}
end

function PANEL:Center()
	if( self.DrawTexture ) then
		local centerx, centery = self.ImageSize.x/2, self.ImageSize.y/2;
		centerx, centery = self.Size.w/2 - centerx, self.Size.h/2 - centery;
		self.MovePos.x, self.MovePos.y = centerx, centery;
	end
end

function PANEL:EnableGrid(b)
	self.Grid = b;
end

function PANEL:OnMousePressed()
	if not self.ClickedInt then
		self.Selection = {}
		self.ClickedInt = true;
		self.Selection.StartPos = { x = love.mouse.getX() - (self.MovePos.x + self.Pos.x), y = love.mouse.getY() - (self.MovePos. y + self.Pos.y) };
		return;
	end
end

function PANEL:OnMouseRightPressed()
	self:ClearSelection();
	self.mRightDown = true;
	local pX, pY = self.MovePos.x, self.MovePos.y;
	local mX, mY = love.mouse.getPosition();
	self.DirX = mX - pX;
	self.DirY = mY - pY;
end

function PANEL:OnMouseRightReleased()
	self.mRightDown = false;
end

function PANEL:Think()
	if( self.ClickedInt ) then
		self.Selection.EndPos = { x = love.mouse.getX() - (self.MovePos.x + self.Pos.x), y = love.mouse.getY() - (self.MovePos.y + self.Pos.y) };
		if( self.SelectOnce ) then
			self.Selection.StartPos = self.Selection.EndPos;
		end
		if( self.Selection.StartPos and self.Selection.EndPos ) then
			local x, y, xx, yy = getbestposition(self.Selection.StartPos.x, self.Selection.StartPos.y, self.Selection.EndPos.x, self.Selection.EndPos.y);
			self.Selection.Quad = {
				x = math.floor(x/self.GridSize) * self.GridSize,
				y = math.floor(y/self.GridSize) * self.GridSize,
				x2 = math.ceil(xx/self.GridSize) * self.GridSize,
				y2 = math.ceil(yy/self.GridSize) * self.GridSize
			}
		end
	end
	if( self.Entered and self.mRightDown ) then
		local mX, mY = love.mouse.getPosition();
		mX = mX - self.DirX;
		mY = mY - self.DirY;
		self.MovePos.x, self.MovePos.y = mX, mY;
	end
end

function PANEL:OnSelectionFinished()
end

function PANEL:OnMouseReleased()
	self.ClickedInt = false;
	self:OnSelectionFinished()
end

-- this is dirty and old, taken from an older project.
function PANEL:GetNearestBox(x, y)
	local sX, sY = math.ceil(self.ImageSize.x/self.GridSize), math.ceil(self.ImageSize.y/self.GridSize);
	local CurX, CurY = 0, 0;
	for i = 0, sX-1 do
		if( x >= self.GridSize*i and x <= (self.GridSize*i)+self.GridSize ) then
			CurX = i;
			break;
		end
	end
	for i = 0, sY-1 do
		if( y >= self.GridSize*i and y <= (self.GridSize*i)+self.GridSize ) then
			CurY = i;
			break;
		end
	end
	return CurX, CurY;
end

local nbX, nbY -- nearest Box.
local sizeX, sizeY -- size of the image divided by the gridsize.
local sX, sY, sX2, sY2 -- size of selecting rectangle
function PANEL:Paint()
	love.graphics.setColor(self.Colors.BorderColor);
	love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);

	shardui.scissorStart(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
		if( self.DrawTexture ) then
			love.graphics.setColor(self.Colors.Color);
			love.graphics.draw(self.DrawTexture, self.MovePos.x + self.Pos.x, self.MovePos.y + self.Pos.y);

			if( self.Grid ) then
				love.graphics.setColor(22,22,22,100);
				sizeX = self.ImageSize.x/self.GridSize;
				sizeY = self.ImageSize.y/self.GridSize;
				for i = 1, sizeX do
					love.graphics.line(self.MovePos.x + self.Pos.x+self.GridSize*i, self.MovePos.y + self.Pos.y+0, self.MovePos.x + self.Pos.x+self.GridSize*i, self.MovePos.y + self.Pos.y+self.ImageSize.y);
				end
				for i = 1, sizeY do
					love.graphics.line(self.MovePos.x + self.Pos.x+0, self.MovePos.y + self.Pos.y+self.GridSize*i, self.MovePos.x + self.Pos.x+self.ImageSize.x, self.MovePos.y + self.Pos.y+self.GridSize*i);
				end
			end
			if( self.Selection.Quad ) then
				love.graphics.setColor(self.Colors.QuadBorderColor);
				love.graphics.rectangle("line", self.MovePos.x + self.Pos.x + self.Selection.Quad.x, self.MovePos.y + self.Pos.y + self.Selection.Quad.y, self.Selection.Quad.x2 - self.Selection.Quad.x, self.Selection.Quad.y2 - self.Selection.Quad.y);
				love.graphics.setColor(self.Colors.QuadBoxColor);
				love.graphics.rectangle("fill", self.MovePos.x + self.Pos.x+1+self.Selection.Quad.x, self.MovePos.y + self.Pos.y+1+self.Selection.Quad.y, self.Selection.Quad.x2 - self.Selection.Quad.x - 1, self.Selection.Quad.y2 - self.Selection.Quad.y - 1);
			end
			if( self.Entered ) then
				nbX, nbY = self:GetNearestBox(love.mouse.getX() - (self.MovePos.x + self.Pos.x), love.mouse.getY() - (self.MovePos.y + self.Pos.y));
				love.graphics.setColor(self.Colors.BoxColor);
				love.graphics.rectangle("fill", self.MovePos.x + self.Pos.x+nbX*self.GridSize, self.MovePos.y + self.Pos.y+nbY*self.GridSize, self.GridSize, self.GridSize);
			end
		end
	shardui.scissorEnd();
	--end
end

shardui.registerPanel(PANEL, PANEL.Name, PANEL.Base);

command.Create("test_box", function()
		local tBox = shardui.createPanel("ShardFrame");
		tBox:SetSize(900, 300);
		tBox:SetPos(200, 200);
		tBox:SetTitle("Niggers");

		local sBox = shardui.createPanel("ShardPanel", tBox);
		sBox:SetPos(2, 22);
		sBox:SetSize(896, 276);

		local ttBox = shardui.createPanel("TextureBox", sBox);
		ttBox:SetSize(896, 276)
		tBox:SetVisible(true);
		ttBox:SetTexture("textures/hyptosis_tile-art-batch-1.png")
	end, "tryty");