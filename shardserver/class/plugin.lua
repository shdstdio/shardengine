--[[
	Shard Engine
	Developed by Averice.
]]--

class "CPluginManager";

function CPluginManager:LoadPlugins()
	self.Plugins = self.Plugins or {};
	local PluginList = fileEnumerateRecursive("plugins");
	local filen, succ, pgin;
	local dList
	for i = 1, #PluginList do
		if( string.match(PluginList[i], "init.lua") ) then
			filen = string.gsub(PluginList[i], "/", ".");
			succ, pgin = pcall( require, string.gsub(filen, "%.lua", "") );
			if( not succ ) then
				print("Plugin Error: "..pgin);
				print("Failed to load plugin: "..PluginList[i]);
			end
			if( type(pgin) == "table" ) then
				self.Plugins[pgin.Id] = pgin;
			end
		end
	end
	local su, er;
	for k, v in pairs(self.Plugins) do
		if( self.Plugins[k].Init ) then
			su, er = pcall(self.Plugins[k].Init, self.Plugins[k]);
			if( not su ) then
				print("Plugin Error ["..v.Name.."]: "..er);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end
end

function CPluginManager:GetAll()
	return self.Plugins;
end

function CPluginManager:GetByName(nme)
	return self.Plugins[nme] or {};
end

function CPluginManager:Think(dt)
	local succ, err
	for k,v in pairs(self.Plugins) do
		if( v.Think ) then
			succ, err = pcall(v.Think, v, dt);
			if( not succ ) then
				print("Plugin Error ["..v.Name.."]: "..err);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end
end

function CPluginManager:Draw()
	local succ, err
	for k,v in pairs(self.Plugins) do
		if( v.Draw ) then
			succ, err = pcall(v.Draw, v);
			if( not succ ) then
				print("Plugin Error ["..v.Name.."]: "..err);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end

end

function CPluginManager:KeyPress(ke, u)
	local succ, err
	for k,v in pairs(self.Plugins) do
		if( v.KeyPress ) then
			succ, err = pcall(v.KeyPress, v, ke, u);
			if( not succ ) then
				print("Plugin Error ["..v.Name.."]: "..err);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end
end

function CPluginManager:KeyRelease(ke, u)
	local succ, err
	for k,v in pairs(self.Plugins) do
		if( v.KeyRelease ) then
			succ, err = pcall(v.KeyRelease, v, ke, u);
			if( not succ ) then
				print("Plugin Error ["..v.Name.."]: "..err);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end
end

function CPluginManager:PostDraw()
	local succ, err
	for k,v in pairs(self.Plugins) do
		if( v.PostDraw ) then
			succ, err = pcall(v.PostDraw, v);
			if( not succ ) then
				print("Plugin Error ["..v.Name.."]: "..err);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end
end

function CPluginManager:Shutdown()
	local succ, err
	for k,v in pairs(self.Plugins) do
		if( v.Shutdown ) then
			succ, err = pcall(v.Shutdown, v);
			if( not succ ) then
				print("Plugin Error ["..v.Name.."]: "..err);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end
end

function CPluginManager:Focus(f)
	local succ, err
	for k,v in pairs(self.Plugins) do
		if( v.Focus ) then
			succ, err = pcall(v.Focus, v, f);
			if( not succ ) then
				print("Plugin Error ["..v.Name.."]: "..err);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end
end

function CPluginManager:MousePressed(x, y, b)
	local succ, err
	for k,v in pairs(self.Plugins) do
		if( v.MousePressed ) then
			succ, err = pcall(v.MousePressed, v, x, y, b);
			if( not succ ) then
				print("Plugin Error ["..v.Name.."]: "..err);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end
end

function CPluginManager:MouseReleased(x, y, b)
	local succ, err
	for k,v in pairs(self.Plugins) do
		if( v.MouseReleased ) then
			succ, err = pcall(v.MouseReleased, v, x, y, b);
			if( not succ ) then
				print("Plugin Error ["..v.Name.."]: "..err);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end
end

function CPluginManager:TextInput(t)
	local succ, err
	for k,v in pairs(self.Plugins) do
		if( v.TextInput ) then
			succ, err = pcall(v.TextInput, v, t);
			if( not succ ) then
				print("Plugin Error ["..v.Name.."]: "..err);
				print("Plugin Removed: "..v.Name);
				self.Plugins[k] = nil;
			end
		end
	end
end