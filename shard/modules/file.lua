--[[
	Shard Engine
	Developed by Averice.
]]--

file = {}

function file.Read(file)
	local files = "";
	for line in io.lines(file) do
		files = files..line;
	end
	return files;
end

function file.ReadToTable(file)
	local files = {}
	for line in io.lines(file) do
		table.insert(files, line);
	end
	return files;
end

function file.Append(file, obj)
	local file = io.open(file, "a+");
	file:write(obj);
	file:close();
end

function file.Exists(file)
	local file = io.open(file);
	if( file ) then
		file:close();
		return true;
	end
	return false;
end

function file.Create(file)
	local file = io.open(file, "w");
	file:close();
end

function file.Write(file, obj)
	local file = io.open(file, "w+");
	file:write(obj);
	file:close();
end

function file.GetWorkDir()
	return love.filesystem.getWorkingDirectory();
end

function file.RunLua(filex)
	local succ, err = pcall(loadstring, file.Read(filex));
	if not(succ) then
		print("Lua Error[ file.RunLua["..filex.."] ]: "..err);
		return false;
	end
	return succ;
end