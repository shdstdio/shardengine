--[[
	Shard Engine
	Developed by Averice.
]]--

local camx, camy
local floor, ceil = math.floor, math.ceil
local scrx, scry = love.graphics.getWidth, love.graphics.getHeight

class "ECamera" : extends "CEntity";

ECamera.NoDraw = true;
ECamera.Position = Vector(0,0);
ECamera.Bounds = Vector(0, 0);

function ECamera:Init()
end

function ECamera:SetTerrainCanvas(canvas_id)
	if( ctype(terrain.Canvas[canvas_id]) == "CMapObject" ) then
		self.TerrainCanvas = canvas_id;
		return;
	end
	print("Error: ECamera.SetTerrainCanvas(int canvas_id) expected id of CMapObject got "..ctype(terrain.Canvas[canvas_id]));
end

function ECamera:GetTerrainCanvas()
	return self.TerrainCanvas and terrain.Canvas[self.TerrainCanvas] or nil;
end

local map, bsiz, csize, mposx, mposy, cposx, cposy, x1, x2, y1, y2;
function ECamera:GetBounds()
	map = terrain.Canvas[self.TerrainCanvas];
	bsize, csize = map.BlockSize, map.ChunkSize;
	mposx, mposy = self.Position.x, self.Position.y;

	x1 = ceil((mposx/bsize)/csize)-1; -- Backwards 1 chunksize to ensure we load chunks to our left.
	x2 = mposx+scrx() > map.Size.w*bsize and ceil(map.Size.w/csize) or ceil(((mposx+scrx())/bsize)/csize); -- load to our right if position + screen width enters a chunk.
	y1 = ceil((mposy/bsize)/csize)-1; -- Up 1.
	y2 = mposy+scry() > map.Size.h*bsize and ceil(map.Size.h/csize) or ceil(((mposy+scry())/bsize)/csize); -- load to the bottom;

	self.ChunkBounds = {x1, x2, y1, y2};
	return self.ChunkBounds;
end

-- Set new boundaries incase there's permanent hud elements.
function ECamera:Bound(vec, vec2)
	self.Bounds = { vec, vec2 };
end

function ECamera:Move(vec)
	local px, py = self.Position.x, self.Position.y;
	local cvas = self:GetTerrainCanvas();
	px = px + vec.x;
	py = py + vec.y;
--	px = px >= ((cvas.Size.w/2)*cvas.BlockSize)-scrx() and (((cvas.Size.w/2)*cvas.BlockSize)-scrx()) or px;
--	px = px <= (cvas.ChunkSize-(cvas.Size.w/2))*cvas.BlockSize and ((cvas.ChunkSize-(cvas.Size.w/2))*cvas.BlockSize) or px;
--	py = py >= ((cvas.Size.h/2)*cvas.BlockSize)-scry() and (((cvas.Size.h/2)*cvas.BlockSize)-scry()) or py;
--	py = py <= (cvas.ChunkSize-(cvas.Size.h/2))*cvas.BlockSize and ((cvas.ChunkSize-(cvas.Size.h/2))*cvas.BlockSize) or py;
	self:SetPos(Vector(px, py));
end

function ECamera:MoveTo(vec)
	self:SetPos(vec);
	self:Move(Vector(0, 0)) -- Do the boundary checks.
end

-- this is temporary
function ECamera:Think(dt)
	if( love.keyboard.isDown("w") ) then
		self:Move(Vector(0, -500*dt));
	end
	if( love.keyboard.isDown("s") ) then
		self:Move(Vector(0, 500*dt));
	end
	if( love.keyboard.isDown("a") ) then
		self:Move(Vector(-500*dt, 0));
	end
	if( love.keyboard.isDown("d") ) then
		self:Move(Vector(500*dt, 0));
	end
end


function ECamera:Sleep()
	self.Asleep = true;
end

function ECamera:Wake()
	self.Asleep = false;
end

return "ECamera";


		
