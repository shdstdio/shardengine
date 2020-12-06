--[[
	Shard Engine
	Developed by Averice.
]]--

shard = {
	__VERSION = "0.1.3",
	__AUTHOR = "Averice",
	__DEBUG = true,
	__APPID = "shard_worlds",
	__FPS = 0,
	__MEM = 0

}

APPINFO = {
	Game = "Shard Engine",
	Author = "Averice",
	Version = "0.1"
}

require "global";
require "enum";

require "modules.json";

require "modules.class";
require "modules.hook";
require "modules.timer";
require "modules.string";
require "modules.command";
require "modules.network";
require "modules.file";
require "modules.game";
require "modules.entity";
require "modules.complex";
require "modules.simplex";
require "modules.terrain";
require "modules.keycommand";

require "class.plugin";
require "class.statemanager";
require "class.state";
require "class.vector";
require "class.color";
require "class.resourcemanager";
require "class.mapobject";
require "class.entity";
require "class.chunk";

-- Entities
require "entities.camera";
require "entities.test";

require "shardui.shard";
PluginManager = new "CPluginManager";
StateManager = new "CStateManager";
ResourceManager = new "CResourceManager";


-- Default resources. I know shardui loads some of these but it's designed as a standalone package.
shard.DefaultFontSmall = ResourceManager:NewFont("def_small", "fonts/DroidSansMono.ttf", 8);
shard.DefaultFont = ResourceManager:NewFont("def", "fonts/DroidSansMono.ttf", 12);
shard.DefaultFontLarge = ResourceManager:NewFont("def_large", "fonts/DroidSansMono.ttf", 16);

--require "nettest";
local lovesplash = require "splash.lovesplash";
local shardsplash = require "splash.splash";

love.keyboard.setKeyRepeat(true);
function love.load(arg)
	if( arg[2] ) then
		shard.__APPID = arg[2];
	end

	if( love.filesystem.isFused() ) then
		local success = love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "content");
		if( success ) then
			print("Content directory mounted.");
		end
	else
		print("Content directory could not be mounted, please open shard_engine.exe to mount third party assets.");
	end
	

	local succ, err = pcall(require, shard.__APPID..".appinfo");
	if( not succ ) then
		print("Failed to load: "..shard.__APPID);
	end
	succ, err = pcall(require, shard.__APPID..".init");
	if( not succ ) then
		print(shard.__APPID.." error: "..err);
	end
	love.window.setTitle(APPINFO.Game or "Shard Engine");

	love.graphics.setBackgroundColor(100,100,100,255)
	ResourceManager:Init();
	hook.Call("Init", arg);
	PluginManager:LoadPlugins();
	StateManager:Init();
	if( GAME ) then
		StateManager:Push(GAME, isdbg());
		if( GAME.PluginsUsed and GAME.PluginsUsed[1] ) then
			for i = 1, #GAME.PluginsUsed do
				PluginManager:LoadFromFile(game.GetDirectory(true)..".plugins."..GAME.PluginsUsed[i]..".init");
			end
		end
		if( GAME.Menu ) then
			StateManager:Push(require(game.GetDirectory(true).."."..GAME.Menu));
		end
		if( GAME.Splash ) then
			StateManager:Push(require(game.GetDirectory(true).."."..GAME.Splash));
		end
	end
	if not isdbg() then
		StateManager:Push(lovesplash);
		StateManager:Push(shardsplash, true);
	end
	
		-- Load Dev tilesheet
	shard.__DEV_TILESHEET = ResourceManager:NewSpriteSheet("textures/tiles/developmental.png");
	shard.__TEMP = ResourceManager:NewSpriteSheet("textures/tiles/temp.png");

	shard.__DEV_ALPHA_TEXTURE = ResourceManager:NewSprite("textures/tiles/developmental.png", {96, 0, 32, 32, shard.__DEV_TILESHEET:getDimensions()});
	--grass
	shard.__DEV_GRASS_TEXTURE = ResourceManager:NewSprite("textures/tiles/temp.png", {74, 50, 32, 32, shard.__TEMP:getDimensions()});
	shard.__DEV_GRASS_LIGHT = ResourceManager:NewSprite("textures/tiles/developmental.png", {128, 32, 32, 32, shard.__DEV_TILESHEET:getDimensions()});
	shard.__DEV_GRASS_DIRTY = ResourceManager:NewSprite("textures/tiles/developmental.png", {128, 64, 32, 32, shard.__DEV_TILESHEET:getDimensions()});
	--sand
	shard.__DEV_SAND_TEXTURE = ResourceManager:NewSprite("textures/tiles/temp.png", {0, 192, 32, 32, shard.__TEMP:getDimensions()});
	shard.__DEV_SAND_LIGHT = ResourceManager:NewSprite("textures/tiles/developmental.png", {64, 32, 32, 32, shard.__DEV_TILESHEET:getDimensions()});
	--rock
	shard.__DEV_ROCK_TEXTURE = ResourceManager:NewSprite("textures/tiles/developmental.png", {0, 0, 32, 32, shard.__DEV_TILESHEET:getDimensions()});
	shard.__DEV_ROCK_CRACK = ResourceManager:NewSprite("textures/tiles/developmental.png", {0, 32, 32, 32, shard.__DEV_TILESHEET:getDimensions()});
	--water
	shard.__DEV_WATER_TEXTURE = ResourceManager:NewSprite("textures/tiles/temp.png", {0, 0, 32, 32, shard.__TEMP:getDimensions()});
	shard.__DEV_WATER_DARK = ResourceManager:NewSprite("textures/tiles/developmental.png", {32, 32, 32, 32, shard.__DEV_TILESHEET:getDimensions()});
	shard.__DEV_WATER_LIGHT = ResourceManager:NewSprite("textures/tiles/developmental.png", {32, 64, 32, 32, shard.__DEV_TILESHEET:getDimensions()});
	--snow
	shard.__DEV_SNOW_TEXTURE = ResourceManager:NewSprite("textures/tiles/temp.png", {0, 256, 32, 32, shard.__TEMP:getDimensions()});
	shard.__DEV_SNOW_DIRTY = ResourceManager:NewSprite("textures/tiles/developmental.png", {160, 32, 32, 32, shard.__DEV_TILESHEET:getDimensions()});
	shard.__DEV_SNOW_DARK = ResourceManager:NewSprite("textures/tiles/developmental.png", {160, 64, 32, 32, shard.__DEV_TILESHEET:getDimensions()});


	hook.Call("PostInit", arg);
	
	print("Shard Engine "..shard.__VERSION.." created by "..shard.__AUTHOR.." loaded.");
	print("DEBUG: "..tostring(shard.__DEBUG).." APPID: "..shard.__APPID);
	print(APPINFO.Game.." "..APPINFO.Version.." by "..APPINFO.Author.." loaded.");

end

local cap = 0;
local mT = love.timer.getTime
local capTime = 0;
function love.update(dt)

	shard.__FPS = love.timer.getFPS();
	capTime = capTime + 1/60 -- TODO TIE THIS INTO USER SETTINGS
	
	shardui.think(dt);
	hook.Call("Think", dt);
	StateManager:Call("Think", dt);
	PluginManager:Think(dt);
	net.Think(dt)

	cap = mT();
	if( capTime <= cap ) then
		capTime = cap;
		return;
	end
	love.timer.sleep(capTime - cap);

end

function love.focus(f)

	hook.Call("Focus", f);
	StateManager:Call("Focus", f);
	PluginManager:Focus(f);

end

function love.keypressed(k, u)
	shardui.keypressed(k, u);
	if not shardui.override.keypressed then
		hook.Call("KeyPressed", k, u);
		StateManager:Call("KeyPressed", k, u);
		PluginManager:KeyPress(k, u);
	end

end

function love.keyreleased(k, u)

	shardui.keyreleased(k, u);
	if not shardui.override.keyreleased then
		hook.Call("KeyReleased", k, u);
		StateManager:Call("KeyReleased", k, u);
		PluginManager:KeyRelease(k, u);
	end

end

function love.mousepressed(x, y, b)

	shardui.mousepressed(x, y, b);
	if not shardui.override.mousepressed then
		hook.Call("MousePressed", x, y, b);
		StateManager:Call("MousePressed", x, y, b);
		PluginManager:MousePressed(x, y, b);
	end

end

function love.mousereleased(x, y, b)

	shardui.mousereleased(x, y, b);
	if not shardui.override.mousereleased then
		hook.Call("MouseReleased", x, y, b);
		StateManager:Call("MouseReleased", x, y, b);
		PluginManager:MouseReleased(x, y, b);
	end

end

function love.textinput(t)

	shardui.textinput(t);
	if not shardui.override.textinput then
		hook.Call("TextInput", t);
		StateManager:Call("TextInput", t);
		PluginManager:TextInput(t);
	end
end

function love.draw()

	hook.Call("Draw");
	StateManager:Call("Draw");
	PluginManager:Draw();
	shardui.paint();
	-- More Drawing

	-- Start Post Drawing.
	hook.Call("PostDraw");
	StateManager:Call("PostDraw");
	PluginManager:PostDraw();

end

function love.quit()

	hook.Call("Shutdown");
	StateManager:Call("Shutdown");
	PluginManager:Shutdown();
	ResourceManager:Shutdown();

end