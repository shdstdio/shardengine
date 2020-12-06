--[[
	Shard Engine
	Developed by Averice.
]]--
function GAME.ui.FloorPanel()

	GAME.Panels.floor = shardui.createPanel("ShardPanel");
	GAME.Panels.floor:SetPos(0, love.graphics.getHeight()-25);
	GAME.Panels.floor:SetSize( love.graphics.getWidth(), 25 );

	GAME.Panels.floor:SetVisible(true);

	GAME.Panels.floor.Details = shardui.createPanel("ShardLabel", GAME.Panels.floor);
	GAME.Panels.floor.Details:SetPos(5, 7)
	GAME.Panels.floor.Details:SetText("Mouse x:"..GAME.GPS.MOUSEPOS.x.." y:"..GAME.GPS.MOUSEPOS.y);
	GAME.Panels.floor.Details:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.floor.Details:SetSize(love.graphics.getWidth(), 10);
	GAME.Panels.floor.Details:SetMaxWidth(love.graphics.getWidth());
	GAME.Panels.floor.Details.Think = function(s)
		if( #terrain.Active >= 1 ) then
			local terr = terrain.Canvas[terrain.Active[#terrain.Active].short];
			s:SetText("[Mouse x:"..math.floor(GAME.GPS.MOUSEPOS.x).." y:"..math.floor(GAME.GPS.MOUSEPOS.y)
					.."]  [Block x:"..math.floor(GAME.GPS.MOUSEPOS.x/terr.BlockSize).." y:"..math.floor(GAME.GPS.MOUSEPOS.y/terr.BlockSize)
					.."]  [Chunk x:"..math.floor((GAME.GPS.MOUSEPOS.x/terr.BlockSize)/terr.ChunkSize).." y:"..math.floor((GAME.GPS.MOUSEPOS.y/terr.BlockSize)/terr.ChunkSize)
					.."]  [Current Tool: "..(GAME.ActionManager:GetActive() and GAME.ActionManager:GetActive().Command or "no_tool")
					.."]  [Show Grid: "..tostring(GAME.ShowDevGrid)
					.."]  [Grid Snap: "..tostring(GAME.SnapToGrid)
					.."]  [Block Size:  "..terr.BlockSize
					.."]");
		end
	end

end