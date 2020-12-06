--[[
	Shard Engine
	Developed by Averice.
]]--
function GAME.ui.LeftWall()
	local terrain_globe = ResourceManager:NewImage("textures/ui/globe.gif");
	local entity_cube = ResourceManager:NewImage("textures/ui/transmission.gif");
	local logic_table = ResourceManager:NewImage("textures/ui/sound_on.gif");

	GAME.Panels.lWall = shardui.createPanel("ShardPanel");
	GAME.Panels.lWall:SetPos(0, 67);
	GAME.Panels.lWall:SetSize(300, love.graphics.getHeight()-93);

	GAME.Panels.LeftTab = shardui.createPanel("ShardTab", GAME.Panels.lWall);
	GAME.Panels.LeftTab:SetPos(2, 2);
	GAME.Panels.LeftTab:SetSize(296, love.graphics.getHeight()-116);

	GAME.Panels.LeftTab.Terrain = shardui.createPanel("ShardTabPanel", GAME.Panels.LeftTab);
	GAME.Panels.LeftTab.Terrain:SetPos(0, 20);
	GAME.Panels.LeftTab.Terrain:SetSize(296, love.graphics.getHeight()-116);
	GAME.Panels.LeftTab:AddTab("World", GAME.Panels.LeftTab.Terrain, terrain_globe, 60);

	GAME.Panels.LeftTab.Entities = shardui.createPanel("ShardTabPanel", GAME.Panels.LeftTab);
	GAME.Panels.LeftTab.Entities:SetPos(0, 20);
	GAME.Panels.LeftTab.Entities:SetSize(296, love.graphics.getHeight()-116);
	GAME.Panels.LeftTab:AddTab("Lights", GAME.Panels.LeftTab.Entities, entity_cube, 60);

	GAME.Panels.LeftTab.Logic = shardui.createPanel("ShardTabPanel", GAME.Panels.LeftTab);
	GAME.Panels.LeftTab.Logic:SetPos(0, 20);
	GAME.Panels.LeftTab.Logic:SetSize(296, love.graphics.getHeight()-116);
	GAME.Panels.LeftTab:AddTab("Sounds", GAME.Panels.LeftTab.Logic, logic_table, 60);

	GAME.Panels.lWall:SetVisible(true);
end
