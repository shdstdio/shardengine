--[[
	Shard Engine
	Developed by Averice.

	Pretty much the world dawg.

	Stacks of worlds to be rendered.
]]--

local scrx, scry = love.graphics.getWidth, love.graphics.getHeight;
local floor = math.floor;

terrain = {}

terrain.Active = {};
terrain.Canvas = {};
terrain.ChunkSize = 16;

TERRAIN_COUNT = 0;
TERRAIN_GRID = true;

local function ent_sort(a, b)
	return a.Position.y + a.Size.h > b.Position.y + b.Size.h
end

function terrain.New(name)	-- CMapObject
	TERRAIN_COUNT = TERRAIN_COUNT + 1;

	local ter = new "CMapObject";
	ter.Name = name or TERRAIN_COUNT;
	ter.short = TERRAIN_COUNT;
	terrain.Canvas[TERRAIN_COUNT] = ter;

	return ter;
end

function terrain.Get(ter_id) -- CMapObject
	return terrain.Canvas[ter_id] or nil;
end

function terrain.AddChunk(terrain_id, x, y, over_write) -- nil
	if( terrain.Canvas[terrain_id] ) then
		terrain.Canvas[terrain_id]:NewChunk(x, y, over_write);
		return;
	end
	print("Error terrain.AddChunk there is no canvas at Terrain ID "..terrain_id);
end

function terrain.Create(x, y, name, block_size, height_seed, moisture_seed) -- CMapObject
	local map = terrain.New(name or nil)
	map.BlockSize = block_size or 32;
	map.HeightSeed = tonumber(height_seed) or nil;
	map.MoistureSeed = tonumber(moisture_seed) or nil;
	map:SetSize(x, y);
	map:CreateChunks();
	map.ActiveCamera = entity.Create("ECamera", map.short);
	map.ActiveCamera:SetTerrainCanvas(map.short);
	map.ActiveCamera:AddToChunk(true);
	return map;
end

function terrain.AddTexture(ter_id, texture)
	local map = terrain.Canvas[ter_id];
	if( map ) then
		map.Textures = map.Textures or {};
		if( map.Textures[texture] ) then
			return map.Textures[texture];
		end
		map.Textures[texture] = ResourceManager:NewSpriteSheet(texture);
		return map.Textures[texture];
	end
end

function terrain.Pop() -- CMapObject
	return table.remove(terrain.Active, #terrain.Active);
end

function terrain.Push(ter) -- nil
	table.insert(terrain.Active, ter);
end

function terrain.Pick(id) -- CMapObject
	return table.remove(terrain.Active, id);
end


function terrain.RealMousePos(ter_id) -- CVector.
	ter = terrain.Canvas[ter_id];
	local mpos = Vector(love.mouse.getPosition());
	if( ter and ter.ActiveCamera ) then
		local pos = ter.ActiveCamera.Position;
		return pos+mpos;
	end
end

local bPosX, bPosY = 0, 0;
local cPosX, cPosY = 0, 0;
function terrain.GetBlock(vec_pos, ter_id) -- table
	local ter = terrain.Canvas[ter_id];
	if( ter ) then
		bPosX, bPosY = math.floor(vec_pos.x/ter.BlockSize), math.floor(vec_pos.y/ter.BlockSize);
		cPosX, cPosY = math.floor(bPosX/ter.ChunkSize), math.floor(bPosY/ter.ChunkSize);
		--bPosX, bPosY = bPosX % ter.ChunkSize, bPosY % ter.ChunkSize;
		if( ter.Chunks[cPosX] and ter.Chunks[cPosX][cPosY] ) then
			if( ter.Chunks[cPosX][cPosY].Blocks[bPosX] and ter.Chunks[cPosX][cPosY].Blocks[bPosX][bPosY] ) then -- fuck dude...
				return ter.Chunks[cPosX][cPosY].Blocks[bPosX][bPosY];
			end
		end
	end
end

function terrain.GetBlocksInRect(vec_pos, sizew, sizeh, ter_id)
	local ter = terrain.Canvas[ter_id]; 
	local countW = math.floor(sizew / ter.BlockSize);
	local countH = math.floor(sizeh / ter.BlockSize);
	local vec = Vector(0, 0);
	if( ter ) then
		local Blocks = {}
		for x = 0, countW-1 do
			Blocks[x] = {}
			for y = 0, countH-1 do
				vec.x = vec_pos.x + ( ter.BlockSize * x );
				vec.y = vec_pos.y + ( ter.BlockSize * y );
				Blocks[x][y] = terrain.GetBlock(vec, ter_id);
			end
		end
		return Blocks;
	end
end

function terrain.GetBlocksInRadius(vec_pos, r, ter_id)
	local Blocks = terrain.GetBlocksInRect(vec_pos, r*2, r*2, ter_id);
	local mid = math.floor(r / ter.BlockSize) - 1;
	local dx, dy = 0, 0;
	local dist = 0;
	if( Blocks ) then
		local newBlocks = {}
		for x = 0, #Blocks-1 do
			newBlocks[x] = {}
			for y = 0, #Blocks[x]-1 do
				dx = x - mid;
				dy = y - mid;
				if( math.sqrt(dx*dx+dy*dy) < mid ) then
					print(math.sqrt(dx*dx+dy*dy), mid);
					newBlocks[x][y] = Blocks[x][y];
				end
			end
		end
		return newBlocks;
	end
end

local cx, cy, bnds, chnk
function terrain.Think(dt) -- nil
	for i = 1, #terrain.Active do
		bnds = terrain.Active[i].ActiveCamera:GetBounds();
		if bnds[1] then
			for x = bnds[1], bnds[2] do
				if terrain.Active[i].Chunks[x] then
					for y = bnds[3], bnds[4] do
						if( terrain.Active[i].Chunks[x][y] ) then
							chnk = terrain.Active[i].Chunks[x][y];
							chnk:Think(dt);
						--	table.sort(chnk.Entities, ent_sort);
							for e = 1, #chnk.Entities do
								if( chnk.Entities[e].Think ) then
									chnk.Entities[e]:Think(dt)
								end
							end
						end
					end
				end
			end
		end
		if( i == #terrain.Active ) then
			shard.__HOVERED_BLOCK = terrain.GetBlock(terrain.RealMousePos(terrain.Active[i].short), terrain.Active[i].short);
		end
	end
end

-- DRAW Extra layers, Draw entities, sort entity tables by ( posY + sizeH ) for draw orders( static tables should be sorted earlier and only once.)
-- Layers[ Base, Entitiy, Collision ]
function terrain.Draw() -- nil
	for i = 1, #terrain.Active do
		bnds = terrain.Active[i].ActiveCamera:GetBounds();
		for x = bnds[1], bnds[2] do
			if terrain.Active[i].Chunks[x] then
				for y = bnds[3], bnds[4] do
					if( terrain.Active[i].Chunks[x][y] ) then
						chnk = terrain.Active[i].Chunks[x][y];
						chnk:Draw(chnk:RealDrawPos(terrain.Active[i].ActiveCamera.Position));
					end
				end
			end
		end
	end
end

function terrain.GenerateNoiseMaps(height_seed, moisture_seed, sizeW, sizeH)
	local height_seed = height_seed or 0;
	local moisture_seed = moisture_seed or 3425;
	local sX,sY = sizeW or 0, sizeH or 0
	local height_map = love.image.newImageData(sX, sY);
	local moisture_map = love.image.newImageData(sX, sY);
	local nx, ny, mx, my, noise, moisture;
	for x = 1, sX do
		nx = ((x-sX/2)+height_seed)/sX;
		mx = ((x-sX/2)+moisture_seed)/sX;
		for y = 1, sY do
			ny = ((y-sY/2)+height_seed)/sY;
			my = ((y-sY/2)+moisture_seed)/sY; 
			noise = 1 * nse( 1 * nx, 1 * ny ) + 0.5 * nse( 2 * nx, 2 * ny ) + 0.25 * nse( 4 * nx, 4 * ny );
			noise = math.pow(noise, 4.06);
			moisture = 1 * nse( 1 * mx, 1 * my ) + 0.5 * nse( 2 * mx, 2 * my ) + 0.25 * nse( 4 * mx, 4 * my );
			height_map:setPixel(x-1, y-1, 255-255*noise, 255-255*noise, 255-255*noise, 255);
			moisture_map:setPixel(x-1, y-1, 255-255*moisture, 255-128*moisture, 255-255*moisture, 255);
		end
	end
	height_map:encode("hm.png");
	moisture_map:encode("mm.png");
	return height_map, moisture_map;
end

function terrain.Biome(e, m)
	if( e < 0.11 ) then
		if( m < 0.4 ) then
			return shard.__DEV_WATER_DARK
		elseif( m < 0.7 ) then
			return shard.__DEV_WATER_TEXTURE;
		else
			return shard.__DEV_WATER_LIGHT;
		end
	elseif( e < 0.13 ) then
		if( m < 0.3 ) then
			return shard.__DEV_SAND_LIGHT;
		else
			return shard.__DEV_SAND_TEXTURE;
		end
	elseif( e < 0.3 ) then
		if( m < 0.4 ) then
			return shard.__DEV_GRASS_DIRTY;
		elseif( m < 0.8 ) then
			return shard.__DEV_GRASS_TEXTURE;
		else
			return shard.__DEV_GRASS_LIGHT;
		end
	elseif( e < 0.5 ) then
		if( m < 0.4 ) then
			return shard.__DEV_ROCK_CRACK;
		else
			return shard.__DEV_ROCK_TEXTURE;
		end
	else
		if( m < 0.4 ) then
			return shard.__DEV_SNOW_DIRTY;
		elseif( m < 0.6 ) then
			return shard.__DEV_SNOW_DARK;
		else
			return shard.__DEV_SNOW_TEXTURE;
		end
	end
end


--[[
  if (e < 0.1) return OCEAN;
  if (e < 0.12) return BEACH;
  
  if (e > 0.8) {
    if (m < 0.1) return SCORCHED;
    if (m < 0.2) return BARE;
    if (m < 0.5) return TUNDRA;
    return SNOW;
  }

  if (e > 0.6) {
    if (m < 0.33) return TEMPERATE_DESERT;
    if (m < 0.66) return SHRUBLAND;
    return TAIGA;
  }

  if (e > 0.3) {
    if (m < 0.16) return TEMPERATE_DESERT;
    if (m < 0.50) return GRASSLAND;
    if (m < 0.83) return TEMPERATE_DECIDUOUS_FOREST;
    return TEMPERATE_RAIN_FOREST;
  }

  if (m < 0.16) return SUBTROPICAL_DESERT;
  if (m < 0.33) return GRASSLAND;
  if (m < 0.66) return TROPICAL_SEASONAL_FOREST;
  return TROPICAL_RAIN_FOREST;


--]]