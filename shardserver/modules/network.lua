--[[
	Shard Engine
	Developed by Averice.
]]--

sock = require "socket";

net = {}
net.Handshake = "lovely";
net.OnConnect = function() end;
net.OnDisconnect = function() end;
net.OnNewClient = function() end;
net.OnConnectFail = function() end;

net.Usermessages = {}
net.Clients = {}

function net.UsermessageHook(name, func)
	net.Usermessages[name] = func;
end

function net.HandleUsermessage(from, data)
	local decoded = json.decode(data);
	if( net.Usermessages[decoded.Umsg] ) then
		local succ, err = pcall(net.Usermessages[decoded.Umsg], from, decoded.Data);
		if( not succ ) then
			print("Usermessage Error["..decoded.Umsg.."]: "..err);
			return false;
		end
		return true;
	end
	return false;
end

function net.SendUsermessage(client, name, data)
	if( not client ) then
		print("Usermessage Error["..name.."]: no receiver specified net.SendUsermessage( client, umsg_name, umsg_content )");
		return false;
	end
	local build = {}
	build.Umsg = name;
	build.Data = data;
	local succ, err = client:send("__umsg"..json.encode(build).."\n");
	if( not succ ) then
		print("Usermessage send error["..name.."]: ".. err);
		return false;
	end
	return true;
end

function net.Connect()
	net.Socket = sock.tcp();
	net.Socket:settimeout(2/1000);
	local succ, err = net.Socket:bind("*", 0);
	net.Socket:listen(32);
	if( not succ ) then
		print("Network Error: "..err);
		net.OnConnectFail();
		return false;
	end
	net.Host, net.Port = net.Socket:getsockname();
	print("Network server online: "..net.Host..":"..net.Port);
	net.OnConnect();
	return true;
end

function net.Think(dt)
	if( net.Socket ) then
		local newClient = {}
		newClient.Client = net.Socket:accept();
		newClient.Authenticated = false;
		newClient.Id = #net.Clients + 1;
		if( newClient.Client ) then
			newClient.Client:settimeout(2/1000);
			table.insert(net.Clients, newClient);
		end
		if( net.Clients[1] ) then
			for i = #net.Clients, 1, -1 do
				local data, err = net.Clients[i].Client:receive();
				if( data ) then
					if( data == net.Handshake ) then
						if( net.Clients[i].Authenticated ) then
							net.Clients[i].Authenticated = false;
							net.Clients[i].Client:close();
							table.remove(net.Clients, i);
						else
							net.Clients[i].Authenticated = true;
							local succ, err = net.Clients[i].Client:send(net.Handshake.."\n");
							print("Client["..i.."] supplied correct handshake, authenticated successfully.");
							if( not succ ) then
								print("Network Error: "..err);
							end
						end
					elseif( string.sub(data, 1, 6) == "__umsg" and net.Clients[i].Authenticated ) then
						net.HandleUsermessage(net.Clients[i].Client, string.sub(data, 7));
					end
				end
			end
		end
	end
end