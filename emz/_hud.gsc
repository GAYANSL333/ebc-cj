#include maps\mp\gametypes\_hud_util;
#include codjumper\_cj_utility;

onJoinedSpectators()
{	
	self thread hideInfoHud();
}
updateInfoHud()
{
	if(level.mapHasCheckPoints)
	{
		s = level.checkPoints["easy"].size;
		c = self.cj["checkpoint"];
		self.cj["progress"] = remap((s-c), 0, s, 1, 0);

		self.cj["hud"]["info"]["progress"] updateBar(self.cj["progress"]);
		self.cj["hud"]["info"]["progress_text"] setValue(self.cj["checkpoint"]);
	}	
	self.score = self.cj["saves"];
	self.kills = self.cj["loads"];
	self.assists = self.cj["jumps"];
	self.deaths = self.cj["maxfps"];
}
hideInfoHud()
{
	info = self.cj["hud"]["info"];
	hudarray = getArrayKeys(info);
	for(i = 0 ; i < hudarray.size; i++)
		info[hudarray[i]].alpha = 0;
}
drawInfoHud()
{	
	self thread checkJump();
	
	if(!isDefined(self.cj["hud"]["info"]))
	{
		self.cj["hud"]["info"] = [];
		self.cj["hud"]["info"]["time"] = createFontString( "default", 1.4 );
		self.cj["hud"]["info"]["time"] setPoint( "RIGHT", "TOPRIGHT", -10, 10 );
		self.cj["hud"]["info"]["time"].hideWhenInMenu = true;
		self.cj["hud"]["info"]["time"].archived = true;
		self.cj["hud"]["info"]["time"].alpha = 0;
		self.cj["hud"]["info"]["time"].label = &"Time: ";
		self.cj["hud"]["info"]["time"] setTimerUp(0);
		
		self.cj["hud"]["info"]["line"] = newClientHudElem( self );
		self.cj["hud"]["info"]["line"].x = -2;
		self.cj["hud"]["info"]["line"].y = -175;
		self.cj["hud"]["info"]["line"].horzAlign = "center";
		self.cj["hud"]["info"]["line"].vertAlign = "middle";
		self.cj["hud"]["info"]["line"].alignX = "center";
		self.cj["hud"]["info"]["line"].alignY = "middle";
        self.cj["hud"]["info"]["line"].color =  (1, 1, 1);
        self.cj["hud"]["info"]["line"].hidewheninmenu = 1;
        self.cj["hud"]["info"]["line"] setShader( "line_horizontal", 100, 1 );
        self.cj["hud"]["info"]["line"].alpha =1;

		self.cj["hud"]["info"]["line2"] = newClientHudElem( self );
		self.cj["hud"]["info"]["line2"].x = -6;
		self.cj["hud"]["info"]["line2"].y = 222;
		self.cj["hud"]["info"]["line2"].horzAlign = "center";
		self.cj["hud"]["info"]["line2"].vertAlign = "middle";
		self.cj["hud"]["info"]["line2"].alignX = "center";
		self.cj["hud"]["info"]["line2"].alignY = "middle";
        self.cj["hud"]["info"]["line2"].color =  (1, 1, 1);
        self.cj["hud"]["info"]["line2"].hidewheninmenu = 1;
        self.cj["hud"]["info"]["line2"] setShader( "line_horizontal", 135, 2 );
        self.cj["hud"]["info"]["line2"].alpha =1;

		if(level.mapHasCheckPoints)
		{
			self.cj["hud"]["info"]["progress"] = self createBar((0,0.54,1), 80, 8);
	        self.cj["hud"]["info"]["progress"] setPoint( "LEFT", "BOTTOMLEFT", 5, -10);
	        self.cj["hud"]["info"]["progress"].alpha = 0;
	        self.cj["hud"]["info"]["progress"].hideWhenInMenu = true;
			self.cj["hud"]["info"]["progress"].archived = true;


			self.cj["hud"]["info"]["progress_text"] = createFontString( "default", 1.4 );
			self.cj["hud"]["info"]["progress_text"] setPoint( "LEFT", "BOTTOMLEFT", 5, -22 );
			self.cj["hud"]["info"]["progress_text"].hideWhenInMenu = true;
			self.cj["hud"]["info"]["progress_text"].archived = true;
			self.cj["hud"]["info"]["progress_text"].alpha = 0;
			self.cj["hud"]["info"]["progress_text"].label = &"Checkpoint: &&1";
		}
 	}
	info = self.cj["hud"]["info"];
	hudarray = getArrayKeys(info);
	for(i = 0 ; i < hudarray.size; i++)
	{
		info[hudarray[i]] fadeOverTime(2);
		info[hudarray[i]].alpha = 1;
	}
	self thread updateInfoHud();
}

checkJump()
{
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");
	self endon("joined_team");

	startZcoord = self.origin[2];
	
	while(1)
	{
		if(self isOnGround())
			startZcoord = self.origin[2];
			
		wait 0.05;
		
		if(self isOnLadder() || self isMantling())
		{
			startZcoord = self.origin[2];
			continue;
		}
		
		diff = self.origin[2] - startZcoord;
		
		if( diff <= 10 || diff >= 25 || self isOnGround())
			continue;

		self.cj["jumps"]++;
		temp = self GetStat(2991);
		self SetStat(2991, temp + 1);

		while(!(self isOnGround()))
			wait 0.05;
	self thread updateInfoHud();
	}
}