--[[
	Shard Engine
	Developed by Averice.
]]--

shard.startTime = os.time();

-- So we don't have to type them completely.
ScrW = love.window.getWidth;
ScrH = love.window.getHeight;

function curTime()
	return os.time() - shard.startTime;
end

function isdbg() return shard.__DEBUG end

function ctype(class)
	return class.istype or type(class);
end

function openSite(t)
	local os = love.system.getOS();
	if( os == "Windows" ) then
		os.execute("start "..t);
	elseif( os == "OS X" ) then
		os.execute("open "..t);
	elseif( os == "Linux" ) then
		os.execute("xdg-open "..t);
	end
end

function clamp(n, min, max)
	if( n < min ) then
		return min;
	end
	return n > max and max or n;
end
 
function printTable(tbl, t, nt)
	if( not nt ) then
		print("Table:");
	end
	local Tabs = t or 1;
	local tbs = "\t";
	if( Tabs > 1 ) then
		for i = 1, Tabs do
			tbs = tbs .. "\t";
		end
	end
	if(type(tbl) == "table") then
		for k,v in pairs(tbl) do
			if(type(v) == "table") then
				print(tbs..k..":");
				printTable(v, Tabs+1, true);
			else
				print(tbs..k.." = "..tostring(v));
			end
		end
	else
		print(tbs..tostring(tbl))
	end
end

function fileEnumerateRecursive(dir, tree)
	local lfs = love.filesystem;
	local files = lfs.getDirectoryItems(dir);
	local fileTree = tree or {};
	local file = "";
	for k,v in pairs(files) do
		file = dir.."/"..v;
		if( lfs.isFile(file) ) then
			table.insert(fileTree, file);
		elseif( lfs.isDirectory(file) ) then
			fileTree = fileEnumerateRecursive(file, fileTree);
		end
	end
	return fileTree;
end