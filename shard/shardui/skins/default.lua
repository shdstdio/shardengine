--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

-- This is the default skin.

local SKIN = {}

SKIN.Icons = {}
SKIN.Icons.Abort = love.graphics.newImage("shardui/panels/default/textures/Abort.png");
SKIN.Icons.Ac = love.graphics.newImage("shardui/panels/default/textures/AC.png");
SKIN.Icons.Apple = love.graphics.newImage("shardui/panels/default/textures/Apple.png");
SKIN.Icons.Add = love.graphics.newImage("shardui/panels/default/textures/Add.png");

-- GENERAL
SKIN.Color = Color(33, 33, 33, 255); -- Main color of a frame.
SKIN.BorderColor = Color(0, 0, 0, 255); -- Frame border color.
SKIN.TextColor = Color(77, 77, 77, 200); -- The text color used in any frames that have text e.g Buttons.
SKIN.Font = love.graphics.getFont();

-- MAIN FRAME
SKIN.Frame = {}
SKIN.Frame.Color = SKIN.Color;
SKIN.Frame.BorderColor = SKIN.BorderColor;

-- TOOLTIP
SKIN.ToolTip = {}
SKIN.ToolTip.Color = Color(36, 36, 36, 255);
SKIN.ToolTip.BorderColor = Color(0, 0, 0, 255);
SKIN.ToolTip.TextColor = Color(180,180,180,200);
SKIN.ToolTip.Font = SKIN.Font;

-- TITLE BAR
SKIN.Title = {}
SKIN.Title.Color = SKIN.Color;
SKIN.Title.UseGradient = true;
SKIN.Title.GradientImage = love.graphics.newImage("shardui/panels/default/textures/gradient-bar.png");
SKIN.Title.GradientImageColor = Color(150,150,150,255);
SKIN.Title.LineColor = Color(156,25,25,255);

-- SLIDER
SKIN.Slider = {}
SKIN.Slider.MainColor = Color(43,43,43,255);
SKIN.Slider.BorderColor = Color(20, 20, 20, 255);
SKIN.Slider.TextColor = Color(180,180,180,200);
SKIN.Slider.Font = love.graphics.newFont("fonts/DroidSansMono.ttf", 10);

-- CHECKBOX
SKIN.CheckBox = {}
SKIN.CheckBox.MainColor = Color(180, 180, 180, 255);
SKIN.CheckBox.BorderColor = Color(20, 20, 20, 255 );
SKIN.CheckBox.TextColor = Color(33, 33, 33, 255);
SKIN.CheckBox.Font = love.graphics.newFont("fonts/DroidSansMono.ttf", 10);

-- TEXT BUTTON
SKIN.TextButton = {}
SKIN.TextButton.Font = love.graphics.getFont()
SKIN.TextButton.TextColor = Color(180,180,180,200);
SKIN.TextButton.TextColorHovered = Color(255,255,255,200);
SKIN.TextButton.Color = Color(43, 43, 43, 255);
SKIN.TextButton.BorderColor = Color(0,0,0,0);
SKIN.TextButton.IfButtonFont = love.graphics.newFont("fonts/LiberationMono-Bold.ttf", 14);

-- TAB HOLDER
SKIN.Tab = {}
SKIN.Tab.Color = SKIN.TextButton.BorderColor;
SKIN.Tab.BorderColor = SKIN.TextButton.Color;

-- SCROLL FRAME
SKIN.ScrollFrame = {}
SKIN.ScrollFrame.Color = SKIN.Color;
SKIN.ScrollFrame.BorderColor = Color(40,40,40,255);
SKIN.ScrollFrame.ScrollButtonColor = SKIN.Color;
SKIN.ScrollFrame.ScrollButtonBorderColor = SKIN.BorderColor;
SKIN.ScrollFrame.ScrollBarColor = Color( 40, 40, 40, 255 );

-- TEXT ENTRY
SKIN.TextEntry = {}
SKIN.TextEntry.Color = Color( 40, 40, 40, 255 );
SKIN.TextEntry.BorderColor = Color(33, 33, 33, 255);
SKIN.TextEntry.TextColor = Color(180,180,180,200);
SKIN.TextEntry.Font = love.graphics.newFont("fonts/DroidSansMono.ttf", 14);

-- LABEL
SKIN.Label = {}
SKIN.Label.Color = Color(180,180,180,200);
SKIN.Label.Font = love.graphics.newFont("fonts/DroidSansMono.ttf", 12);

-- DROPLIST
SKIN.DropList = {}
SKIN.DropList.MainColor = SKIN.Color;
SKIN.DropList.BorderColor = Color(20, 20, 20, 255);
SKIN.DropList.TextColor = Color(180,180,180,200);
SKIN.DropList.Font = SKIN.CheckBox.Font; 

return SKIN;


