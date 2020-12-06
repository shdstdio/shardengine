--[[
	Shard Engine
	Developed by Averice.
]]--

action = {}
action.List = {}
action.RedoList = {}
action.UndoList = {}
action.LastActionName = "no_action";
action.LastActionBlock = {};
action.LastActionTime = 0;

function action.Register(tbl)
	if( tbl.Command ) then
		action.List[tbl.Command] = tbl;
	end
end

function action.Load(file)
	local succ, err = pcall(game.Require, "actions."..file);
	if( succ ) then
		action.Register(err);
		return;
	end
	print("Error action.Load["..file.."]: "..err);
end

function action.Call(comm, ...)
	if( action.List[comm] ) then
		if not( comm == action.LastActionName and GAME.GPS.BLOCK == action.LastActionBlock and action.LastActionTime > love.timer.getTime() and debug.getinfo(2, "f").func ~= action.Redo ) then
			if( action.List[comm] ) then
				GAME.SaveStatus = false;
				local succ, err = pcall(action.List[comm].Action, action.List[comm], ...);
				if not (succ) then
					print("Error action.Call["..comm.."]: "..err);
					return;
				end

				local newUndo = {
					command = comm,
					args = action.List[comm].UndoInformation;
				}
				table.insert(action.UndoList, newUndo);
				action.LastActionName, action.LastActionBlock, action.LastActionTime = comm, GAME.GPS.BLOCK, love.timer.getTime()+0.5;
				return err;
			end
		end
	end
end

function action.Redo()
	local top = #action.RedoList;
	if( top > 0 ) then
		action.Call(action.RedoList[top].command, unpack(action.RedoList[top].args));
		table.remove(action.RedoList, top);
	end
end

function action.Undo()
	local top = #action.UndoList;
	if( top > 0 ) then
		top = action.UndoList[top];
		action.List[top.command]:UndoFunction(unpack(top.args));
		table.insert(action.RedoList, table.remove(action.UndoList, #action.UndoList));
	end
end
keycommand.NewShortcut("Undo", "Undo your last action", false, action.Undo, "lctrl", "z");
keycommand.NewShortcut("Redo", "Redo the last action you undid", false, action.Redo, "lctrl", "y");