--[[
	Shard Engine
	Developed by Averice.
]]--

entity = {}
entity.List = {}
ENTITY_COUNT = 0;
ENTITY_DELETED = 0;

function entity.Create(class, terrain_id)
	local succ, new_ent = pcall(new, class);
	if( succ ) then
		entity.List[terrain_id] = entity.List[terrain_id] or {}
		table.insert(entity.List[terrain_id], new_ent);
		ENTITY_COUNT = ENTITY_COUNT + 1;
		new_ent.short = ENTITY_COUNT;
		new_ent.terrain = terrain_id;
		return new_ent;
	end
	print("entity.Create could not create entity of class["..class.."] - "..new_ent);
end

-- Get world editor options for this entity.
function entity.GetOptions(class)
	local Class = _G[class];
	local Options = {}
	if( Class.ENT_INFO and Class.ENT_INFO.UI_OPTIONS ) then
		for i = 1, #Class.ENT_INFO.UI_OPTIONS do
			table.insert(Options, string.Explode(":", Class.ENT_INFO.UI_OPTIONS[i]));
			Options[i][3] = string.Explode(";", Options[i][3]);
		end
	end
	return Options;
end

function entity.Remove(id, terid)
	if( entity.List[terid] and entity.List[terid][id] ) then
		entity.List[terid][id] = nil;
		ENTITY_DELETED = 1;
	end
end

function entity.GetByIndex(id, terid)
	if( entity.List[terid] ) then
		return entity.List[terid][id] and entity.List[terid][id] or nil;
	end
end