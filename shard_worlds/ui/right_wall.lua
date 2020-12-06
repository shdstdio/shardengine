--[[
	Shard Engine
	Developed by Averice.
]]--
function GAME.ui.ReftWall()
	local tool_option = ResourceManager:NewImage("textures/ui/plugin.gif");
	local tileset_image = ResourceManager:NewImage("textures/ui/image.gif");
	local load_tile = ResourceManager:NewImage("textures/ui/save.png");

	GAME.Panels.rWall = shardui.createPanel("ShardPanel");
	GAME.Panels.rWall:SetPos(love.graphics.getWidth()-400, 67);
	GAME.Panels.rWall:SetSize(400, love.graphics.getHeight()-93);

	GAME.Panels.ReftTab = shardui.createPanel("ShardTab", GAME.Panels.rWall);
	GAME.Panels.ReftTab:SetPos(2, 2);
	GAME.Panels.ReftTab:SetSize(396, love.graphics.getHeight()-116);

	GAME.Panels.ReftTab.Tool = shardui.createPanel("ShardTabPanel", GAME.Panels.ReftTab);
	GAME.Panels.ReftTab.Tool:SetPos(0, 20);
	GAME.Panels.ReftTab.Tool:SetSize(396, love.graphics.getHeight()-116);
	GAME.Panels.ReftTab:AddTab("Tool", GAME.Panels.ReftTab.Tool, tool_option, 60);

	GAME.Panels.ReftTab.Tile = shardui.createPanel("ShardTabPanel", GAME.Panels.ReftTab);
	GAME.Panels.ReftTab.Tile:SetPos(0, 20);
	GAME.Panels.ReftTab.Tile:SetSize(396, love.graphics.getHeight()-116);
	GAME.Panels.ReftTab:AddTab("Tileset", GAME.Panels.ReftTab.Tile, tileset_image, 60);

	GAME.Panels.ReftTab.TilesetTitle = shardui.createPanel("ShardLabel", GAME.Panels.ReftTab.Tile);
	GAME.Panels.ReftTab.TilesetTitle:SetPos(4, 6);
	GAME.Panels.ReftTab.TilesetTitle:SetSize(388, 14);
	GAME.Panels.ReftTab.TilesetTitle:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.ReftTab.TilesetTitle:SetText("Tile Selection");
	GAME.Panels.ReftTab.TilesetTitle:SetMaxWidth(370);

	GAME.Panels.ReftTab.Line1 = shardui.createPanel("ShardPanel", GAME.Panels.ReftTab.Tile);
	GAME.Panels.ReftTab.Line1:SetPos(4, 23);
	GAME.Panels.ReftTab.Line1:SetColor(shardui.getSkinAttribute("LineColor", "Title"));
	GAME.Panels.ReftTab.Line1:EnableBorder(false);
	GAME.Panels.ReftTab.Line1:SetSize(388, 2);

	GAME.Panels.ReftTab.Tile.SelLabel = shardui.createPanel("ShardLabel", GAME.Panels.ReftTab.Tile);
	GAME.Panels.ReftTab.Tile.SelLabel:SetPos(4, 27);
	GAME.Panels.ReftTab.Tile.SelLabel:SetSize(366, 20);
	GAME.Panels.ReftTab.Tile.SelLabel:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.ReftTab.Tile.SelLabel:SetText("no/tileset/selected.png");

	GAME.Panels.ReftTab.Tile.Button = shardui.createPanel("ShardButton", GAME.Panels.ReftTab.Tile)
	GAME.Panels.ReftTab.Tile.Button:SetPos(370, 27);
	GAME.Panels.ReftTab.Tile.Button:SetSize(20, 20);
	GAME.Panels.ReftTab.Tile.Button:SetPadding(2, 2);
	GAME.Panels.ReftTab.Tile.Button:SetImage(load_tile)
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.ReftTab.Tile.Button:SetToolTip("Load Tilesheet");
	end
	GAME.Panels.ReftTab.Tile.Button.OnMouseReleased = function()
		game.FileViewer("textures", ScrW()/2 - 250, ScrH()/2 - 127, "Select Titleset", on_tileset_select);
	end

	GAME.Panels.ReftTab.Layer = shardui.createPanel("ShardDropList", GAME.Panels.ReftTab.Tile)
	GAME.Panels.ReftTab.Layer:SetPos(4, 49);
	GAME.Panels.ReftTab.Layer:SetSize(150, 20);
	GAME.Panels.ReftTab.Layer:SetName("Base Layer");
	GAME.Panels.ReftTab.Layer:AddItem("Base Layer", GAME_BASE_LAYER);
	GAME.Panels.ReftTab.Layer:AddItem("Ground Layer", GAME_GROUND_LAYER); -- sort Z once.
	GAME.Panels.ReftTab.Layer:AddItem("Ground Detail", GAME_GROUND_DETAIL) -- sort Z once.
	GAME.Panels.ReftTab.Layer:AddItem("Entitiy Layer", GAME_ENTITY_LAYER);
	GAME.Panels.ReftTab.Layer:AddItem("Foreground Detail", GAME_FORE_DETAIL);
	GAME.Panels.ReftTab.Layer.OnSelect = function(self, value)
		GAME.Layer = value;
		if( GAME.Layer == GAME_BASE_LAYER or GAME.Layer == GAME_GROUND_LAYER ) then
			GAME.Panels.ReftTab.Tile.TextureBox:SelectOneBlockOnly(true);
			GAME.Panels.ReftTab.Tile.TextureBox:ClearSelection();
		else
			GAME.Panels.ReftTab.Tile.TextureBox:SelectOneBlockOnly(false);
		end
	end

	GAME.Panels.ReftTab.Tile.TextureBox = shardui.createPanel("TextureBox", GAME.Panels.ReftTab.Tile)
	GAME.Panels.ReftTab.Tile.TextureBox:SetPos(2, 87);
	GAME.Panels.ReftTab.Tile.TextureBox:SetSize(392, 400);
	GAME.Panels.ReftTab.Tile.TextureBox:SetTexture("textures/hyptosis_tile-art-batch-1.png");
	GAME.Panels.ReftTab.Tile.TextureBox:SelectOneBlockOnly(true);
	GAME.Panels.ReftTab.Tile.TextureBox.OnSelectionFinished = on_tileselection_selected;

	GAME.Panels.rWall:SetVisible(true);
end

function on_tileset_select(str)
	GAME.Panels.ReftTab.Tile.SelLabel:SetText(str);
	GAME.Panels.ReftTab.Tile.TextureBox:SetTexture(str);
	GAME.Panels.ReftTab.Tile.TextureBox:ClearSelection();
	GAME.Panels.ReftTab.Tile.TextureBox:Center();
end

function on_tileselection_selected(s)
	if( s.DrawTexture and s.Selection and s.Selection.Quad ) then
		GAME.TextureSelection = GAME.TextureSelection or {}
		GAME.TextureSelection.dTexture = s.DrawTexture;
		GAME.TextureSelection.dQuad = love.graphics.newQuad(s.Selection.Quad.x, s.Selection.Quad.y, s.Selection.Quad.x2 - s.Selection.Quad.x, s.Selection.Quad.y2 - s.Selection.Quad.y, s.DrawTexture:getDimensions());
		GAME.TextureSelection.sTexture = s.Texture;
		GAME.TextureSelection.sQuad = s.Selection.Quad;
		GAME.TextureSelection.Dimensions = { GAME.TextureSelection.dTexture:getDimensions() };
	end
end

-- now we get to make the texture placement tool, then we're almost up to date on the old version, wooooop.