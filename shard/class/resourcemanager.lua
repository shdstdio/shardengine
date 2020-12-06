--[[
	Shard Engine
	Developed by Averice.
]]--

class "CResourceManager";

function CResourceManager:Init()
	self.Resources = {}
end

function CResourceManager:NewAudio(file, vol, pitch, ...)
end

function CResourceManager:NewSpriteSheet(file)
	self.Resources.SpriteSheets = self.Resources.SpriteSheets or {};
	self.Resources.SpriteSheets[file] = love.graphics.newImage(file);
	return self.Resources.SpriteSheets[file];
end


function CResourceManager:NewSprite(sheet, quad, force)
	if not( self.Resources.SpriteSheets[sheet] ) then
		self:NewSpriteSheet(sheet);
	end
	self.Resources.Sprites = self.Resources.Sprites or {}
	-- please no duplicates?
	if not force then
		for i = 1, #self.Resources.Sprites do
			if( self.Resources.Sprites[i].Ssheet == sheet and table_values_match(self.Resources.Sprites[i].Squad, quad) ) then
				return self.Resources.Sprites[i], i;
			end
		end
	end
	local sprite = {
		Dsheet = self.Resources.SpriteSheets[sheet],
		Dquad = love.graphics.newQuad(unpack(quad)),
		Ssheet = sheet,
		Squad = quad
	}
	table.insert(self.Resources.Sprites, sprite);
	return self.Resources.Sprites[#self.Resources.Sprites], #self.Resources.Sprites;
end

function CResourceManager:NewFont(name, file, size)
	self.Resources["Fonts"] = self.Resources["Fonts"] or {}
	if( self.Resources.Fonts[name] ) then
		return self.Resources.Fonts[name];
	end
	if( file ~= nil ) then
		self.Resources.Fonts[name] = love.graphics.newFont(file, size);
	else
		file = "default";
		self.Resources.Fonts[name] = love.graphics.newFont(size);
	end
	return self.Resources.Fonts[name];
end

function CResourceManager:Replace(t, file, ...)
	local v = {...};
	if( t == "Images" ) then
		self.Resources.Images[file]  = love.graphics.newImage(v[1] or file);
		return;
	end
	if( t == "Sprites" ) then
		self.Resources.Sprites[file] = self:NewSprite(file, v[1], v[2], true);
	end
	if( t == "SpriteSheets" ) then
		self.Resources.SpriteSheets[file] = love.graphics.newImage(v[1] or file);
	end
	if( t == "Fonts" ) then
		self.Resources.Fonts[file] = love.graphics.newFont(v[1] or file, v[2] or nil);
	end
end


function CResourceManager:NewImage(file)
	self.Resources.Images = self.Resources.Images or {}
	if( type(file) == "userdata" ) then
		return love.graphics.newImage(file);
	end
	if( self.Resources.Images[file] ) then
		return self.Resources.Images[file];
	end
	self.Resources.Images[file] = love.graphics.newImage(file);
	return self.Resources.Images[file];
end

function CResourceManager:NewAnim(name, file)
end

function CResourceManager:GetResource(typ, name)
	self.Resources[typ] = self.Resources[typ] or {};
	return self.Resources[typ][name] or false;
end

function CResourceManager:FreeTable(tbl)
	for k,v in pairs(tbl) do
		if( type(v) == "table" ) then
			self:FreeTable(v);
		end
		tbl[k] = nil;
	end
end

function CResourceManager:FreeAll()
	self:FreeTable(self.Resources);
end

function CResourceManager:Free(typ, name)
	if( self.Resources[type] and self.Resources[type][name] ) then
		self.Resources[type][name] = nil;
	end
end

function CResourceManager:Shutdown()
	self:FreeAll();
end
