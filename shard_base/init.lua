--[[
	Shard Engine
	Developed by Averice.
]]--

GAME = new "CState";

GAME.Splash = nil; -- Does your game have a splash screen? if yes, where "GAME.Splash = 'splashfolder.splashscreen';"
GAME.Menu = nil; -- Your menu state.
GAME.TextureDirectory = nil; -- Directory of your games textures.
GAME.FontDirectory = nil; -- Directory of your games fonts.
GAME.PluginsUsed = {
	"test"
}

function GAME:Init()
end

function GAME:Think(dt)
end

function GAME:Draw()
end

function GAME:HudDraw()
end

function GAME:PostDraw()
end

function GAME:KeyPressed()
end

function GAME:KeyReleased()
end

function GAME:Focus()
end

function GAME:TextInput()
end

function GAME:Shutdown()
end

function GAME:MousePressed()
end

function GAME:MouseReleased()
end

