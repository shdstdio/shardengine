--[[
	Shard Engine
	Developed by Averice.
]]--

local sock = require "socket";
net = {}
net.Handshake = "lovely";
net.Usermessages = {}
net.OnDisconnect = function() end;
net.OnConnect = function() end;
net.OnConnectFail = function() end;

function net.UsermessageHook(name, func)
	net.Usermessages[name] = func;
end

function net.HandleUsermessage(data)
	local decoded = json.decode(data);
	if( net.Usermessages[decoded.Umsg] ) then
		local succ, err = pcall( net.Usermessages[decoded.Umsg], decoded.Data );
		if( not succ ) then
			print("Usermessage Error ["..decoded.Umsg.."]: ".. err);
			return false;
		end
		return true;
	end
	return false;
end

function net.SendUsermessage(name, data)
	local build = {}
	build.Umsg = name;
	build.Data = data;
	if( net.Socket ) then
		local succ, err = net.Socket:send("__umsg"..json.encode(build).."\n");
		if( not succ ) then
			print("Usermessage Send Error ["..name.."]: "..err);
			return false;
		end
		return true;
	end
	return false;
end

function net.Connect(host, port, call)
	net.Socket = sock:tcp();
	local succ, err = net.Socket:connect(host, port);
	net.Socket:settimeout(2/1000);
	if( not succ ) then
		print("Network Error: ".. err );
		print("Network failed to connect to: "..host..":"..port);
		net.OnConnectFail(host, port);
		return;
	end
	succ, err = net.Socket:send(net.Handshake.."\n");
	if( not succ ) then
		print("Network Error: ".. err);
	end
	print("Connected to: "..host..":"..port.." awaiting authentication");
	if( call ) then
		call(net.Socket);
	end
	net.OnConnect(host, port);
end

function net.Think(dt)
	if( net.Socket ) then
		local data, status, partial = net.Socket:receive();
		local DataRec = data or partial;
		if( DataRec == net.Handshake ) then
			if( not net.Authenticated ) then
				net.Authenticated = true;
				print("Authentication with server successful");
			else
				net.Disconnect();
				print("Connection with server terminated.");
			end
		end
		if( string.sub(DataRec, 1, 6) == "__umsg" ) then
			net.HandleUsermessage(string.sub(DataRec, 7));
		end
	end
end

function net.Disconnect()
	if( net.Socket ) then
		if( net.Authenticated ) then
			net.Socket:send(net.Handshake);
		end
		net.Authenticated = false;
		net.OnDisconnect();
		net.Socket:close();
		net.Socket = nil;
	end
end





