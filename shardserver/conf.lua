--[[
	Shard Engine
	Developed by Averice.
]]--

love.filesystem.setIdentity("shardserver");

function love.conf(t)
	t.console = true;
	t.title = "Shard Server";
	t.window.width = 1024;
	t.window.height = 768;
	t.window.fullscreen = false;
	t.window.vsync = false;
	t.window.borderless = false;
	t.author = "Averice";
end