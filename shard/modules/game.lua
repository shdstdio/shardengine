--[[
	Shard Engine
	Developed by Averice.
]]--

game = {}
game.Frames = 60;
game.Timescale = 1;
game.Vars = {}


function game.GetFrameRate()
	return game.Frames;
end

function game.SetFrameRate(n)
	game.Frames = tonumber(n);
end

function game.GetTimeScale()
	return game.Timescale;
end

function game.SetTimeScale(n)
	game.Timescale = tonumber(n);
end

function game.SetVar(var, val)
	game.Vars[var] = val;
end

function game.GetVar(var, nilfix)
	return game.Vars[var] or nilfix;
end

function game.SetTitle(ttl)
	love.window.setTitle(ttl);
end

function game.GetDirectory(safe)
	return shard.__APPID
end

function game.Require(file)
	return require( game.GetDirectory(true).."."..file );
end

GAME_PREVIOUS_FILE_SELECTED = false;
local function osf(sel)
	GAME_PREVIOUS_FILE_SELECTED = sel;
end

function game.FileViewer(dir, x, y, title, on_select_func)
	local dir = dir or "textures";
	local list = fileEnumerateRecursive(dir)
	local selected
	local fileImage = ResourceManager:NewImage("textures/ui/folder.gif");
	if( game.FileFrame ) then
		shardui.removePanel(game.FileFrame);
	end

	game.FileFrame = shardui.createPanel("ShardFrame")
	game.FileFrame:SetPos(x or 200, y or 200);
	game.FileFrame:SetSize(500, 254);
	game.FileFrame:SetTitle(title or "Directory: "..dir);

	game.FileFrame.Panel = shardui.createPanel("ShardScrollPanel", game.FileFrame);
	game.FileFrame.Panel:SetPos(2, 22);
	game.FileFrame.Panel:SetSize(496, 204);
	game.FileFrame.Panel:EnableVerticalScrollBar(true);

	game.FileFrame.FileList = {}

	local on_c = on_select_func or function(t)
	end

	for i = 1, #list do
		game.FileFrame.FileList[i] = shardui.createPanel("ShardPanel", game.FileFrame.Panel)
		game.FileFrame.FileList[i]:SetSize(474, 14);
		game.FileFrame.FileList[i]:EnableBorder(false);

		game.FileFrame.FileList[i].FolderIcon = shardui.createPanel("ShardButton", game.FileFrame.FileList[i]);
		game.FileFrame.FileList[i].FolderIcon:SetPos(5, 2);
		game.FileFrame.FileList[i].FolderIcon:SetSize(10, 10);
		game.FileFrame.FileList[i].FolderIcon:SetImage(fileImage);
		game.FileFrame.FileList[i].FolderIcon.Colors.BorderColor = Color(0, 0, 0, 0);
		game.FileFrame.FileList[i].FolderIcon.Colors.Color = Color(0, 0, 0, 0);
		game.FileFrame.FileList[i].FolderIcon.OnMouseEnter = function()
			game.FileFrame.FileList[i].Text:OnMouseEnter();
		end
		game.FileFrame.FileList[i].FolderIcon.OnMouseReleased = function()
			game.FileFrame.FileList[i].Text:OnMouseReleased();
		end

		game.FileFrame.FileList[i].Text = shardui.createPanel("ShardTextButton", game.FileFrame.FileList[i])
		game.FileFrame.FileList[i].Text:SetPos(17, 0)
		game.FileFrame.FileList[i].Text:SetSize(474, 14);
		game.FileFrame.FileList[i].Text:SetFont(shard.DefaultFont);
		game.FileFrame.FileList[i].Text:SetText(list[i]);
		game.FileFrame.FileList[i].Text:SetAlign(2);
		game.FileFrame.FileList[i].Text.OnMouseReleased = function(self)
			game.FileFrame.Entry:SetValue(list[i]);
		end
		game.FileFrame.Panel:AddItem(game.FileFrame.FileList[i]);
	end

	game.FileFrame.Entry = shardui.createPanel("ShardTextEntry", game.FileFrame);
	game.FileFrame.Entry:SetPos(2, 230);
	game.FileFrame.Entry:SetSize(456, 20);

	game.FileFrame.Open = shardui.createPanel("ShardButton", game.FileFrame);
	game.FileFrame.Open:SetPos(458, 230);
	game.FileFrame.Open:SetSize(40, 20);
	game.FileFrame.Open.Font = shardui.getSkinAttribute("Font", "CheckBox");
	game.FileFrame.Open:SetText("Open");
	game.FileFrame.Open.OnMouseReleased = function()
		on_c(game.FileFrame.Entry.Text);
		shardui.removePanel(game.FileFrame);
	end

	game.FileFrame:SetVisible(true);

end

local function new_paint(s, image, sx, sy)
	love.graphics.setColor(s.Colors.BorderColor);
	love.graphics.rectangle("line", s.Pos.x-1, s.Pos.y-1, s.Size.w+2, s.Size.h+2);
	love.graphics.setColor(255,255,255,255);
	love.graphics.draw(image, s.Pos.x, s.Pos.y, 0, sx, sy);
end

function game.ImageViewer(image, x, y, sx, sy, title) -- mainly made this just for the heightmap viewer.
	local img = image
	if( type(image) == "string" or type(image) == "userdata" ) then
		img = ResourceManager:NewImage(image);
	end
	local sx, sy = sx, sy
	local imgx, imgy = sx / image:getWidth(), sy / image:getHeight();

	game.ImageFrame = shardui.createPanel("ShardFrame")
	game.ImageFrame:SetPos(x or ScrW()/2 - sx, y or ScrH() / 2 - sy);
	game.ImageFrame:SetSize(sx+4, sy+24);
	game.ImageFrame:SetTitle(title or "Image");

	game.ImageFrame.Image = shardui.createPanel("ShardPanel", game.ImageFrame);
	game.ImageFrame.Image:SetPos(2, 22);
	game.ImageFrame.Image:SetSize(sx, sy);
	game.ImageFrame.Image.Paint = function(self)
		new_paint(self, img, imgx, imgy);
	end

	game.ImageFrame:SetVisible(true);
end
