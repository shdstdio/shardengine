--[[
	Shard Engine
	Developed by Averice.
]]--

GAME = new "CState";

GAME.Splash = nil; -- Does your game have a splash screen? if yes, where "GAME.Splash = 'splashfolder.splashscreen';"
GAME.Menu = nil; -- Your menu state.
GAME.TextureDirectory = "textures"; -- Directory of your games textures.
GAME.FontDirectory = nil; -- Directory of your games fonts.
GAME.PluginsUsed = {
}

GAME.Settings = {
	showtooltip = true
}
GAME.SaveStatus = true;
GAME.ShowDevGrid = true;
GAME.SnapToGrid = true;
GAME.ActionManager = new "CStateManager";
GAME.GPS = {
	MOUSEPOS = Vector(0, 0),
	BLOCK = {}
}

GAME_BASE_LAYER = 1;
GAME_GROUND_LAYER = 2;
GAME_GROUND_DETAIL = 3;
GAME_ENTITY_LAYER = 4;
GAME_FORE_DETAIL = 5;

GAME.Layer = GAME_BASE_LAYER;

game.Require "actions";
game.Require "console_commands";

game.Require "ui/init";

action.Load "select_tool";
action.Load "texture_tool";


--[[
	if it comes down to it we might have to save give the blocks a real position.
	we might also need to reverse the blocks in negative chunks.
	no idea if this will affect drawing yet..

	WE HAVE SELECTION
--]]

function GAME:Init()
	self.ActionManager:Init();
	self.ui.CeilingPanel();
	self.ui.LeftWall();
	self.ui.ReftWall();
	self.ui.FloorPanel();
end

function GAME:Think(dt)
	terrain.Think(dt); -- terrain system, disabled by default, this turns it on.
	keycommand.Think(dt); -- keyboard shortcut module, disabled by default, doing this turns it on. shardui can override this, don't stress.
	if( #terrain.Active >= 1 ) then
		GAME.GPS.MOUSEPOS = terrain.RealMousePos(terrain.Active[#terrain.Active].short);
		GAME.GPS.BLOCK = shard.__HOVERED_BLOCK
		GAME.CURRENT_ACTION = self.ActionManager:GetActive() or nil;
		self.ActionManager:Call("Think",dt);
		if not( shardui.override.mousepressed ) then
			if( love.mouse.isDown("l") and GAME.CURRENT_ACTION and GAME.CURRENT_ACTION.EnableMouseDown ) then
				action.Call(GAME.CURRENT_ACTION.Command);
			end
		end
	end
end

function GAME:Draw()
	terrain.Draw();
	if(#terrain.Active > 0) then
		self.ActionManager:Call("Draw");
		if( GAME.Selection and GAME.Selection.Quad ) then
			love.graphics.setColor(25, 25, 176, 255);
			love.graphics.rectangle("line", GAME.Selection.Quad[1] - GAME.Selection.ActiveCamera.Position.x,
											GAME.Selection.Quad[2] - GAME.Selection.ActiveCamera.Position.y,
											GAME.Selection.Quad[3] - GAME.Selection.Quad[1],
											GAME.Selection.Quad[4] - GAME.Selection.Quad[2]);
			love.graphics.setColor(25, 25, 120, 170);
			love.graphics.rectangle("fill", GAME.Selection.Quad[1] - GAME.Selection.ActiveCamera.Position.x,
											GAME.Selection.Quad[2] - GAME.Selection.ActiveCamera.Position.y,
											GAME.Selection.Quad[3] - GAME.Selection.Quad[1],
											GAME.Selection.Quad[4] - GAME.Selection.Quad[2]);
		end
		if( shard.__HOVERED_DETAILS ) then
			love.graphics.setColor(190,25,25,170)
			love.graphics.rectangle("line", unpack(shard.__HOVERED_DETAILS));
		end
	end
end

function GAME:KeyPressed(k, u)
	self.ActionManager:Call("KeyPressed", k, u);
end

function GAME:KeyReleased(k, u)
	self.ActionManager:Call("KeyReleased", k, u);
end

function GAME:TextInput(t)
	self.ActionManager:Call("TextInput", t);
end

function GAME:Shutdown()
end

function GAME:MousePressed(x, y, b)
	if( GAME.CURRENT_ACTION ) then
		if( GAME.CURRENT_ACTION.Command ~= "selection_tool" or GAME.CURRENT_ACTION.Command ~= "texture_tool" ) then
			GAME.Selection = nil;
		end
	end
	if( GAME.CURRENT_ACTION and not GAME.CURRENT_ACTION.EnableMouseDown ) then 
		action.Call(GAME.CURRENT_ACTION.Command);
	end
	self.ActionManager:Call("MousePressed", x, y, b);
end

function GAME:MouseReleased(x, y, b)
	self.ActionManager:Call("MouseReleased", x, y, b);
end

function getbestposition(x1, y1, x2, y2)
	local x = x1 > x2 and x2 or x1;
	local xx = x == x1 and x2 or x1
	local y = y1 > y2 and y2 or y1;
	local yy = y == y1 and y2 or y1;
	return x, y, xx, yy;
end

