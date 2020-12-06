--[[
	Shard Engine
	Developed by Averice.
]]--

local PLUGIN = {}
PLUGIN.Version = "0.01";
PLUGIN.Name = "Debug UI";
PLUGIN.Id = "shard_debugui";
PLUGIN.Author = "Averice";
PLUGIN.Description = [[Enables a debug panel by typing debug_ui in console]];

function PLUGIN:Init()

	self.Frame = shardui.createPanel("ShardFrame");
	self.Frame:SetSize(150, 150);
	self.Frame:SetPos(20, 220);
	self.Frame:SetTitle("Debug");

	self.FPS = shardui.createPanel("ShardLabel", self.Frame);
	self.FPS:SetPos(2, 22);
	self.FPS:SetSize(150, 10);
	self.FPS:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	self.FPS:SetText("Frame/s:");

	self.FPSNumber = shardui.createPanel("ShardLabel", self.Frame);
	self.FPSNumber:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	self.FPSNumber:SetPos(148 - self.FPSNumber.Font:getWidth(shard.__FPS), 22);
	self.FPSNumber:SetSize(150, 10);
	self.FPSNumber:SetText(shard.__FPS);
	self.FPSNumber.Think = function(s, dt)
		s:SetText(shard.__FPS);
		s:SetPos(148 - s.Font:getWidth(shard.__FPS), 22);
	end

	self.Memory = shardui.createPanel("ShardLabel", self.Frame);
	self.Memory:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	self.Memory:SetPos(2, 34);
	self.Memory:SetSize(150, 10);
	self.Memory:SetText("Frame Time:");
	self.Memory:SetMaxWidth(150);

	self.MemoryNumber = shardui.createPanel("ShardLabel", self.Frame);
	self.MemoryNumber:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	self.MemoryNumber:SetPos(148 - self.FPSNumber.Font:getWidth("0"), 34);
	self.MemoryNumber:SetSize(150, 10);
	self.MemoryNumber:SetText("0");
	self.MemoryNumber.Think = function(s, dt)
		local sz = math.floor( dt * (10^3) ) / (10^3);
		s:SetText(sz);
		s:SetPos(148 - s.Font:getWidth(sz), 34);
	end

	self.Terrain = shardui.createPanel("ShardLabel", self.Frame);
	self.Terrain:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	self.Terrain:SetPos(2, 46);
	self.Terrain:SetSize(150, 10);
	self.Terrain:SetText("Active Terrain(s):");
	self.Terrain:SetMaxWidth(150);

	self.TNumber = shardui.createPanel("ShardLabel", self.Frame);
	self.TNumber:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	self.TNumber:SetPos(148 - self.TNumber.Font:getWidth("0"), 46);
	self.TNumber:SetSize(150, 10);
	self.TNumber:SetText("0");
	self.TNumber.Think = function(s, dt)
		s:SetText(#terrain.Active);
		s:SetPos(148 - s.Font:getWidth(#terrain.Active), 46);
	end

	self.Ent = shardui.createPanel("ShardLabel", self.Frame);
	self.Ent:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	self.Ent:SetPos(2, 58);
	self.Ent:SetSize(150, 10);
	self.Ent:SetText("Entities:");
	self.Ent:SetMaxWidth(150);

	self.ENumber = shardui.createPanel("ShardLabel", self.Frame);
	self.ENumber:SetFont(shardui.getSkinAttribute("Font", "CheckBox"));
	self.ENumber:SetPos(138, 58);
	self.ENumber:SetSize(150, 10);
	self.ENumber:SetText("0");
	self.ENumber.Think = function(s, dt)
		s:SetText(ENTITY_COUNT - ENTITY_DELETED);
		s:SetPos(148 - s.Font:getWidth(ENTITY_COUNT-ENTITY_DELETED), 58);
	end

	self.Frame:SetVisible(false);

	command.Create("debug_ui", function()
		self.Frame:SetVisible(not self.Frame:IsVisible())
		shardui.paintOver(self.Frame)
	end, "Shows a debug panel");
end

return PLUGIN;