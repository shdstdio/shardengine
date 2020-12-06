--[[
	Shard Engine
	Developed by Averice.
]]--

local ACTION = new "CState"
ACTION.Command = "select_tool";
ACTION.EnableMouseDown = true;

function ACTION:Action()
	-- No action for selecting.
end

function ACTION:UndoFunction()
	-- No action for selecting.
end

local active_cam, active_terrain
function ACTION:Think()
	active_terrain = terrain.Canvas[terrain.Active[#terrain.Active].short];
	active_cam = active_terrain.ActiveCamera;
	if( self.Clicked ) then
		GAME.Selection.EndPos = { GAME.GPS.MOUSEPOS.x, GAME.GPS.MOUSEPOS.y };
		if( GAME.Selection.StartPos and GAME.Selection.EndPos ) then
			local x, y, xx, yy = getbestposition(GAME.Selection.StartPos[1],
												GAME.Selection.StartPos[2],
												GAME.Selection.EndPos[1], 
												GAME.Selection.EndPos[2]);
			GAME.Selection.Quad = {
				math.floor(x/active_terrain.BlockSize) * active_terrain.BlockSize,
				math.floor(y/active_terrain.BlockSize) * active_terrain.BlockSize,
				math.ceil(xx/active_terrain.BlockSize) * active_terrain.BlockSize,
				math.ceil(yy/active_terrain.BlockSize) * active_terrain.BlockSize
			}
		end
	end
	if( GAME.Selection ) then
		GAME.Selection.ActiveCamera = active_cam;
	end
end

-- in the main mousepressed check if the tool is useable for the selection if not then clear the selection.
function ACTION:MousePressed(x, y, b)
	if( b == "l" ) then
		if( self.Clicked ) then
			GAME.Selection = nil;
			self.Clicked = false;
		end
		self.Clicked = true;
		GAME.Selection = {
			StartPos = { GAME.GPS.MOUSEPOS.x, GAME.GPS.MOUSEPOS.y },
		}
	end
end

function ACTION:MouseReleased(x, y, b)
	if( b == "l" ) then
	end
	if( b == "r" ) then
		GAME.Selection = nil;
		self.Clicked = false;
	end
	self.Clicked = false;
end


function ACTION:Draw()
end


return ACTION
