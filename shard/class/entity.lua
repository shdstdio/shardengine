--[[
	Shard Engine
	Developed by Averice.
]]--

class "CEntity";

CEntity.AlwaysThink = false;
CEntity.NoDraw = false;
CEntity.Size = { w = 32, h = 32 };
CEntity.NoThink = false;
CEntity.IsEntity = true;
CEntity.Asleep = false;
CEntity.Position = Vector(0, 0);
CEntity.Chunk = {x = 0, y = 0};

function CEntity:Init()
end

function CEntity:RemoveFromChunk()
	for i = 1, #terrain.Canvas[self.terrain].Chunks[self.Chunk.x][self.Chunk.y].Entities do
		if( terrain.Canvas[self.terrain].Chunks[self.Chunk.x][self.Chunk.y].Entities[i] == self ) then
			table.remove(terrain.Canvas[self.terrain].Chunks[self.Chunk.x][self.Chunk.y].Entities, i);
		end
	end
end

function CEntity:AddToChunk(force)
	local px, py = self.Position.x, self.Position.y;
	local ter = terrain.Get(self.terrain);
	local cx, cy = (px/ter.BlockSize)/ter.ChunkSize, (py/ter.BlockSize)/ter.ChunkSize;
	local cx, cy = math.floor(cx), math.floor(cy);

	if( terrain.Canvas[self.terrain].Chunks[cx] and terrain.Canvas[self.terrain].Chunks[cx][cy] ) then
		cx, cy = cx, cy;
	elseif( terrain.Canvas[self.terrain].Chunks[self.Chunk.x] and terrain.Canvas[self.terrain].Chunks[self.Chunk.x][cy] ) then
		cx, cy = self.Chunk.x, cy;
	elseif( terrain.Canvas[self.terrain].Chunks[cx] and terrain.Canvas[self.terrain].Chunks[cx][self.Chunk.y] ) then
		cx, cy = cx, self.Chunk.y;
	else
		cx, cy = self.Chunk.x, self.Chunk.y;
	end

	if( cx == self.Chunk.x and cy == self.Chunk.y and not force ) then
		return;
	elseif( terrain.Canvas[self.terrain].Chunks[cx] and terrain.Canvas[self.terrain].Chunks[cx][cy] ) then
		self:RemoveFromChunk();
		self.Chunk = { x = cx, y = cy };
		table.insert(terrain.Canvas[self.terrain].Chunks[cx][cy].Entities, self);
	end
end

function CEntity:GetPos()
	return self.Position;
end

function CEntity:SetSize(w, h)
	self.Size = { w = w, h = h };
end

function CEntity:GetSize()
	return self.Size.x, self.Size.y;
end


function CEntity:SetPos(vec)
	if( ctype(vec) == "CVector" ) then
		self.Position = vec;
		self:AddToChunk();
	else
		print("CVector.SetPos expected CVector got "..ctype(vec));
	end
end

--[[
local dir, v1, v2
function CEntity:UpdateViewPosition(c)
	if( self.FollowCam ) then
		c = self.FollowCam;
	end
	v1 = c.Position;
	v2 = self.Position;
	--dir =Vector(math.abs(self.Position.x - c.Position.x), math.abs(self.Position.y - c.Position.y))
	dir =Vector(self.Position.x - c.Position.x, self.Position.y - c.Position.y);
	dir.x = dir.x + love.graphics.getWidth()/2;
	dir.y = dir.y + love.graphics.getHeight()/2;
	self.ViewPosition = dir;
end]]

function CEntity:Sleep(b)
	if( type(b) == "bool" ) then
		self.Asleep = b;
		return;
	end
	return self.Asleep;
end

function CEntity:CanDraw(b)
	if( type(b) == "bool" ) then
		self.NoDraw = b;
		return;
	end
	return self.NoDraw;
end

function CEntity:CanThink(b)
	if( type(b) == "bool" ) then
		self.NoThink = b;
		return;
	end
	return self.NoThink;
end

function CEntity:ForceThink(b)
	if( type(b) == "bool" ) then
		self.ALwaysThink = b;
		return;
	end
	return self.AlwaysThink;
end

function CEntity:Draw()
end

function CEntity:Think()
end