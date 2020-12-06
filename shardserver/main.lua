--[[
	Shard Engine
	Developed by Averice.
]]--

shard = {
	__VERSION = "0.01 Overview",
	__AUTHOR = "Averice",
	__DESCRIPTION = "Engine Framework for game development",
	__DEBUG = true
}
require "global";

require "modules.json";

require "modules.class";
require "modules.hook";
require "modules.timer";
require "modules.string";
require "modules.command";
require "modules.network";

require "class.plugin"

require "shardui.shard";

PluginManager = new "CPluginManager";

love.keyboard.setKeyRepeat(true);
function love.load(arg)
	love.graphics.setBackgroundColor(Color(100,100,100,255))
	hook.Call("Init", arg);
	PluginManager:LoadPlugins();
	hook.Call("PostInit", arg);
	net.Connect();
end

function love.update(dt)

	hook.Call("Think", dt);
	shardui.think(dt);
	PluginManager:Think(dt);
	net.Think(dt);

end

function love.focus(f)

	hook.Call("Focus", f);
	PluginManager:Focus(f);

end

function love.keypressed(k, u)

	hook.Call("KeyPressed", k, u);
	shardui.keypressed(k, u);
	PluginManager:KeyPress(k, u);

end

function love.keyreleased(k, u)

	hook.Call("KeyReleased", k, u);
	shardui.keyreleased(k, u);
	PluginManager:KeyRelease(k, u);

end

function love.mousepressed(x, y, b)

	hook.Call("MousePressed", x, y, b);
	shardui.mousepressed(x, y, b);
	PluginManager:MousePressed(x, y, b);

end

function love.mousereleased(x, y, b)

	hook.Call("MouseReleased", x, y, b);
	shardui.mousereleased(x, y, b);
	PluginManager:MouseReleased(x, y, b);

end

function love.textinput(t)
	hook.Call("TextInput", t);
	shardui.textinput(t);
	PluginManager:TextInput(t);
end

function love.draw()

	hook.Call("Draw");
	PluginManager:Draw();
	shardui.paint();
	-- More Drawing

	-- Start Post Drawing.
	hook.Call("PostDraw");
	PluginManager:PostDraw();

end

function love.quit()

	hook.Call("Shutdown");
	PluginManager:Shutdown();

	PluginManager = nil;

end