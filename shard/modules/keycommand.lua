--[[
	Shard Engine
	Developed by Averice.
]]--

keycommand = {}

keycommand.Shortcuts = {}
keycommand.MouseButtons = {
	mouse1 = "l",
	mouse2 = "r",
	mouse3 = "m",
	mouse4 = "x1",
	mouse5 = "x2",
	wu = "wu",
	wd = "wd"
}

-- USE FAST CONTINUE FOR MOVEMENT STYLE THINGS.
-- PROBS don't use ctrl/shift/alt for single key shortcut? you can if you want though.
-- This code looks pretty ugly.. 

function keycommand.NewShortcut(name, desc, fast_continue, func, key1, key2)
	local newShortcut = {
		Name = name,
		Desc = desc,
		Func = func,
		FCont = fast_continue
	}
	if( key1 ) then
		keycommand.Shortcuts[key1] = keycommand.Shortcuts[key1] or {};
		if( key2 ) then
			keycommand.Shortcuts[key1][key2] = { __FUNCTION = newShortcut };
		else
			keycommand.Shortcuts[key1]["__FUNCTION"] = newShortcut;
		end
	end
end

function keycommand.Remove(key1, key2)
	if( key1 ) then
		if( key2 and keycommand.Shortcuts[key1] ) then
			keycommand.Shortcuts[key1][key2] = nil;
			return;
		end
		keycommand.Shortcuts[key1]["__FUNCTION"] = nil;
	end
end

local RunCommand = false;
local ComThinkTime = 0; -- stops shit from hitting the fan.
function keycommand.Think(dt)
	if( shardui.override.keydown ) then
		return;
	end
	RunCommand = true;
	for k, v in pairs(keycommand.Shortcuts) do
		if( love.keyboard.isDown(k) or ( love.mouse.isDown(keycommand.MouseButtons[k] or "") and not shardui.override.mousepressed ) ) then
			for i, j in pairs(keycommand.Shortcuts[k]) do
				if not( i == "__FUNCTION" ) then
					if( love.keyboard.isDown(i) or love.mouse.isDown(keycommand.MouseButtons[i] or "") ) then
						RunCommand = false;
						if not( keycommand.Shortcuts[k][i].__FUNCTION.FCont )then
							if( ComThinkTime > love.timer.getTime() ) then
								return;
							end
						end
						ComThinkTime = love.timer.getTime()+0.2;
						keycommand.Shortcuts[k][i].__FUNCTION.Func();
						break;
					end
				end
			end
			if( RunCommand and keycommand.Shortcuts[k].__FUNCTION ) then
				if not( keycommand.Shortcuts[k].__FUNCTION.FCont )then
					if( ComThinkTime > love.timer.getTime() ) then
						return;
					end
				end
				if( keycommand.Shortcuts[k].__FUNCTION ) then
					ComThinkTime = love.timer.getTime()+0.3;
					keycommand.Shortcuts[k].__FUNCTION.Func();
				end
			end
		end
	end
end


