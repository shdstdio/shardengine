--[[
	Shard Engine
	Developed by Averice.
]]--

local floor, ceil = math.floor, math.ceil
class "CMapObject";

function CMapObject:Init()
	self.Size = { w = 32, h = 32 };
	self.BlockSize = 32;
	self.ChunkSize = 16;
	self.Chunks = {}
	self.Tilesheets = {}
	self.NoiseType = NOISE_NONE;
	self.Seed = 0;
end

function CMapObject:AddTilesheet(name, sheet)
	self.Tilesheets[name] = sheet;
end

function CMapObject:SetChunkSize(s)
	self.ChunkSize = s;
end

function CMapObject:GetChunkSize()
	return self.ChunkSize or 16;
end

function CMapObject:CreateChunks()
	local sX, sY = self.Size.w/self.ChunkSize, self.Size.h/self.ChunkSize;
	for x = floor(1 - sX/2), floor(sX/2) do
		self.Chunks[x] = {};
		for y = floor(1 - sY/2), floor(sY/2) do
			self.Chunks[x][y] = new "CChunk"; -- might be expensive?
			self.Chunks[x][y].terrain = self.short;
			self.Chunks[x][y]:SetSize(self.ChunkSize, self.ChunkSize);
			self.Chunks[x][y]:SetPos(Vector(x, y));
			self.Chunks[x][y]:NewBlockList();
			self.Chunks[x][y].BlockSize = self.BlockSize;
		end
	end
end

function CMapObject:RealMapSize()
	local x = (#self.Chunks*self.ChunkSize)*self.BlockSize;
	local y = (#self.Chunks*self.ChunkSize)*self.BlockSize;
	return x, y;
end

function CMapObject:NewChunk(x, y, over_write)
	if( self.Chunks[x] and self.Chunks[x][y] and not over_write ) then
		print("Error placing Chunk["..x.."]["..y.."] chunk already exists use over_write argument for CMapObject:NewChunk(x, y, bool over_write)");
		return;
	end
	self.Chunks[x] = self.Chunks[x] or {};
	self.Chunks[x][y] = new "CChunk";
	self.Chunks[x][y]:SetSize(self.ChunkSize, self.ChunkSize);
	self.Chunks[x][y]:NewBlockList();
	self.Chunks[x][y]:SetPos(Vector(x, y));
	self.Chunks[x][y].BlockSize = self.BlockSize;
	local rx, ry = self:RealMapSize();
	self:SetSize(rx/self.BlockSize, ry/self.BlockSize);
end

function CMapObject:SetSize(w, h)
	self.Size = { w = w, h = h };
end

function CMapObject:GetSize()
	return self.Size.w, self.Size.h;
end

function CMapObject:SetPos(vec)
	self.Position = vec;
end

function CMapObject:GetPos()
	return self.Position;
end

function CMapObject:SetBlockSize(s)
	self.BlockSize = s;
end

function CMapObject:SetActiveCamera(cam)
	if( isEntity(cam) ) then
		self.ActiveCamera = cam;
	end
end

function CMapObject:GetBlockSize()
	return self.BlockSize or 32;
end




