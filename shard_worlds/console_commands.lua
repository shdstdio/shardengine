--[[
	Shard Engine
	Developed by Averice.
]]--

command.Create("create_map", function(...)
	local var = {...};
	local new_terrain = terrain.Create(var[1] or 16, var[2] or 16, var[3] or nil, var[4] or nil, var[5] or nil, var[6] or nil);
	terrain.Push(new_terrain);
	-- update terrain list object in ui?
end, "Creates a new terrain object 'create_map [ width_in_blocks height_in_blocks name block_size ]'");


command.Create("push_action", function(...)
	local var = {...};
	if( action.List[var[1]] ) then
		GAME.ActionManager:Push(action.List[var[1]], true)
		if( GAME.ActionManager:GetActive().OnSelect ) then
			GAME.ActionManager:GetActive():OnSelect();
		end
	end
end, "Push an editor action onto the stack 'push_action [ action_command ]'");