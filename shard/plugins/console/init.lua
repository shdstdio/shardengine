--[[
	Shard Engine
	Developed by Averice.
]]--

local PLUGIN = {}
PLUGIN.Version = "0.01";
PLUGIN.Name = "Console";
PLUGIN.Id = "shard_console";
PLUGIN.Author = "Averice";
PLUGIN.Description = 	[[Enables a console (~), commands can also be used in the console.]];

function PLUGIN:Init()

	shard.ConsoleLines = {}
	shard.Console = {}

	shard.Console.Frame = shardui.createPanel("ShardFrame")
	shard.Console.Frame:SetSize(500, 500);
	shard.Console.Frame:SetPos(ScrW() / 2 - 250, ScrH() / 2 - 250);
	shard.Console.Frame:SetTitle("Console");
	shard.Console.Frame:AddSystemButton("+", "Plugins", function() end);
	shard.Console.Frame:AddSystemButton("∞", "Commands", CreateCommandFrame, "poo");

	shard.Console.Scroll = shardui.createPanel("ShardScrollPanel", shard.Console.Frame);
	shard.Console.Scroll:SetPos(2, 22);
	shard.Console.Scroll:SetSize(496, 453);
	shard.Console.Scroll:EnableVerticalScrollBar(true)

	shard.Console.TextEntry = shardui.createPanel("ShardTextEntry", shard.Console.Frame);
	shard.Console.TextEntry:SetPos(2, 477);
	shard.Console.TextEntry:SetSize(464, 20);
	shard.Console.TextEntry.OnEnter = function(self)
		local Args = string.Explode(" ", self:GetValue())
		command.Run(tostring(table.remove(Args, 1)), unpack(Args));
		self:Clear();
	end

	shard.Console.InputButton = shardui.createPanel("ShardButton", shard.Console.Frame);
	shard.Console.InputButton:SetPos(468, 477);
	shard.Console.InputButton:SetSize(30, 20);
	shard.Console.InputButton.Font = shardui.getSkinAttribute("Font", "CheckBox");
	shard.Console.InputButton:SetText("Run");
	shard.Console.InputButton.OnMouseReleased = function()
		shard.Console.TextEntry:OnEnter();
	end

	shard.Console.Frame:SetVisible(false);

end

function CreateCommandFrame()
	shard.Console = shard.Console or {};
	if( shard.Console and shard.Console.CFrame ) then
		shardui.removePanel(shard.Console.CFrame);
		shard.Console.CFrame = nil;
	end
	shard.Console.CFrame = shardui.createPanel("ShardFrame");
	shard.Console.CFrame:SetSize(400, 250)
	shard.Console.CFrame:SetPos(ScrW()/2 - 200, ScrH()/2 - 125);
	shard.Console.CFrame:SetTitle("Console Commands");

	shard.Console.CScroll = shardui.createPanel("ShardScrollPanel", shard.Console.CFrame);
	shard.Console.CScroll:SetPos(2, 22);
	shard.Console.CScroll:SetSize(126, 226);
	shard.Console.CScroll:EnableVerticalScrollBar(true);

	shard.Console.CPanel = shardui.createPanel("ShardPanel", shard.Console.CFrame);
	shard.Console.CPanel:SetPos(132, 22);
	shard.Console.CPanel:SetSize(266, 226);
	shard.Console.CPanel:SetBorderColor(Color(40,40,40,255));

	shard.Console.CLabel = shardui.createPanel("ShardLabel", shard.Console.CPanel);
	shard.Console.CLabel:SetPos(2, 2);
	shard.Console.CLabel:SetSize(262, 222);
	shard.Console.CLabel:SetText(command.GetAll()["create_map"].Desc)
	shard.Console.CLabel:SetMaxWidth(262);

	for k,v in pairs(command.GetAll()) do
		local newLabel = shardui.createPanel("ShardTextButton", shard.Console.CScroll);
		newLabel:SetSize(170, 20);
		newLabel:SetAlign(2);
		newLabel:SetText(k);
		shard.Console.CScroll:AddItem(newLabel);
		newLabel.OnMouseReleased = function()
			shard.Console.CLabel:SetText(command.GetAll()[k].Desc);
		end
	end

	shard.Console.CFrame:SetVisible(true);
end

function PLUGIN:KeyPress(key, r)
	if( shardui.Focused == nil or shardui.Focused == shard.Console.TextEntry ) then
		if( key == "`" ) then
			shard.Console.Frame:SetVisible( not shard.Console.Frame:IsVisible() );
			if( shard.Console.Frame:IsVisible() ) then
				shardui.paintOver(shard.Console.Frame)
				timer.Simple("0.3", function() shardui.Focused = shard.Console.TextEntry end) -- Hacky, but removes the '`' from console text box.
			else
				shardui.Focused = nil;
			end
		end
	end
end

function shard.ConsoleLabel(text, color)
	if( shard.Console and shard.Console.Frame ) then
		local newLabel = shardui.createPanel("ShardLabel", shard.Console.Scroll);
		newLabel:SetColor(color or Color(180,180,180,200));
		newLabel:SetSize(470, 14);
		newLabel:SetMaxWidth(470);
		newLabel:SetText(text);
		shard.Console.Scroll:AddItem(newLabel);
		shard.Console.Scroll:ScrollToBottom();
	end
end 

oldPrint = print
function print(...)
	if( shard.Console and shard.Console.Frame ) then
		local col = Color(180, 180, 180, 200);
		local pass = {...};
		local str = "";
		for i = 1, #pass do
			str = str..tostring(pass[i]) or type(pass[i]);
			if( #pass > i ) then
				str = str.. "    ";
			end
		end
		shard.ConsoleLabel(str, col);
	end
	oldPrint(...);
end

command.Create("lua", function(...)
	local pass = {...}
	local toLua = table.concat(pass, " ");
	print("lua> "..toLua);
	local succ, err = pcall(loadstring(toLua));
	if( not succ ) then
		print(err);
	end
end, "Interprets everything following 'lua' as lua code. [lua print('Hello World!')]")


return PLUGIN;