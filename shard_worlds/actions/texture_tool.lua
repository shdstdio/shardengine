--[[
	Shard Engine
	Developed by Averice.
]]--

local ACTION = new "CState"
ACTION.Command = "texture_tool";
ACTION.EnableMouseDown = true;

function ACTION:Action(blk, layer, oldtext, newtext)

	local block = blk or GAME.GPS.BLOCK;
	local layer = layer or GAME.Layer;
	if( block and block.Layers ) then

		local oldtext = oldtext;
		if( block.Layers[layer] and block.Layers[layer].Texture ) then
			oldtext = oldtext or block.Layers[layer].Texture or 0;
		end
		local newtext = newtext;

		if( GAME.TextureSelection and GAME.TextureSelection.sTexture and GAME.TextureSelection.sQuad and block and not newtext ) then
			newtext = ResourceManager:NewSprite(GAME.TextureSelection.sTexture, {	GAME.TextureSelection.sQuad.x,
																												GAME.TextureSelection.sQuad.y, 
																												GAME.TextureSelection.sQuad.y2 - GAME.TextureSelection.sQuad.y,
																												GAME.TextureSelection.sQuad.x2 - GAME.TextureSelection.sQuad.x,
																												unpack(GAME.TextureSelection.Dimensions) });
			terrain.AddTexture(terrain.Active[#terrain.Active].short, GAME.TextureSelection.sTexture);
		end

		if( layer == GAME_BASE_LAYER or layer == GAME_GROUND_LAYER ) then
			block.Layers[layer] = block.Layers[layer] or {};
			self.UndoInformation = { block, layer, oldtext }
			block.Layers[layer].Texture = newtext;
			self.UndoInformation[4] = block.Layers[layer].Texture;
		end

	end

end

function ACTION:ConfigPanel()
end

function ACTION:UndoFunction(...)
	local Args = {...};
	if( Args[2] == GAME_BASE_LAYER or Args[2] == GAME_GROUND_LAYER ) then
		if( Args[3] ~= 0 ) then
			Args[1].Layers[Args[2]].Texture = Args[3];
		else
			Args[1].Layers[Args[2]] = nil;
		end
	end
end

function ACTION:Think(dt)

	if( (GAME.Layer == GAME_BASE_LAYER or GAME.Layer == GAME_GROUND_LAYER) and shard.__HOVERED_DETAILS ) then
		self.DrawPos = { shard.__HOVERED_DETAILS[1], shard.__HOVERED_DETAILS[2] };
	elseif( shard.__HOVERED_DETAILS and GAME.TextureSelection.sQuad and GAME.SnapToGrid ) then
		self.DrawPos = { shard.__HOVERED_DETAILS[1], (shard.__HOVERED_DETAILS[2]+shard.__HOVERED_DETAILS[4]) - (GAME.TextureSelection.sQuad.y2-GAME.TextureSelection.sQuad.y) };
	elseif( GAME.TextureSelection and GAME.TextureSelection.sQuad ) then
		self.DrawPos = { love.mouse.getX() - ((GAME.TextureSelection.sQuad.y2-GAME.TextureSelection.sQuad.y)/2), love.mouse.getY() - ((GAME.TextureSelection.sQuad.y2-GAME.TextureSelection.sQuad.y)/2) };
	end

end

function ACTION:Draw()
	if( GAME.TextureSelection and GAME.TextureSelection.dTexture and GAME.TextureSelection.dQuad and self.DrawPos ) then
		love.graphics.setColor(255,255,255,255);
		love.graphics.draw(GAME.TextureSelection.dTexture, GAME.TextureSelection.dQuad, unpack(self.DrawPos));
	end
end

function ACTION:OnSelect()
	GAME.Panels.ReftTab:SetActiveTab(2);
end

return ACTION
