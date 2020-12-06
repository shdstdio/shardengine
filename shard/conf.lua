--[[
	Shard Engine
	Developed by Averice.
]]--

love.filesystem.setIdentity("shard");

function love.conf(t)
	t.console = true;
	t.title = "Shard Client";
	t.window.width = 1680;
	t.window.height = 900;
	t.window.fullscreen = false;
	t.window.vsync = false;
	t.window.borderless = false;
	t.author = "Averice";
end
