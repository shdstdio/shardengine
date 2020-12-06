--[[
	Shard Engine
	Developed by Averice.
]]--

shard.startTime = os.time();

-- So we don't have to type them completely.
ScrW = love.window.getWidth;
ScrH = love.window.getHeight;

PowersOfTwo = { 1, 2, 4, 8, 16, 32, 64, 128, 256, 512,
				1024, 2048, 4096, 8192
			};

function curTime()
	return os.time() - shard.startTime;
end

function isdbg() return shard.__DEBUG end

function ctype(class)
	return class.istype and class.istype or type(class);
end

function isEntity(class)
	return class.IsEntity or false;
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

function power_of_two(x)
	while ((( x % 2 ) == 0 ) and x > 1 ) do
		x = x / 2;
	end
	return x == 1;
end

function next_power_of_two(x)
	local dist1, dist2 = 0, 0;
	for i = 1, #PowersOfTwo do
		if( x >= PowersOfTwo[i] and x <= PowersOfTwo[i+1] ) then
			dist1 = math.abs(PowersOfTwo[i] - x);
			dist2 = PowersOfTwo[i+1] - x;
			return dist1 < dist2 and PowersOfTwo[i] or PowersOfTwo[i+1];
		end
	end
end

function table_values_match(t1, t2)
	local Ret = true;
	for i = 1, #t1 do
		if t1[i] ~= t2[i] then
			Ret = false;
		end
	end
	return Ret;
end


-- Maybe move this into the color class?
function greyscale(col)
	local intensity = 0.2989*col[1] + 0.5870*col[2] + 0.1140*col[3];
	return Color(intensity, intensity, intensity, col[4]);
end



function clamp(n, min, max)
	if( n < min ) then
		return min;
	end
	return n > max and max or n;
end
 
function printTable(tbl, t, mt, nt)
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
			if(type(v) == "table" and mt) then
				print(tbs..k..":");
				printTable(v, Tabs+1, true, true);
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