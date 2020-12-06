--[[
	Shard Engine
	Developed by Averice.
]]--

class "CChunk";

function CChunk:Init()
	self.Size = { w = 16, h = 16 };
	self.Blocks = {}
	self.Entities = {}
	self.Position = Vector(1, 1);
	self.DrawPos = Vector(0, 0);
	self.Layers = {}
end

function CChunk:RealChunkSize()
	return self.Size.w*self.BlockSize, self.Size.h*self.BlockSize;
end

function CChunk:RealDrawPos(vec_offset)
	local x, y = self:RealChunkSize();
	local vx, vy = 0, 0;
	if( vec_offset ) then
		vx, vy = vec_offset.x < 0 and math.abs(vec_offset.x) or 0-vec_offset.x, vec_offset.y < 0 and math.abs(vec_offset.y) or 0-vec_offset.y;
	end
	return (x*self.Position.x)+vx, (y*self.Position.y)+vy;
end

local rX, rY = 0, 0

function nse(x, y)
	return simplex.Simplex2D(x, y) / 2 + 0.5;
end

local x1, y1;
local tl, tr, bl, br
local tex
function CChunk:NewBlockList()
	local Ter = terrain.Get(self.terrain);
	local noise, nx, ny = 0, 0, 0;
	local moisture, mx, my = 0, 0, 0;

	for x = 0, self.Size.w-1 do
		x1 = self.Position.x*self.Size.w+x;
		self.Blocks[x1] = {}

		for y = 0, self.Size.h-1 do
			y1 = self.Position.y*self.Size.h+y;
			self.Blocks[x1][y1]  = {}
			self.Blocks[x1][y1].Position = { x = x, y = y };
			self.Blocks[x1][y1].Solid = false;
			self.Blocks[x1][y1].Layers = {}

			if( Ter.HeightSeed ) then
				Ter.MoistureSeed = Ter.MoistureSeed or math.random(3425);
				nx, ny = (x1+Ter.HeightSeed)/Ter.Size.w, (y1+Ter.HeightSeed)/Ter.Size.h;
				mx, my = (x1+Ter.MoistureSeed)/Ter.Size.w, (y1+Ter.MoistureSeed+523)/Ter.Size.h;

				noise = 1 * nse( 1 * nx, 1 * ny ) + 0.5 * nse( 2 * nx, 2 * ny ) + 0.25 * nse( 4 * nx, 4 * ny )
						+ 0.13 * nse( 8 * nx, 8 * ny )
						+ 0.06 * nse( 16 * nx, 16 * ny)
						+ 0.03 * nse( 32 * nx, 32 * ny );
				noise = noise / (1 + 0.5 + 0.25 + 0.13 + 0.06 + 0.03);
				noise = math.pow(noise, 3.00);

				moisture = 1 * nse( 1 * mx, 1 * my ) + 0.75 * nse( 2 * mx, 2 * my ) + 0.33 * nse( 4 * mx, 4 * my )
						+ 0.33 * nse( 8 * mx, 8 * my)
						+ 0.33 * nse( 16 * mx, 16* my)
						+ 0.50 * nse( 32 * mx, 32 * my);
				moisture = moisture / (1 + 0.75 + 0.33 + 0.33 + 0.33 + 0.5);
				
				self.Blocks[x1][y1].Layers[1] = { Texture = terrain.Biome(noise,moisture) };
			end
		end
	end
end

function CChunk:SetPos(vec)
	self.Position = vec;
end

function CChunk:GetPos()
	return self.Position;
end

function CChunk:ImportBlockData(data, js)
	self.Blocks = js and json.decode(data) or data;
end

function CChunk:ExportBlockData(js)
	return js and json.encode(self.Blocks) or self.Blocks;
end

function CChunk:SetSize(x, y)
	self.Size = { w = x, h = y };
end

function CChunk:Shutdown()
end

function CChunk:Think()
end

local col;
local w, h
local base, base2
local x1, y1;
function CChunk:Draw(dpx, dpy)
	w, h = love.graphics.getWidth(), love.graphics.getHeight();
	for x = 0, self.Size.w-1 do
		x1 = self.Position.x*self.Size.w+x;
		if( self.Blocks[x1] ) then
			for y = 0, self.Size.h-1 do
				y1 = self.Position.y*self.Size.h+y;
				if( self.Blocks[x1][y1] ) then
					col = self.Blocks[x1][y1].Color;
					if( self.Blocks[x1][y1].Layers ) then
						base = self.Blocks[x1][y1].Layers[1]; -- base layers.
						if( base and base.Texture ) then
							love.graphics.setColor(base.Color or {255,255,255,255});
							love.graphics.draw(base.Texture.Dsheet, base.Texture.Dquad, ((self.Blocks[x1][y1].Position.x)*self.BlockSize) + dpx, ((self.Blocks[x1][y1].Position.y)*self.BlockSize) + dpy);
						end
						base2 = self.Blocks[x1][y1].Layers[2];
						if( base2 and base2.Texture ) then
							love.graphics.setColor(base2.Color or {255,255,255,255});
							love.graphics.draw(base2.Texture.Dsheet, base2.Texture.Dquad, ((self.Blocks[x1][y1].Position.x)*self.BlockSize) + dpx, ((self.Blocks[x1][y1].Position.y)*self.BlockSize) + dpy);
						end
					end
					if( shard.__HOVERED_BLOCK == self.Blocks[x1][y1] ) then
						shard.__HOVERED_DETAILS = { (x)*self.BlockSize + dpx, (y)*self.BlockSize+dpy, self.BlockSize, self.BlockSize };
					end
				end
			end
		end
	end
	if( GAME.ShowDevGrid ) then
		for x = 0, self.Size.w-1 do
			love.graphics.setColor({20, 20, 20, 255});
			love.graphics.line(x*self.BlockSize+dpx, dpy, x*self.BlockSize+dpx, self.Size.h*self.BlockSize+dpy);
		end
		for y = 0, self.Size.h-1 do
			love.graphics.setColor({20, 20, 20, 255});
			love.graphics.line(dpx, y*self.BlockSize+dpy, self.Size.w*self.BlockSize+dpx, y*self.BlockSize+dpy);
		end
	end
end


--[[LAYERS 
	-- Blocks are positional items only???
	-- place texture by block position (sheet reference and quad)(top-left snap to grid ) - not for entities. sort these tables once - preferable on map save?
	-- if no quad use whole texture( this is for per block only textures that don't have a sprite atlas );
	-- order by quad size im guessing?
	-- add texture to top left block not all blocks.
	LAYERS]]--
