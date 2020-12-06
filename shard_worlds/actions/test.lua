--[[
	Shard Engine
	Developed by Averice.
]]--

local ACTION = new "CState"
ACTION.Command = "block_color";
ACTION.EnableMouseDown = true;
ACTION.ToColor = RGB(0, 255, 0, 255);

function ACTION:Action(blk, oldcol, gcol)
	local block = blk and blk or GAME.GPS.BLOCK;
	self.UndoInformation = {block, block.GridColor, self.ToColor };
	block.GridColor = gcol and gcol or self.ToColor;
end

function ACTION:UndoFunction(...)
	local Args = {...};
	Args[1].GridColor = Args[2];
end


return ACTION
