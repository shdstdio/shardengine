-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local SplashScreen = new "CState";

function SplashScreen:Init()
	--self.Image = eng.Textures["textures/drop-dead-studios.png"];
	self.Image = love.graphics.newImage("textures/shard.png");
	self.Background = love.graphics.newImage("textures/splash-bg.jpg");
	--self.Alien = eng.Textures["textures/characters/alien-bug.png"];
	self.Alpha = 0;
	self.AlphaTime = 100;
	self.StartTime = 30;
	self.Full = false;
end

function SplashScreen:PostInit()
end

function SplashScreen:Think(dt)
	if( self.Full ) then
		self.Alpha = clamp(self.Alpha - 3, 0, 255);
		if( self.Alpha == 0 ) then
			self.AlphaTime = self.AlphaTime - 1;
			if( self.AlphaTime <= 0 ) then
				StateManager:Pop();
			end
		end
	else			
		if( self.StartTime <= 0 ) then
			self.Alpha = clamp(self.Alpha + 3, 0, 255);
			if( self.Alpha == 255 ) then
				self.AlphaTime = self.AlphaTime - 1;
				if( self.AlphaTime <= 0 ) then
					self.Full = true;
					self.AlphaTime = 50;
				end
			end
		end
	end
	self.StartTime = clamp(self.StartTime-1, 0, 30);
end

function SplashScreen:KeyPressed(key, uni)
	if( key == "escape" ) then
		StateManager:Pop();
	end
end

local splWide, splHeight = 0, 0;
function SplashScreen:Draw()
		
	love.graphics.setColor(0, 0, 0, 255);
	love.graphics.rectangle("fill", 0, 0, ScrW(), ScrH());
		
	love.graphics.setColor(255, 255, 255, self.Alpha);
	love.graphics.draw(self.Background, (ScrW()/2) - (self.Background:getWidth()/2), (ScrH()/2) - (self.Background:getHeight()/2));
	--love.graphics.draw(self.Alien, (ScrW()/2) - (self.Alien:getWidth()/2)-151, (ScrH()/2) - (self.Alien:getHeight()/2)+6);
	love.graphics.draw(self.Image, (ScrW()/2) - (self.Image:getWidth()/2), (ScrH()/2) - (self.Image:getHeight()/2));
	
end

function SplashScreen:Shutdown()
	self.Image = nil;
	self.Background = nil;
end

return SplashScreen;


