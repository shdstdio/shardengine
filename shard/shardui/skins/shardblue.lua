--[[=========================================================================]]--
--[[	ShardUI: Created by Averice											 ]]--
--[[	ShardUI is a Graphical User Interface library designed to be used	 ]]--
--[[	with the love2d framework.											 ]]--
--[[=========================================================================]]--

-- This is the default skin.

local SKIN = {}

-- GENERAL
SKIN.Color = Color(180, 180, 180, 255); -- Main color of a frame.
SKIN.BorderColor = Color(90, 90, 90, 255); -- Frame border color.
SKIN.TextColor = Color(33, 33, 33, 200); -- The text color used in any frames that have text e.g Buttons.
SKIN.Font = love.graphics.getFont();

-- MAIN FRAME
SKIN.Frame = {}
SKIN.Frame.Color = SKIN.Color;
SKIN.Frame.BorderColor = SKIN.BorderColor;

-- TOOLTIP
SKIN.ToolTip = {}
SKIN.ToolTip.Color = Color(190, 190, 190, 255);
SKIN.ToolTip.BorderColor = Color(90, 90, 90, 255);
SKIN.ToolTip.TextColor = Color(33,33,33,200);
SKIN.ToolTip.Font = SKIN.Font;

-- TITLE BAR
SKIN.Title = {}
SKIN.Title.Color = SKIN.Color;
SKIN.Title.UseGradient = false;
SKIN.Title.GradientImage = love.graphics.newImage("shardui/panels/default/textures/gradient-bar.png");
SKIN.Title.GradientImageColor = Color(150,150,150,255);
SKIN.Title.LineColor = Color(25,25,186,255);

-- TEXT BUTTON
SKIN.TextButton = {}
SKIN.TextButton.Font = love.graphics.getFont()
SKIN.TextButton.TextColor = Color(180,180,180,200);
SKIN.TextButton.TextColorHovered = Color(255,255,255,200);
SKIN.TextButton.Color = Color(36, 36, 36, 255);
SKIN.TextButton.BorderColor = Color(0,0,0,0);
SKIN.TextButton.IfButtonFont = love.graphics.newFont("fonts/LiberationMono-Bold.ttf", 14);

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



return SKIN;


