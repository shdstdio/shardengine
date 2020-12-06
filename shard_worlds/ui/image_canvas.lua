--[[
	Shard Engine
	Developed by Averice.
]]--

local PANEL = {}
PANEL.Name = "ImageCanvas";
PANEL.Base = "";


function PANEL:Init()
	self.Grid = true;
	self.GridSize = 4;
	self.AlphaImage = shard.__DEV_ALPHA_TEXTURE;
	self.Pixels = {}
	self.MovePos = { x = 0, y = 0 };
	self.CanvasSize = { w = 0, h = 0 };
	self.PaintColor = Color(255,255,255,255);
	self.BorderColor = shardui.getSkinAttribute("BorderColor", "Frame");
end

function PANEL:SetPaintColor(col)
	self.PaintColor = col;
end

function PANEL:SetGridSize(n)
	self.GridSize = next_power_of_two(n);
end

function PANEL:SetSize(x, y)
	self.Size = { w = x, h = y };
end

function PANEL:SetCanvasSize(x, y)
	self.CanvasSize = {w = x, h = y};
	for i = 0, x-1 do
		self.Pixels[i] = {}
		for j = 0, y-1 do
			self.Pixels[i][j] = Color(180, 180, 180, 255);
		end
	end
end

function PANEL:Clear()
	for i = 0, #self.Pixels do
		for j = 0, #self.Pixels[i] do
			self.Pixels[i][j] = Color(180, 180, 180, 255);
		end
	end
end

function PANEL:EnableGrid(b)
	self.Grid = b;
end

function PANEL:GetPixel(x,y)
	local x, y = x or love.mouse.getX(), y or love.mouse.getY();
	local px, py = x - (self.MovePos.x + self.Pos.x), y - (self.MovePos.y + self.Pos.y);
	px = math.floor(px / self.GridSize);
	py = math.floor(py / self.GridSize);
	return px, py;
end

function PANEL:OnMousePressed()
	self.mLeftDown = true;
end

local px, py
function PANEL:Think()
	if( self.Entered ) then
		px, py = self:GetPixel()
		if( self.Pixels[px] and self.Pixels[px][py] ) then
			self.SelectedPixel = { x = px, y = py };
			if( self.mLeftDown ) then
				self.Pixels[px][py] = self.PaintColor;
			end
		end
		if( self.mRightDown ) then
			local mX, mY = love.mouse.getPosition();
			mX = mX - self.DirX;
			mY = mY - self.DirY;
			self.MovePos.x, self.MovePos.y = mX, mY;
		end
	end
end

function PANEL:OnMouseRightPressed()
	self.mRightDown = true;
	local pX, pY = self.MovePos.x, self.MovePos.y;
	local mX, mY = love.mouse.getPosition();
	self.DirX = mX - pX;
	self.DirY = mY - pY;
end

function PANEL:OnMouseRightReleased()
	self.mRightDown = false;
end

function PANEL:OnMouseReleased()
	self.mLeftDown = false;
end

function PANEL:LoadImage(str)
	local Image = love.graphics.newImage(str):getData();
	if( Image ) then
		local sx, sy = Image:getDimensions();
		for i = 0, sx-1 do
			self.Pixels[i] = {}
			for j = 0, sy-1 do
				self.Pixels[i][j] = Color(Image:getPixel(i, j));
			end
		end
	end
end

function PANEL:SaveImage(str)
	if( self.Pixels[0] ) then
		local Image = love.graphics.newImageData(#self.Pixels+1, #self.Pixels[0]+1);
		for x = 0, #self.Pixels do
			for y = 0, #self.Pixels[x] do
				Image:setPixel(x, y, unpack(self.Pixels[x][y]));
			end
		end
		return Image:encode("textures/saved/"..str);
	end
end

function PANEL:Paint()
	love.graphics.setColor(self.BorderColor);
	love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	shardui.scissorStart(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
		for x = 0, #self.Pixels do
			if( self.Pixels[x] ) then
				for y = 0 , #self.Pixels[x] do
					if( self.Pixels[x][y] ) then
						love.graphics.setColor(self.Pixels[x][y]);
						love.graphics.rectangle("fill", self.MovePos.x+self.Pos.x+x*self.GridSize, self.MovePos.y+self.Pos.y+y*self.GridSize, self.GridSize, self.GridSize);
					end
				end
			end
		end
		if( self.SelectedPixel ) then
			love.graphics.setColor(self.PaintColor);
			love.graphics.rectangle("fill", self.MovePos.x+self.Pos.x+self.SelectedPixel.x*self.GridSize, self.MovePos.y+self.Pos.y+self.SelectedPixel.y*self.GridSize, self.GridSize, self.GridSize);
		end
		if( self.Grid and self.Pixels[0] ) then
			love.graphics.setColor(22,22,22,100);
			for i = 0, #self.Pixels do
				love.graphics.line(self.MovePos.x+self.Pos.x+self.GridSize*i, self.MovePos.y+self.Pos.y, self.MovePos.x+self.Pos.x+self.GridSize*i, self.MovePos.y+self.Pos.y+(#self.Pixels[0]+1)*self.GridSize);
			end
			for i = 0, #self.Pixels[0] do
				love.graphics.line(self.MovePos.x+self.Pos.x, self.MovePos.y+self.Pos.y+self.GridSize*i, self.MovePos.x+self.Pos.x+(#self.Pixels+1)*self.GridSize, self.MovePos.y+self.Pos.y+self.GridSize*i);
			end
		end
	shardui.scissorEnd();
	--end
end

command.Create("test_canvas", function()
		tBox = shardui.createPanel("ShardFrame");
		tBox:SetSize(700, 500);
		tBox:SetPos(200, 200);
		tBox:SetTitle("Niggers");

		cBox = shardui.createPanel("ColorCube", tBox)
		cBox:SetPos(2, 22);
		function cBox:OnColorSelected(col)
			ttBox:SetPaintColor(col);
			aBox.DrawColor = col;

		end


		ttBox = shardui.createPanel("ImageCanvas", tBox);
		ttBox:SetPos(202, 22);
		ttBox:SetSize(496, 476);
		ttBox:LoadImage("textures/chinos.png");

		aBox = shardui.createPanel("AlphaBar", tBox);
		aBox:SetPos(2, 160);
		aBox:SetSize(130, 22);
		function aBox:OnAlphaSelected(alpha)
			local col = Color(unpack(ttBox.PaintColor));
			col[4] = alpha
			ttBox.PaintColor = col;
		end

		tBox:SetVisible(true);
	end, "tryty");

shardui.registerPanel(PANEL, PANEL.Name, PANEL.Base);