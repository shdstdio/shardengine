--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

--  File: shardui.lua
--  Author: Averice
--  Purpose: Core functions of sharduiui
--  used to load the library.

-- Global table so our functions don't screw with other projects.
shardui = {
	_version = "0.0.4"
}

-- List of panels that we can create.
shardui.registry = {}

-- List of live panels in their draw orders.
shardui.panels = {}

-- List of skins we have loaded.
shardui.skins = {}

-- Our default skin.
shardui.skin = 'Default';

-- Checks if the mouse has moved and is still active inside a panel.
shardui.panelDown = false;

-- Which dropdownlist is current dropped?
shardui.dropDown = nil;

-- Gets the focused TextEntry
shardui.Focused = nil;

shardui.startTime = os.time();

-- Break out of events if shardui overrides.
shardui.override = {}

-- require our objects,
require "shardui.panel";

-------------------
-- Basic Color function.
-- Color(red, green, blue, alpha[optional]);
-------------------
if not Color then
	function Color(r, g, b, a)
		local alpha = a or 255;
		return { shardui.clamp(r, 0, 255), shardui.clamp(g, 0, 255), shardui.clamp(b, 0, 255), shardui.clamp(alpha, 0, 255) };
	end
end

-- Keeps time in seconds.
if not curTime then
	function curTime()
		return os.time() - shardui.startTime;
	end
end


-------------------
-- Loads the library
-- Called at the end of this file.
-- shardui.init();
-------------------
function shardui.init()
	shardui.loadSkin('Default', 'default');
	shardui.setSkin('Default');
	shardui.getFrameLib('default');
	print("ShardUI Loaded - Version "..shardui._version);
end


-------------------
-- Enumerates through directories
-- CREDIT: love2d wiki.
-------------------
function shardui.enumerate(dir, tree)
	local lfs = love.filesystem;
	local files = lfs.getDirectoryItems(dir);
	local fileTree = tree or {};
	local file = "";
	for k,v in pairs(files) do
		file = dir.."/"..v;
		if( lfs.isFile(file) ) then
			table.insert(fileTree, file);
		elseif( lfs.isDirectory(file) ) then
			fileTree = shardui.enumerate(file, fileTree);
		end
	end
	return fileTree;
end


-------------------
-- Requires all panel types.
-- shardui.getFrameLib('default');
-------------------
function shardui.getFrameLib(name)
	if( love.filesystem.isDirectory("shardui/panels/"..string.lower(name)) ) then
		local panels = shardui.enumerate("shardui/panels/"..name);
		local str, pnl
		for i = 1, #panels do
			if( string.find(panels[i], ".lua") ) then
				str = string.gsub(panels[i], "/", ".");
				pnl = require(string.gsub(str, "%.lua", ""));
				shardui.registerPanel(pnl, pnl.Name, pnl.Base);
			end
		end
	else
		return "Error: "..name.." is not a directory in the 'panels' folder.";
	end
end


-------------------
-- Checks if the panel is in the register to be used.
-- shardui.panelExists('myPanelType');
-------------------
function shardui.panelExists(name)
	return shardui.registry[name] and true or false;
end


-------------------
-- Register a new panel type so you can use them with sharduiUI
-- shardui.registerPanel( NEW_PANEL_TABLE, 'myNewPanel', 'defaultPanelName' );
-------------------
function shardui.registerPanel(tbl, name, base)
	local newPanel = {}
	if( base and shardui.panelExists(base) ) then
		for k,v in pairs(shardui.registry[base]) do
			newPanel[k] = v;
		end
		for k, v in pairs(tbl) do
			newPanel[k] = v;
		end
	else
		newPanel = tbl;
	end
	shardui.registry[name] = newPanel;
end


-------------------
-- Create your panel, panels need to exists in the useable list of panels.
-- shardui.createPanel('Button', parentPanel);
-------------------
function shardui.createPanel(typ, parent)
	if( shardui.panelExists(typ) ) then
		local pnl = newPanel();
		for k,v in pairs(shardui.registry[typ]) do
			pnl[k] = v;
		end
		pnl:Init();
		if( parent ) then
			pnl:SetParent(parent)
			pnl:SetVisible(parent:IsVisible());
		end
		if( not parent ) then
			table.insert(shardui.panels, pnl);
		end
		pnl:PostInit();
		return pnl;
	end
	return "Error: Panel type '"..typ.."' does not exist.";
end


-------------------
-- Gets all panels currently in the draw table.
-- shardui.getAll();
-------------------
function shardui.getAll()
	return shardui.panels or {};
end


-------------------
-- Removes a panel from the draw list and returns it.
-- shardui.removePanel(pnl);
-------------------
function shardui.removePanel(pnl)
	for i = 1, #shardui.panels do
		if( shardui.panels[i] == pnl ) then
			return table.remove(shardui.panels, i);
		end
	end
end


-------------------
-- Removes a panel from the child list or a panel and returns it.
-- shardui.removeChild(pnl, child);
-------------------
function shardui.removeChild(pnl, child)
	if( pnl and pnl.Children and pnl.Children[1] ) then
		for i = 1, #pnl.Children do
			if( pnl.Children[i] == child ) then
				return table.remove(pnl.Children, i);
			end
		end
	end
end


-------------------
-- Puts a panel last on the draw order so it is the foremost panel.
-- shardui.paintOver(panelToFocus);
-------------------
function shardui.paintOver(pnl)
	local panel = shardui.removePanel(pnl);
	shardui.panels[#shardui.panels+1] = panel;
end


-------------------
-- Checks if the mouse is hovering over a certain panel, only returns parent panel.
-- shardui.isHovering(myPanel)
-------------------
function shardui.isHovering(pnl)
	if not( pnl ) then return end
	local x, y = pnl:GetPos();
	local w, h = pnl:GetSize();
	local mX, mY = love.mouse.getPosition();
	return ( mX > x and mX < x+w ) and ( mY > y and mY < y+h );
end


-------------------
-- Returns a table of all panels underneath the mouse.
-- shardui.getAllHovering()
-------------------
function shardui.getAllHovering()
	local panels = {}
	for i = 1, #shardui.panels do
		if( shardui.isHovering(shardui.panels[i]) and shardui.panels[i]:IsVisible() ) then
			table.insert(panels, shardui.panels[i]);
		end
	end
	return panels;
end



-------------------
-- Checks if the mouse is obstructed by a panel
-- shardui.mouseObstructed()
-------------------
function shardui.mouseObstructed()
	return shardui.getAllHovering()[1] or shardui.panelDown;
end


-------------------
-- Returns the top most panel ( focused panel )
-- shardui.topPanel()
-------------------
function shardui.topPanel()
	local panels = shardui.getAllHovering();
	return panels[#panels];
end


-------------------
-- Returns the top most parent of the selected panel.
-- shardui.getTopParent(myPanel)
-------------------
function shardui.getTopParent(pnl)
	local top = pnl;
	if( top and top.Parent ) then
		top = shardui.getTopParent(top.Parent);
	end
	return top;
end


-------------------
-- Is the mouse hovering over the child or the parent?
-- shardui.hovering(myPanel)
-------------------
function shardui.hovering(pnl)
	if( pnl:GetParent() ) then
		return ( shardui.topPanel() == shardui.getTopParent(pnl) and shardui.isHovering(pnl) and shardui.hovering(pnl:GetParent()) );
	end
	return ( shardui.topPanel() == shardui.getTopParent(pnl) and shardui.isHovering(pnl) );
end


function shardui.isNearestZ(pnl, dbg)
	local nearest = pnl
	if( pnl.Children and pnl.Children[1] ) then
		for i = 1, #pnl.Children do
			if( shardui.isHovering(pnl.Children[i]) ) then
				nearest = shardui.isNearestZ(pnl.Children[i]);
				if( nearest.ShareZ ) then
					nearest = nearest:GetParent();
				end
				break; -- We shouldn't have panels ontop of eachother in the same Z plane, that would be silly
			end
		end
	end
	return nearest;
end


-------------------
-- Is the panel being clicked?
-- shardui.leftClicked(myPanel)
-------------------
function shardui.leftClicked(pnl)
	return shardui.hovering(pnl) and love.mouse.isDown("l");
end


-------------------
-- Is the panel being right clicked?
-- shardui.rightClicked(myPanel)
-------------------
function shardui.rightClicked(pnl)
	return shardui.hovering(pnl) and love.mouse.isDown("r");
end


-------------------
-- Helper function to start a scissor block ( not really needed but looks nice beside scissorEnd.
-- and gives us nested scissors that are easier to handle.
-- shardui.scissorStart(posX, posY, width, height)
-------------------
shardui.activeScissors = {} -- nested scissors.

function shardui.scissorStart(x, y, w, h)
	love.graphics.setScissor(x, y, w, h);
	table.insert(shardui.activeScissors, {x, w, w, h});
end


-------------------
-- Resets the scissor rect to the screen size or the previous un finished scissor.
-- shardui.scissorEnd()
-------------------
function shardui.scissorEnd()
	if( #shardui.activeScissors > 1 ) then
		table.remove(shardui.activeScissors, #shardui.activeScissors);
		love.graphics.setScissor(unpack(table.remove(shardui.activeScissors, #shardui.activeScissors)));
		return;
	end
	table.remove(shardui.activeScissors, 1);
	love.graphics.setScissor(0, 0, love.window.getWidth(), love.window.getHeight());
end


function shardui.getToolTip()
	return shardui.toolTip;
end

function shardui.setToolTip(p)
	shardui.toolTip = {
		panel = p,
		tip = p:GetToolTip() or false,
		font = shardui.getSkinAttribute("Font", "ToolTip"),
		color = shardui.getSkinAttribute("Color", "ToolTip"),
		tcolor = shardui.getSkinAttribute("TextColor", "ToolTip"),
		bcolor = shardui.getSkinAttribute("BorderColor", "ToolTip")
	}
end

function shardui.drawToolTip()
	if( shardui.toolTip and shardui.toolTip.tip ) then
		local tip = shardui.toolTip;
		if( tip.panel:IsVisible() ) then
			local fw, fh = tip.font:getWidth(tip.tip), tip.font:getHeight(tip.tip);
			local px, py = love.mouse.getPosition(); 
			love.graphics.setColor(tip.bcolor)
			love.graphics.rectangle('line', px+9, py-16, fw+6, fh+6);
			love.graphics.setColor(tip.color)
			love.graphics.setFont(tip.font)
			love.graphics.rectangle('fill', px+10, py-15, fw+4, fh+4);
			love.graphics.setColor(tip.tcolor);
			love.graphics.print(tip.tip, px+12, py-12);
		end
	end
end


-------------------
-- Clamps a value between min and max.
-- shardui.clamp(num, min, max)
-------------------
function shardui.clamp(n, m, x)
	local Num = n
	Num = Num < m and m or Num;
	Num = Num > x and x or Num;
	return Num;
end


-------------------
-- Loads a skin file from the skins folder
-- shardui.loadSkin('myNewSkin', 'myskin')
-------------------
function shardui.loadSkin(name, file)
	shardui.skins[name] = require('shardui.skins.'..file);
end


-------------------
-- Checks if the skin exists/loaded
-- shardui.skinExists('myLoadedSkin');
-------------------
function shardui.skinExists(name)
	return shardui.skins[name] and true or false;
end


-------------------
-- Sets the skin the library will use ( Defaults to original on error )
-- shardui.setSkin('mySkin')
-------------------
function shardui.setSkin(skin)
	if( shardui.skinExists(skin) ) then
		shardui.skin = skin;
	end
end


-------------------
-- Gets the desired skin after checking if it exists.
-- shardui.getSkin('mySkin');
-------------------
function shardui.getSkin(skin)
	if( shardui.skinExists(skin) ) then
		return shardui.skins[skin];
	end
	return shardui.skin;
end


-------------------
-- Gets the attribute of a the current skin e.g. 'BorderColor'
-- shardui.getSkinAttribute('TextColor', 'Frame'[ or empty]);
-------------------
function shardui.getSkinAttribute(attribute, tbl)
	if( tbl ) then
		return shardui.getSkin(shardui.skin)[tbl] and shardui.getSkin(shardui.skin)[tbl][attribute] or false;
	else
		return shardui.getSkin(shardui.skin)[attribute] or false;
	end
end


-------------------
-- Handles the thinking all the panels will need to do, updates all panels and handles mousepositions.
-- To be used inside love.update;
-- shardui.think(deltaTime);
-------------------
function shardui.think(dt)
	shardui.override.keydown = false;
	if( shardui.Focused ) then
		shardui.override.keydown = true;
	end
	for i = #shardui.panels, 1, -1 do
		if( shardui.panels[i] and shardui.panels[i]:IsVisible() ) then
			shardui.panels[i]:Think(dt);
			-- __think is a core function and should never be called in your scripts.
			shardui.panels[i]:__think(dt);
		end
	end
end 


-------------------
-- Draws all the panels and their respective children in correct order.
-- To be used inside love.draw;
-- shardui.paint();
-------------------
function shardui.paint()
	for i = 1, #shardui.panels do
		if( shardui.panels[i] and shardui.panels[i]:IsVisible() and not shardui.panels[i]:GetScissor() ) then
			shardui.panels[i]:Paint();
			-- __paint is a core function and should never be called in your scripts.
			shardui.panels[i]:__paint();
		end
	end
	shardui.drawToolTip()
end


-------------------
-- Handles key functions for textboxes
-- To be used inside love.keypressed
-- shardui.keypressed(key, unicode);
-------------------
function shardui.keypressed(k, u)
	shardui.override.keypressed = false;
	if( shardui.Focused ) then
		if( k == "backspace" ) then
			local tx = shardui.Focused.Text;
			local cs = shardui.Focused.CarratSplice;
			if not( string.sub(tx, 0, (#tx-cs)) == "" ) then
				shardui.Focused.Text = string.sub(tx, 0, (#tx - cs) - 1) .. string.sub(tx, (#tx - cs) + 1, #tx); -- Hacky hacky hacky ho.
			end
		elseif( k == "return" ) then
			if( not u and not shardui.Focused.Multiline ) then
				shardui.Focused:OnEnter();
			end
		elseif( k == "left" ) then
			shardui.Focused.CarratSplice = shardui.clamp(shardui.Focused.CarratSplice + 1, 0, #shardui.Focused.Text);
		elseif( k == "right" ) then
			shardui.Focused.CarratSplice = shardui.clamp(shardui.Focused.CarratSplice - 1, 0, #shardui.Focused.Text);
		end
		shardui.override.keypressed = true;
		return;
	end
end


function shardui.textinput(t)
	shardui.override.textinput = false
	if( shardui.Focused ) then
		local tx = shardui.Focused.Text;
		local cs = shardui.Focused.CarratSplice
		if( shardui.Focused.NumberOnly and not tonumber(t) ) then
			return;
		end
		shardui.Focused.Text = string.sub(tx, 0, #tx - cs) .. t .. string.sub(tx, #tx+1 - cs, #tx+1); -- more hacks, fuck.
		shardui.override.textinput = true;
		return;
	end
end


-------------------
-- As Above
-- To be used inside love.keyreleased
-- shardui.keyreleased(key, unicode);
-------------------
function shardui.keyreleased(k, u) 
	shardui.override.keyreleased = false;
end


-------------------
-- Handles mouse events for the library and panels.
-- To be used in love.mousepressed
-- shardui.mousepressed(posX, posY, button);
-------------------
shardui.scrollEntered = false;
function shardui.mousepressed(x, y, b)
	shardui.override.mousepressed = false;
	shardui.Focused = nil; -- So we can click shit.
	if( shardui.mouseObstructed() ) then
		shardui.override.mousepressed = true;
	end
	if( shardui.scrollEntered and (b == "wd" or b == "wu") and shardui.scrollEntered.Parts.Grip ) then
		local btnG = shardui.scrollEntered.Parts.Grip;
		if( b == "wd" ) then
			btnG:SetPos(0, shardui.clamp(btnG.RealPos.y + shardui.scrollEntered:ScrollMove(), shardui.scrollEntered.ScrollPos, shardui.scrollEntered.ScrollPos + shardui.scrollEntered:TrackDistance()));
			shardui.scrollEntered:Scroll();
		elseif( b == "wu" ) then
			btnG:SetPos(0, shardui.clamp(btnG.RealPos.y - shardui.scrollEntered:ScrollMove(), shardui.scrollEntered.ScrollPos, shardui.scrollEntered.ScrollPos + shardui.scrollEntered:TrackDistance()));
			shardui.scrollEntered:Scroll();
		end
		return;
	end
end


-------------------
-- As Above
-- To be used in love.mousereleased
-- shardui.mousereleased(posX, posY, button);
-------------------
function shardui.mousereleased(x, y, b)
	shardui.override.mousereleased = false;
	if( shardui.mouseObstructed() ) then
		shardui.override.mousereleased = true;
	end
end


-- Let's initialise it now.
shardui.init();
