--[[
	Shard Engine
	Developed by Averice.
]]--
function GAME.ui.NewMapDialogue()

	GAME.Panels.nm_container = shardui.createPanel("ShardFrame");
	GAME.Panels.nm_container:SetTitle("Map Configuration");
	GAME.Panels.nm_container:SetSize(384, 500);
	GAME.Panels.nm_container:SetPos(love.graphics.getWidth()/2 - 200, love.graphics.getHeight()/2 - 250);

	GAME.Panels.nm_container.children = {}

	GAME.Panels.nm_container.children.scroll = shardui.createPanel("ShardPanel", GAME.Panels.nm_container);
	GAME.Panels.nm_container.children.scroll:SetPos(2, 22);
	GAME.Panels.nm_container.children.scroll:SetSize(380, 452);
	GAME.Panels.nm_container.children.scroll:EnableBorder(false);

	GAME.Panels.nm_container.children.create = shardui.createPanel("ShardButton", GAME.Panels.nm_container);
	GAME.Panels.nm_container.children.create:SetPos(2, 476)
	GAME.Panels.nm_container.children.create:SetSize(380, 20);
	GAME.Panels.nm_container.children.create:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.create:SetText("Create Terrain");
	GAME.Panels.nm_container.children.create.OnMouseReleased = function()
		command.Run("create_map",
			GAME.Panels.nm_container.children.SizeXPanel.Entry:GetValue(),
			GAME.Panels.nm_container.children.SizeYPanel.Entry:GetValue(),
			GAME.Panels.nm_container.children.NamePanel.Entry:GetValue(),
			GAME.Panels.nm_container.children.BlockPanel.Entry:GetValue(),
			GAME.Panels.nm_container.children.SeedPanel.Entry:GetValue(),
			GAME.Panels.nm_container.children.mSeedPanel.Entry:GetValue()
		);
		GAME.Panels.ReftTab.Tile.TextureBox:SetGridSize(GAME.Panels.nm_container.children.BlockPanel.Entry:GetValue());
	end


	--local easy = GAME.Panels.nm_container.children;
	GAME.Panels.nm_container.children.GenPanel = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.GenPanel:EnableBorder(false);
	GAME.Panels.nm_container.children.GenPanel:SetSize(376, 24);
	GAME.Panels.nm_container.children.GenPanel:SetPos(2, 2);

	GAME.Panels.nm_container.children.GenPanel.Line = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.GenPanel);
	GAME.Panels.nm_container.children.GenPanel.Line:SetPos(0, 23);
	GAME.Panels.nm_container.children.GenPanel.Line:SetColor(shardui.getSkinAttribute("LineColor", "Title"));
	GAME.Panels.nm_container.children.GenPanel.Line:EnableBorder(false);
	GAME.Panels.nm_container.children.GenPanel.Line:SetSize(376, 2);

	GAME.Panels.nm_container.children.GenPanel.Label = shardui.createPanel("ShardLabel", GAME.Panels.nm_container.children.GenPanel);
	GAME.Panels.nm_container.children.GenPanel.Label:SetPos(2, 6);
	GAME.Panels.nm_container.children.GenPanel.Label:SetSize(376, 20);
	GAME.Panels.nm_container.children.GenPanel.Label:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.GenPanel.Label:SetText("General Settings");
	GAME.Panels.nm_container.children.GenPanel.Label:SetMaxWidth(370);

	GAME.Panels.nm_container.children.NamePanel = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.NamePanel:EnableBorder(false);
	GAME.Panels.nm_container.children.NamePanel:SetSize(376, 24);
	GAME.Panels.nm_container.children.NamePanel:SetPos(2, 28);

	GAME.Panels.nm_container.children.NamePanel.Label = shardui.createPanel("ShardLabel", GAME.Panels.nm_container.children.NamePanel);
	GAME.Panels.nm_container.children.NamePanel.Label:SetPos(2, 6);
	GAME.Panels.nm_container.children.NamePanel.Label:SetSize(40, 20);
	GAME.Panels.nm_container.children.NamePanel.Label:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.NamePanel.Label:SetText("Name:");

	GAME.Panels.nm_container.children.NamePanel.Entry = shardui.createPanel("ShardTextEntry", GAME.Panels.nm_container.children.NamePanel);
	GAME.Panels.nm_container.children.NamePanel.Entry:SetPos(44, 2);
	GAME.Panels.nm_container.children.NamePanel.Entry:SetSize(332, 20);

	GAME.Panels.nm_container.children.SizeXPanel = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.SizeXPanel:EnableBorder(false);
	GAME.Panels.nm_container.children.SizeXPanel:SetSize(376, 24);
	GAME.Panels.nm_container.children.SizeXPanel:SetPos(2, 54);

	GAME.Panels.nm_container.children.SizeXPanel.Label = shardui.createPanel("ShardLabel", GAME.Panels.nm_container.children.SizeXPanel);
	GAME.Panels.nm_container.children.SizeXPanel.Label:SetPos(2, 6);
	GAME.Panels.nm_container.children.SizeXPanel.Label:SetSize(40, 20);
	GAME.Panels.nm_container.children.SizeXPanel.Label:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.SizeXPanel.Label:SetText("Width:");

	GAME.Panels.nm_container.children.SizeXPanel.Entry = shardui.createPanel("ShardSlider", GAME.Panels.nm_container.children.SizeXPanel);
	GAME.Panels.nm_container.children.SizeXPanel.Entry:SetPos(90, 2);
	GAME.Panels.nm_container.children.SizeXPanel.Entry:SetSize(262, 20);
	GAME.Panels.nm_container.children.SizeXPanel.Entry:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.SizeXPanel.Entry:SetBounds(1, 1024);

	GAME.Panels.nm_container.children.SizeYPanel = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.SizeYPanel:EnableBorder(false);
	GAME.Panels.nm_container.children.SizeYPanel:SetSize(376, 24);
	GAME.Panels.nm_container.children.SizeYPanel:SetPos(2, 80);

	GAME.Panels.nm_container.children.SizeYPanel.Label = shardui.createPanel("ShardLabel", GAME.Panels.nm_container.children.SizeYPanel);
	GAME.Panels.nm_container.children.SizeYPanel.Label:SetPos(2, 6);
	GAME.Panels.nm_container.children.SizeYPanel.Label:SetSize(40, 20);
	GAME.Panels.nm_container.children.SizeYPanel.Label:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.SizeYPanel.Label:SetText("Height:");

	GAME.Panels.nm_container.children.SizeYPanel.Entry = shardui.createPanel("ShardSlider", GAME.Panels.nm_container.children.SizeYPanel);
	GAME.Panels.nm_container.children.SizeYPanel.Entry:SetPos(90, 2);
	GAME.Panels.nm_container.children.SizeYPanel.Entry:SetSize(262, 20);
	GAME.Panels.nm_container.children.SizeYPanel.Entry:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.SizeYPanel.Entry:SetBounds(1, 1024);

	GAME.Panels.nm_container.children.BlockPanel = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.BlockPanel:EnableBorder(false);
	GAME.Panels.nm_container.children.BlockPanel:SetSize(376, 24);
	GAME.Panels.nm_container.children.BlockPanel:SetPos(2, 106);

	GAME.Panels.nm_container.children.BlockPanel.Label = shardui.createPanel("ShardLabel", GAME.Panels.nm_container.children.BlockPanel);
	GAME.Panels.nm_container.children.BlockPanel.Label:SetPos(2, 6);
	GAME.Panels.nm_container.children.BlockPanel.Label:SetSize(80, 20);
	GAME.Panels.nm_container.children.BlockPanel.Label:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.BlockPanel.Label:SetText("BlockSize:");

	GAME.Panels.nm_container.children.BlockPanel.Entry = shardui.createPanel("ShardDropList", GAME.Panels.nm_container.children.BlockPanel);
	GAME.Panels.nm_container.children.BlockPanel.Entry:SetPos(90, 2);
	GAME.Panels.nm_container.children.BlockPanel.Entry:SetSize(286, 20);
	GAME.Panels.nm_container.children.BlockPanel.Entry:SetValue(32);
	GAME.Panels.nm_container.children.BlockPanel.Entry:SetName("Select BlockSize(32x32)");
	GAME.Panels.nm_container.children.BlockPanel.Entry:AddItem("8x8",8);
	GAME.Panels.nm_container.children.BlockPanel.Entry:AddItem("16x16",16);
	GAME.Panels.nm_container.children.BlockPanel.Entry:AddItem("32x32",32);
	GAME.Panels.nm_container.children.BlockPanel.Entry:AddItem("64x64",64);
	GAME.Panels.nm_container.children.BlockPanel.Entry:AddItem("128x128",128);

	GAME.Panels.nm_container.children.NoiseLPanel = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.NoiseLPanel:EnableBorder(false);
	GAME.Panels.nm_container.children.NoiseLPanel:SetSize(376, 24);
	GAME.Panels.nm_container.children.NoiseLPanel:SetPos(2, 132);

	GAME.Panels.nm_container.children.NoiseLPanel.Line = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.NoiseLPanel);
	GAME.Panels.nm_container.children.NoiseLPanel.Line:SetPos(0, 23);
	GAME.Panels.nm_container.children.NoiseLPanel.Line:SetColor(shardui.getSkinAttribute("LineColor", "Title"));
	GAME.Panels.nm_container.children.NoiseLPanel.Line:EnableBorder(false);
	GAME.Panels.nm_container.children.NoiseLPanel.Line:SetSize(376, 2);

	GAME.Panels.nm_container.children.NoiseLPanel.Label = shardui.createPanel("ShardLabel", GAME.Panels.nm_container.children.NoiseLPanel);
	GAME.Panels.nm_container.children.NoiseLPanel.Label:SetPos(2, 6);
	GAME.Panels.nm_container.children.NoiseLPanel.Label:SetSize(376, 20);
	GAME.Panels.nm_container.children.NoiseLPanel.Label:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.NoiseLPanel.Label:SetText("Noise Configuration");
	GAME.Panels.nm_container.children.NoiseLPanel.Label:SetMaxWidth(376);

	GAME.Panels.nm_container.children.SeedPanel = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.SeedPanel:EnableBorder(false);
	GAME.Panels.nm_container.children.SeedPanel:SetSize(376, 24);
	GAME.Panels.nm_container.children.SeedPanel:SetPos(2, 158);

	GAME.Panels.nm_container.children.SeedPanel.Label = shardui.createPanel("ShardLabel", GAME.Panels.nm_container.children.SeedPanel);
	GAME.Panels.nm_container.children.SeedPanel.Label:SetPos(2, 6);
	GAME.Panels.nm_container.children.SeedPanel.Label:SetSize(40, 20);
	GAME.Panels.nm_container.children.SeedPanel.Label:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.SeedPanel.Label:SetText("HeightMap:");

	GAME.Panels.nm_container.children.SeedPanel.Entry = shardui.createPanel("ShardTextEntry", GAME.Panels.nm_container.children.SeedPanel);
	GAME.Panels.nm_container.children.SeedPanel.Entry:SetPos(79, 2);
	GAME.Panels.nm_container.children.SeedPanel.Entry:SetSize(297, 20);
	GAME.Panels.nm_container.children.SeedPanel.Entry:SetNumerical(true);

	GAME.Panels.nm_container.children.mSeedPanel = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.mSeedPanel:EnableBorder(false);
	GAME.Panels.nm_container.children.mSeedPanel:SetSize(376, 24);
	GAME.Panels.nm_container.children.mSeedPanel:SetPos(2, 184);

	GAME.Panels.nm_container.children.mSeedPanel.Label = shardui.createPanel("ShardLabel", GAME.Panels.nm_container.children.mSeedPanel);
	GAME.Panels.nm_container.children.mSeedPanel.Label:SetPos(2, 6);
	GAME.Panels.nm_container.children.mSeedPanel.Label:SetSize(40, 20);
	GAME.Panels.nm_container.children.mSeedPanel.Label:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.mSeedPanel.Label:SetText("MoisetureMap:");

	GAME.Panels.nm_container.children.mSeedPanel.Entry = shardui.createPanel("ShardTextEntry", GAME.Panels.nm_container.children.mSeedPanel);
	GAME.Panels.nm_container.children.mSeedPanel.Entry:SetPos(79, 2);
	GAME.Panels.nm_container.children.mSeedPanel.Entry:SetSize(297, 20);
	GAME.Panels.nm_container.children.mSeedPanel.Entry:SetNumerical(true);

	GAME.Panels.nm_container.children.GenMaps = shardui.createPanel("ShardButton", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.GenMaps:SetSize(376, 20);
	GAME.Panels.nm_container.children.GenMaps:SetPos(2, 210);
	GAME.Panels.nm_container.children.GenMaps:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.GenMaps:SetText("View Noisemaps");
	GAME.Panels.nm_container.children.GenMaps.OnMouseReleased = function()
		local noise, moist = terrain.GenerateNoiseMaps(tonumber(GAME.Panels.nm_container.children.SeedPanel.Entry:GetValue()),
													tonumber(GAME.Panels.nm_container.children.mSeedPanel.Entry:GetValue()),
													tonumber(GAME.Panels.nm_container.children.SizeXPanel.Entry:GetValue()),
													tonumber(GAME.Panels.nm_container.children.SizeYPanel.Entry:GetValue()));
		game.ImageViewer(noise, nil, nil, 300, 300, "Height Map");
		game.ImageViewer(moist, ScrW()/2 - 200, ScrH()/2 - 200, 300, 300, "Moisture Map");
	end

	GAME.Panels.nm_container.children.TexLPanel = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.TexLPanel:EnableBorder(false);
	GAME.Panels.nm_container.children.TexLPanel:SetSize(376, 24);
	GAME.Panels.nm_container.children.TexLPanel:SetPos(2, 238);

	GAME.Panels.nm_container.children.TexLPanel.Line = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.TexLPanel);
	GAME.Panels.nm_container.children.TexLPanel.Line:SetPos(0, 23);
	GAME.Panels.nm_container.children.TexLPanel.Line:SetColor(shardui.getSkinAttribute("LineColor", "Title"));
	GAME.Panels.nm_container.children.TexLPanel.Line:EnableBorder(false);
	GAME.Panels.nm_container.children.TexLPanel.Line:SetSize(376, 2);

	GAME.Panels.nm_container.children.TexLPanel.Label = shardui.createPanel("ShardLabel", GAME.Panels.nm_container.children.TexLPanel);
	GAME.Panels.nm_container.children.TexLPanel.Label:SetPos(2, 6);
	GAME.Panels.nm_container.children.TexLPanel.Label:SetSize(376, 20);
	GAME.Panels.nm_container.children.TexLPanel.Label:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.TexLPanel.Label:SetText("World Setup");
	GAME.Panels.nm_container.children.TexLPanel.Label:SetMaxWidth(376);

	GAME.Panels.nm_container.children.SetupScroll = shardui.createPanel("ShardScrollPanel", GAME.Panels.nm_container.children.scroll);
	GAME.Panels.nm_container.children.SetupScroll:EnableVerticalScrollBar(true);
	GAME.Panels.nm_container.children.SetupScroll:SetSize(376, 186);
	GAME.Panels.nm_container.children.SetupScroll:SetPos(2, 266);

	local biome_setup = ResourceManager:NewImage("textures/ui/split.gif");
	local doc_setup = ResourceManager:NewImage("textures/ui/document.gif");

	GAME.Panels.nm_container.children.TextList = {}

	GAME.Panels.nm_container.children.TextList[1] = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.SetupScroll);
	GAME.Panels.nm_container.children.TextList[1]:SetSize(372, 14);
	GAME.Panels.nm_container.children.TextList[1]:EnableBorder(false);

	GAME.Panels.nm_container.children.TextList[1].FolderIcon = shardui.createPanel("ShardButton", GAME.Panels.nm_container.children.TextList[1]);
	GAME.Panels.nm_container.children.TextList[1].FolderIcon:SetPos(5, 2);
	GAME.Panels.nm_container.children.TextList[1].FolderIcon:SetSize(10, 10);
	GAME.Panels.nm_container.children.TextList[1].FolderIcon:SetImage(biome_setup);
	GAME.Panels.nm_container.children.TextList[1].FolderIcon.Colors.BorderColor = Color(0, 0, 0, 0);
	GAME.Panels.nm_container.children.TextList[1].FolderIcon.Colors.Color = Color(0, 0, 0, 0);
	GAME.Panels.nm_container.children.TextList[1].FolderIcon.OnMouseEnter = function()
		GAME.Panels.nm_container.children.TextList[1].Text:OnMouseEnter();
	end
	GAME.Panels.nm_container.children.TextList[1].FolderIcon.OnMouseReleased = function()
		GAME.Panels.nm_container.children.TextList[1].Test:OnMouseReleased();
	end

	GAME.Panels.nm_container.children.TextList[1].Text = shardui.createPanel("ShardTextButton", GAME.Panels.nm_container.children.TextList[1])
	GAME.Panels.nm_container.children.TextList[1].Text:SetPos(17, 0)
	GAME.Panels.nm_container.children.TextList[1].Text:SetSize(352, 14);
	GAME.Panels.nm_container.children.TextList[1].Text:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.TextList[1].Text:SetText("Biome generation settings (Advanced)");
	GAME.Panels.nm_container.children.TextList[1].Text:SetAlign(2);
	GAME.Panels.nm_container.children.TextList[1].Text.OnMouseReleased = function(self)
	end

	GAME.Panels.nm_container.children.TextList[2] = shardui.createPanel("ShardPanel", GAME.Panels.nm_container.children.SetupScroll);
	GAME.Panels.nm_container.children.TextList[2]:SetSize(372, 24);
	GAME.Panels.nm_container.children.TextList[2]:EnableBorder(false);

	GAME.Panels.nm_container.children.TextList[2].FolderIcon = shardui.createPanel("ShardButton", GAME.Panels.nm_container.children.TextList[2]);
	GAME.Panels.nm_container.children.TextList[2].FolderIcon:SetPos(5, 2);
	GAME.Panels.nm_container.children.TextList[2].FolderIcon:SetSize(20, 20);
	GAME.Panels.nm_container.children.TextList[2].FolderIcon:SetImage(doc_setup);
	GAME.Panels.nm_container.children.TextList[2].FolderIcon.Colors.BorderColor = Color(0, 0, 0, 0);
	GAME.Panels.nm_container.children.TextList[2].FolderIcon.Colors.Color = Color(0, 0, 0, 0);
	GAME.Panels.nm_container.children.TextList[2].FolderIcon.OnMouseEnter = function()
		GAME.Panels.nm_container.children.TextList[2].Text:OnMouseEnter();
	end
	GAME.Panels.nm_container.children.TextList[2].FolderIcon.OnMouseReleased = function()
		GAME.Panels.nm_container.children.TextList[2].Test:OnMouseReleased();
	end

	GAME.Panels.nm_container.children.TextList[2].Text = shardui.createPanel("ShardTextButton", GAME.Panels.nm_container.children.TextList[2])
	GAME.Panels.nm_container.children.TextList[2].Text:SetPos(17, 0)
	GAME.Panels.nm_container.children.TextList[2].Text:SetSize(352, 24);
	GAME.Panels.nm_container.children.TextList[2].Text:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	GAME.Panels.nm_container.children.TextList[2].Text:SetText("Base texture setup (Standard maps)");
	GAME.Panels.nm_container.children.TextList[2].Text:SetAlign(2);
	GAME.Panels.nm_container.children.TextList[2].Text.OnMouseReleased = function(self)
	end

	GAME.Panels.nm_container.children.SetupScroll:AddItem(GAME.Panels.nm_container.children.TextList[1]);
	GAME.Panels.nm_container.children.SetupScroll:AddItem(GAME.Panels.nm_container.children.TextList[2]);


	GAME.Panels.nm_container:SetVisible(true);

end
