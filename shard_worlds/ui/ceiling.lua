--[[
	Shard Engine
	Developed by Averice.
]]--
function GAME.ui.CeilingPanel()

	local newmap_image = ResourceManager:NewImage("textures/ui/page_white.png");
	local loadmap_image = ResourceManager:NewImage("textures/ui/page_white_database.png");
	local savemap_image_saved = ResourceManager:NewImage("textures/ui/page_white_code.png");
	local savemap_image_unsaved = ResourceManager:NewImage("textures/ui/page_white_code_red.png");
	local user_setting_image = ResourceManager:NewImage("textures/ui/page_white_gear.png");
	local view_output_image = ResourceManager:NewImage("textures/ui/page_white_vector.png");
	local undo_image = ResourceManager:NewImage("textures/ui/arrow_rotate_clockwise.png");
	local redo_image = ResourceManager:NewImage("textures/ui/arrow_rotate_anticlockwise.png");
	local select_image = ResourceManager:NewImage("textures/ui/ground.png");
	local grid_image = ResourceManager:NewImage("textures/ui/shape_handles.png");
	local texture_image = ResourceManager:NewImage("textures/ui/picture.png");
	local snap_image = ResourceManager:NewImage("textures/ui/shape_move_forwards.png")

	GAME.Panels.container = shardui.createPanel("ShardFrame");
	GAME.Panels.container:SetPos(0, 0);
	GAME.Panels.container:SetSize( love.graphics.getWidth(), 67 );
	GAME.Panels.container:SetTitle("Shard Engine");
	GAME.Panels.container:Pinnable(false);
	GAME.Panels.container:EnableDragging(false);
	GAME.Panels.container.OnClose = function() end;


	GAME.Panels.container.children = {}

	GAME.Panels.container.children.new_map = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.new_map:SetSize(20, 20);
	GAME.Panels.container.children.new_map:SetPos(2, 22);
	GAME.Panels.container.children.new_map:SetPadding(2);
	GAME.Panels.container.children.new_map:SetImage(newmap_image);
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.new_map:SetToolTip("New Map");
	end
	GAME.Panels.container.children.new_map.OnMouseReleased = function()
		GAME.ui.NewMapDialogue();
	end

	GAME.Panels.container.children.load_map = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.load_map:SetSize(20, 20);
	GAME.Panels.container.children.load_map:SetPos(24, 22);
	GAME.Panels.container.children.load_map:SetPadding(2);
	GAME.Panels.container.children.load_map:SetImage(loadmap_image);
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.load_map:SetToolTip("Load Map");
	end


	GAME.Panels.container.children.save_map = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.save_map:SetSize(20, 20);
	GAME.Panels.container.children.save_map:SetPos(46, 22);
	GAME.Panels.container.children.save_map:SetPadding(2);
	GAME.Panels.container.children.save_map:SetImage(savemap_image_saved);
	GAME.Panels.container.children.save_map.Status = true;
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.save_map:SetToolTip("Save Map [ctrl+s]");
	end
	GAME.Panels.container.children.save_map.Think = function(self)
		if not( GAME.SaveStatus == self.Status ) then
			self.Status = GAME.SaveStatus;
			if( self.Status ) then
				GAME.Panels.container.children.save_map:SetImage(savemap_image_saved);
			else
				GAME.Panels.container.children.save_map:SetImage(savemap_image_unsaved);
			end
		end
	end

	GAME.Panels.container.children.usrsetting = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.usrsetting:SetSize(20, 20);
	GAME.Panels.container.children.usrsetting:SetPos(68, 22);
	GAME.Panels.container.children.usrsetting:SetPadding(2);
	GAME.Panels.container.children.usrsetting:SetImage(user_setting_image);
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.usrsetting:SetToolTip("Settings");
	end

	GAME.Panels.container.children.output = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.output:SetSize(20, 20);
	GAME.Panels.container.children.output:SetPos(90, 22);
	GAME.Panels.container.children.output:SetPadding(2);
	GAME.Panels.container.children.output:SetImage(view_output_image);
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.output:SetToolTip("View Output File");
	end

	GAME.Panels.container.children.undo = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.undo:SetSize(20, 20);
	GAME.Panels.container.children.undo:SetPos(122, 22);
	GAME.Panels.container.children.undo:SetPadding(2);
	GAME.Panels.container.children.undo:SetImage(undo_image);
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.undo:SetToolTip("Undo [ctrl+z]");
	end
	GAME.Panels.container.children.undo.OnMouseReleased = function()
		if( #terrain.Active > 0 ) then
			action.Undo();
		end
	end

	GAME.Panels.container.children.redo = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.redo:SetSize(20, 20);
	GAME.Panels.container.children.redo:SetPos(144, 22);
	GAME.Panels.container.children.redo:SetPadding(2);
	GAME.Panels.container.children.redo:SetImage(redo_image);
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.redo:SetToolTip("Redo [ctrl+y]");
	end
	GAME.Panels.container.children.redo.OnMouseReleased = function()
		if( #terrain.Active > 0 ) then
			action.Redo();
		end
	end

	GAME.Panels.container.children.grid = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.grid:SetSize(20, 20);
	GAME.Panels.container.children.grid:SetPos(176, 22);
	GAME.Panels.container.children.grid:SetPadding(2);
	GAME.Panels.container.children.grid:SetImage(grid_image);
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.grid:SetToolTip("Show Grid [shift+g]");
	end
	GAME.Panels.container.children.grid.OnMouseReleased = function()
		GAME.ShowDevGrid = not GAME.ShowDevGrid;
	end

	GAME.Panels.container.children.snap = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.snap:SetSize(20, 20);
	GAME.Panels.container.children.snap:SetPos(198, 22);
	GAME.Panels.container.children.snap:SetPadding(2);
	GAME.Panels.container.children.snap:SetImage(snap_image);
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.snap:SetToolTip("Snap to Grid [shift+;]");
	end
	GAME.Panels.container.children.snap.OnMouseReleased = function()
		GAME.SnapToGrid = not GAME.SnapToGrid;
	end

	GAME.Panels.container.children.select = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.select:SetSize(20, 20);
	GAME.Panels.container.children.select:SetPos(220, 22);
	GAME.Panels.container.children.select:SetPadding(2);
	GAME.Panels.container.children.select:SetImage(select_image);
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.select:SetToolTip("Select [shift+s]");
	end
	GAME.Panels.container.children.select.OnMouseReleased = function()
		command.Run("push_action", "select_tool");
	end

	GAME.Panels.container.children.texture = shardui.createPanel("ShardButton", GAME.Panels.container);
	GAME.Panels.container.children.texture:SetSize(20, 20);
	GAME.Panels.container.children.texture:SetPos(242, 22);
	GAME.Panels.container.children.texture:SetPadding(2);
	GAME.Panels.container.children.texture:SetImage(texture_image);
	if( GAME.Settings.showtooltip ) then
		GAME.Panels.container.children.texture:SetToolTip("Texture [shift+t]");
	end
	GAME.Panels.container.children.texture.OnMouseReleased = function()
		command.Run("push_action", "texture_tool");
	end

	

	GAME.Panels.container:SetVisible(true);

end

keycommand.NewShortcut("Grid", "Enable or Disable the grid", false, function() GAME.ShowDevGrid = not GAME.ShowDevGrid end, "lshift", "g");
keycommand.NewShortcut("Select Tool", "Equips the select tool", false, function() command.Run("push_action", "select_tool") end, "lshift", "s");
keycommand.NewShortcut("Texture Tool", "Equips the texture tool", false, function() command.Run("push_action", "texture_tool") end, "lshift", "t");
keycommand.NewShortcut("Snap to Grid", "Toggles grid snapping", false, function() GAME.SnapToGrid = not GAME.SnapToGrid end, "lshift", ";");