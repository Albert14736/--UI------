-- Copyright 2016-2020, Firaxis Games

-- ===========================================================================
--	NOTES:
--	Each tech's "Index" is the internal ID the gamecore used to track the tech.
--	This value is essentially the database (db) row id minus 1 since it's 0 based.
--	(e.g., TECH_MINING has a db rowid of 3, so it's gamecore index is 2.)
--	
--	ROWS:
--	Items exist in one of 8 "rows" that span horizontally.
--	Rows are defined via 'UITreeRow' attribute in XML 
--
--	Row#  Start   Eras->                                . Next Era
--	-3             _____        _____          _____    .  _____      _____
--	-2          /-|_____|----/-|_____|------/-|_____|---.-|_____|-\--|_____|
--	-1          |  _____     |       Nodes  |           .         |
--	 0     O----%-|_____|----'              |           .         |   _____
--	 1          \---------------------------/           .         \--|_____|
--	 2                                                  .
--	 3                                                  .
--	 4
--
--	COLUMNS:
--	Items are grouped by Eras and each Era can have a different rule as to
--	how nodes are laid out by changing the XML attribute 'TechTreeLayoutMethod'
--	
--		TechTreeLayoutMethod values:
--		"Cost"   - (default) Nodes are grouped in columns by increasing cost.
--		"Prereq" - A tech's prerequists determine order of the nodes.
--
-- ===========================================================================
include( "ToolTipHelper" );
include( "SupportFunctions" );
include( "Civ6Common" );			-- Tutorial check support
include( "TechAndCivicSupport");	-- (Already includes Civ6Common and InstanceManager) PopulateUnlockablesForTech
include( "TechFilterFunctions" );
include( "ModalScreen_PlayerYieldsHelper" );
include( "GameCapabilities" );
include( "TechAndCivicSupport_6T" );
include( "AllianceResearchSupport" );

print(" --- | 6T Tech Tree Loaded! | ---")
-- ===========================================================================
--	DEBUG
--	Toggle these for temporary debugging help.
-- ===========================================================================
debugFilterEraMaxIndex	= -1;		-- (-1 default) Only load up to a specific ERA (Value less than 1 to disable)
debugFilterTechMaxIndex	= -1;		-- (-1 default) maximum index to fill the tree with, this is overriden by the debug explicit list.
debugOutputTechInfo		= false;	-- (false default) Send to console detailed information on tech?
debugShowIDWithName		= false;	-- (false default) Show the ID before the name in each node.
debugShowAllMarkers		= false;	-- (false default) Show all player markers in the timline; even if they haven't been met.
debugExplicitList		= {};		-- List of indexes to (only) explicitly show. e.g., {0,1,2,3,4} or {5,11,17}
debugExcludeList		= {};		-- list of indexes to NOT show (the opposite of debugExplicitList)

-- ===========================================================================
--	GLOBALS
--	May be augmented or redefinied in a MOD's replacement file(s).
-- ===========================================================================
DATA_FIELD_LIVEDATA		= "_LIVEDATA";	-- The current status of an item.
DATA_FIELD_PLAYERINFO	= "_PLAYERINFO";-- Holds a table with summary information on that player.
DATA_FIELD_UIOPTIONS	= "_UIOPTIONS";	-- What options the player has selected for this screen.
DATA_ICON_PREFIX		= "ICON_";

PIC_BOLT_OFF			= "Controls_BoltOff";
PIC_BOLT_ON				= "Controls_BoltOn";
PIC_BOOST_OFF			= "BoostTech";
PIC_BOOST_ON			= "BoostTechOn";

PREREQ_ID_TREE_START	= "_TREESTART";	-- Made up, unique value, to mark a non-node tree start

PIC_DEFAULT_ERA_BACKGROUND	= "TechTree_GearButtonTile_Disabled"; -- TechTree_BGAncient
PIC_MARKER_PLAYER			= "Tree_TimePipPlayer";
PIC_MARKER_OTHER			= "Controls_TimePip";
PIC_METER_BACK				= "Tree_Meter_GearBack";
PIC_METER_BACK_DONE			= "TechTree_Meter_Done";

ITEM_STATUS				= {
							BLOCKED		= 1,
							READY		= 2,
							CURRENT		= 3,
							RESEARCHED	= 4,
							};
ROW_MAX					= 4;			-- Highest level row above 0
ROW_MIN					= -3;			-- Lowest level row below 0
SIZE_NODE_X				= 370;			-- Item node dimensions
SIZE_NODE_Y				= 84;	
STATUS_ART				= {};			-- 
STATUS_ART[ITEM_STATUS.BLOCKED]		= { Name="BLOCKED",		TextColor0=UI.GetColorValueFromHexLiteral(0xff202726), TextColor1=UI.GetColorValueFromHexLiteral(0x00000000), FillTexture="TechTree_GearButtonTile_Disabled.dds",BGU=0,BGV=(SIZE_NODE_Y*3),	IsButton=false,	BoltOn=false,	IconBacking=PIC_METER_BACK };
STATUS_ART[ITEM_STATUS.READY]		= { Name="READY",		TextColor0=UI.GetColorValueFromHexLiteral(0xaaffffff), TextColor1=UI.GetColorValueFromHexLiteral(0x88000000), FillTexture=nil,									BGU=0,BGV=0,				IsButton=true,	BoltOn=false,	IconBacking=PIC_METER_BACK  };
STATUS_ART[ITEM_STATUS.CURRENT]		= { Name="CURRENT",		TextColor0=UI.GetColorValueFromHexLiteral(0xaaffffff), TextColor1=UI.GetColorValueFromHexLiteral(0x88000000), FillTexture=nil,									BGU=0,BGV=(SIZE_NODE_Y*4),	IsButton=false,	BoltOn=true,	IconBacking=PIC_METER_BACK };
STATUS_ART[ITEM_STATUS.RESEARCHED]	= { Name="RESEARCHED",	TextColor0=UI.GetColorValueFromHexLiteral(0xaaffffff), TextColor1=UI.GetColorValueFromHexLiteral(0x88000000), FillTexture="TechTree_GearButtonTile_Done.dds",	BGU=0,BGV=(SIZE_NODE_Y*5),	IsButton=false,	BoltOn=true,	IconBacking=PIC_METER_BACK_DONE  };
TXT_BOOSTED				= Locale.Lookup("LOC_BOOST_BOOSTED");
TXT_TO_BOOST			= Locale.Lookup("LOC_BOOST_TO_BOOST");
MAX_BEFORE_TRUNC_TO_BOOST = 310;

g_kEras					= {};				-- type to costs
g_kItemDefaults			= {};				-- Static data about items
g_uiNodes				= {};
g_uiConnectorSets		= {};


-- Add to item status table. Instead of enum use hash of "UNREVEALED"; special case.
ITEM_STATUS["UNREVEALED"] = 0xB87BE593;
STATUS_ART[ITEM_STATUS.UNREVEALED]	= { Name="UNREVEALED",	TextColor0=UI.GetColorValueFromHexLiteral(0xff202726), TextColor1=UI.GetColorValueFromHexLiteral(0x00000000), FillTexture="TechTree_GearButtonTile_Disabled.dds",BGU=0,BGV=(SIZE_NODE_Y*3),	IsButton=false,	BoltOn=false,	IconBacking=PIC_METER_BACK  };

-- ===========================================================================
--	CONSTANTS
-- ===========================================================================

-- Spacing / Positioning Constants
local COLUMN_WIDTH					:number = 220;			-- Space of node and line(s) after it to the next node
local COLUMNS_NODES_SPAN			:number = 2;			-- How many colunms do the nodes span
local PADDING_TIMELINE_LEFT			:number = 275;
local PADDING_PAST_ERA_LEFT			:number = 30;
local PADDING_FIRST_ERA_INDICATOR	:number = -300;

-- Graphic constants
local SIZE_ART_ERA_OFFSET_X		:number = 40;			-- How far to push each era marker
local SIZE_ART_ERA_START_X		:number = 40;			-- How far to set the first era marker
local SIZE_MARKER_PLAYER_X		:number = 42;			-- Marker of player
local SIZE_MARKER_PLAYER_Y		:number = 42;			-- "
local SIZE_MARKER_OTHER_X		:number = 34;			-- Marker of other players
local SIZE_MARKER_OTHER_Y		:number = 37;			-- "
local SIZE_OPTIONS_X			:number = 200;
local SIZE_OPTIONS_Y			:number = 150;
local SIZE_PATH					:number = 40;
local SIZE_PATH_HALF			:number = SIZE_PATH / 2;
local SIZE_TIMELINE_AREA_Y		:number = 41;
local SIZE_TOP_AREA_Y			:number = 60;
local SIZE_WIDESCREEN_HEIGHT	:number = 768;

local PATH_MARKER_OFFSET_X			:number = 20;
local PATH_MARKER_OFFSET_Y			:number = 50;
local PATH_MARKER_NUMBER_0_9_OFFSET	:number = 20;
local PATH_MARKER_NUMBER_10_OFFSET	:number = 15;

-- Other constants
local ERA_ART						:table	= {};
local LINE_LENGTH_BEFORE_CURVE		:number = 20;			-- How long to make a line before a node before it curves
local PADDING_NODE_STACK_Y			:number = 0;
local PARALLAX_SPEED				:number = 1;			-- Speed for how much slower background moves (1.0=regular speed, 0.5=half speed)
local PARALLAX_ART_SPEED			:number = 1;			-- Speed for how much slower background moves (1.0=regular speed, 0.5=half speed)
local TREE_START_ROW				:number = 0;			-- Which virtual "row" does tree start on?
local TREE_START_COLUMN				:number = 0;			-- Which virtual "column" does tree start on? (Can be negative!)
local TREE_START_NONE_ID			:number = -999;			-- Special, unique value, to mark no special tree start node.
local VERTICAL_CENTER				:number = (SIZE_NODE_Y) / 2;
local MAX_BEFORE_TRUNC_KEY_LABEL	:number = 100;




-- ===========================================================================
--	MEMBERS / VARIABLES
-- ===========================================================================
local m_kNodeIM				:table = InstanceManager:new( "NodeInstance", 			"Top", 		Controls.NodeScroller );
local m_kLineIM				:table = InstanceManager:new( "LineImageInstance", 		"LineImage",Controls.LineScroller );
local m_kEraArtIM			:table = InstanceManager:new( "EraArtInstance", 		"Top", 		Controls.EraArtScroller );
local m_kEraLabelIM			:table = InstanceManager:new( "EraLabelInstance", 		"Top", 		Controls.ArtScroller );
local m_kEraDotIM			:table = InstanceManager:new( "EraDotInstance",			"Dot", 		Controls.ScrollbarBackgroundArt );
local m_kMarkerIM			:table = InstanceManager:new( "PlayerMarkerInstance",	"Top",		Controls.TimelineScrollbar );
local m_kPathMarkerIM		:table = InstanceManager:new( "TechPathMarker",			"Top",		Controls.LineScroller);

local m_LaunchItemManager = InstanceManager:new("LaunchBarItemHonkai", "LaunchItemHonkaiButton")
local EntryButtonInstance = nil

local m_researchHash		:number;

local SIZE_MIN_SPEC_X		:number = 1024;
local SIZE_MIN_SPEC_Y		:number = 768;

local m_width				:number= SIZE_MIN_SPEC_X;	-- Screen Width (default / min spec)
local m_height				:number= SIZE_MIN_SPEC_Y;	-- Screen Height (default / min spec)
local m_previousHeight		:number= SIZE_MIN_SPEC_Y;	-- Screen Height (default / min spec)
local m_scrollWidth			:number= SIZE_MIN_SPEC_X;	-- Width of the scroll bar
local m_kEraCounter			:table = {};				-- counter to determine which eras have techs --TODO Tronster: refactor, is this still necessary?
local m_maxColumns			:number= 0;					-- # of columns (highest column #)
local m_ePlayer				:number= -1;
local m_kAllPlayersTechData	:table = {};				-- All data for local players.
local m_kCurrentData		:table = {};				-- Current set of data.

local m_shiftDown			:boolean = false;

local m_lastPercent         :number = 0.1;
local m_FirstEraIndex		:number = -1;
local m_TopPanelConsideredHeight:number = 0;
local m_gameSeed			:number = GameConfiguration.GetValue("GAME_SYNC_RANDOM_SEED");
local m_kScrambledRowLookup	:table  = {-1,-3,2,4,0,1,-2,3};		-- To help scramble modulo rows



-- ===========================================================================
--	FUNCTIONS
-- ===========================================================================

-- ===========================================================================
--	Accessor (for MODs) so current data doesn't need to be made global.
-- ===========================================================================
function GetLiveData()
	if m_kCurrentData then
		return m_kCurrentData[DATA_FIELD_LIVEDATA];
	end
	return nil;
end

-- ===========================================================================
--	If anyone reverse processing needs to be done with the eras tracking
--	the tech, do that here.
-- ===========================================================================
function AddTechToEra( kEntry:table )
	-- Add that another tech belongs to this era
	if m_kEraCounter[kEntry.EraType] == nil then
		m_kEraCounter[kEntry.EraType] = 0;
	end			
	m_kEraCounter[kEntry.EraType] = m_kEraCounter[ kEntry.EraType ] + 1;
end

-- ===========================================================================
-- Return string respresenation of a prereq table
-- ===========================================================================
function GetPrereqsString( prereqs:table )
	local out:string = "";
	for _,prereq in pairs(prereqs) do
		if prereq == PREREQ_ID_TREE_START then
			out = "n/a ";
		elseif g_kItemDefaults[prereq] ~= nil then
			out = out .. g_kItemDefaults[prereq].Type .. " ";	-- Add space between techs
		else
			out = out .. "n/a ";
		end
	end
	return "[" .. string.sub(out,1,string.len(out)-1) .. "]";	-- Remove trailing space
end

-- ===========================================================================
function SetCurrentNode( hash:number, item )
	if hash ~= nil then
		local pPlayer = Players[Game.GetLocalPlayer()]
		if pPlayer:GetProperty("UNLOCKED_" .. item.Type) == 1 then
			print("【崩坏指挥终端】科技已解锁！")
			return
		end
		local hasAllPrereqs = true
		for _, prereqId in pairs(item.Prereqs) do
			if prereqId ~= PREREQ_ID_TREE_START then
				local prereqType = g_kItemDefaults[prereqId].Type
				if pPlayer:GetProperty("UNLOCKED_" .. prereqType) ~= 1 then
					hasAllPrereqs = false
					break
				end
			end
		end
		if not hasAllPrereqs then
			UI.PlaySound("Play_UI_Click_False");
			return
		end
		-- 无论钱够不够，全部交给底层挂载排队或秒解
		if ExposedMembers.Honkai and ExposedMembers.Honkai.SetResearchTarget then
			ExposedMembers.Honkai.SetResearchTarget(Game.GetLocalPlayer(), item.Type, item.Cost)
		end
		UI.PlaySound("Confirm_Tech_TechTree");
	else
		UI.DataError("Attempt to change current tree item with NIL hash!");
	end
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------
function GetAllTechPathPrereqs(item)
	return {}
end


-- ===========================================================================
--	If the next item isn't immediate, show a path of #s traversing the tree 
--	to the desired node.
-- ===========================================================================
function RealizePathMarkers()
	
	local localPlayer	:number = Game.GetLocalPlayer();
	if localPlayer==PlayerTypes.NONE or localPlayer==PlayerTypes.OBSERVER then return; end

	local pTechs		:table = Players[localPlayer]:GetTechs();
	local kNodeIds		:table = pTechs:GetResearchQueue();		-- table: index, IDs
	
	m_kPathMarkerIM:ResetInstances();

	for i,nodeNumber in pairs(kNodeIds) do
		local pathPin = m_kPathMarkerIM:GetInstance();

		if(i < 10) then
			pathPin.NodeNumber:SetOffsetX(PATH_MARKER_NUMBER_0_9_OFFSET);
		else
			pathPin.NodeNumber:SetOffsetX(PATH_MARKER_NUMBER_10_OFFSET);
		end
		pathPin.NodeNumber:SetText(tostring(i));
		for j,node in pairs(g_kItemDefaults) do
			if node.Index == nodeNumber then
				local x:number = g_uiNodes[node.Type].x;
				local y:number = g_uiNodes[node.Type].y;
				pathPin.Top:SetOffsetX(x-PATH_MARKER_OFFSET_X);
				pathPin.Top:SetOffsetY(y-PATH_MARKER_OFFSET_Y);
			end
		end
	end
end

-- ===========================================================================
--	Convert a virtual column # and row # to actual pixels within the
--	scrollable tree area.
-- ===========================================================================
function ColumnRowToPixelXY( column:number, row:number)	
	local horizontal		:number = ((column-1) * COLUMNS_NODES_SPAN * (COLUMN_WIDTH) ) + PADDING_TIMELINE_LEFT + PADDING_PAST_ERA_LEFT + 128;
	local vertical			:number = PADDING_NODE_STACK_Y + (SIZE_WIDESCREEN_HEIGHT / 2) + (row * SIZE_NODE_Y);
	return horizontal, vertical;
end

function GetColumnRowToPixelXY( column:number, row:number, EraType)	
	local horizontal		:number = ((column-1) * COLUMNS_NODES_SPAN * COLUMN_WIDTH - 142 ) - PADDING_TIMELINE_LEFT - PADDING_PAST_ERA_LEFT ;
	local vertical			:number = PADDING_NODE_STACK_Y + (SIZE_WIDESCREEN_HEIGHT / 2) + (row * SIZE_NODE_Y);
	return horizontal, vertical;
end
-- ===========================================================================
--	Get the width of the scroll panel
-- ===========================================================================
function GetMaxScrollWidth()
	return m_maxColumns + (m_maxColumns * COLUMN_WIDTH) + PADDING_TIMELINE_LEFT + PADDING_PAST_ERA_LEFT;
end

-- ===========================================================================
--	Get the x offset of an era art instance
-- ===========================================================================
function GetEraArtXOffset(instArt, eraData)
	local centerx			:number = GetColumnRowToPixelXY(eraData.MiddleColumn, 0, eraData.EraType) - PADDING_PAST_ERA_LEFT - 20;
	local startPaddingAmount:number = (eraData.Index == m_FirstEraIndex and PADDING_FIRST_ERA_INDICATOR or 0);
	return (centerx);
end


-- ===========================================================================
--	The rules to determine how nodes are placed on an invisible grid.
--	Override this if you want to use a different algorithm for node placement.
--
--	Rules for Vanilla, XP1, XP2: 
--	Each era has it's own set of columns, with the columns being dictated by
--	the different costs per item.  
--	e.g., If 5 items in an era cost 10,10,50,50,90 there will exist 3 columns.
--
--	RETURNS: Table which is:  nodeGrid[ row# ][ column# ] = itemType
--
-- ===========================================================================
function LayoutNodeGrid()
	
	local kNodeGrid :table = {};
	local kPaths	:table = {};	-- TODO: unused currently

	-- Loop items, first put into era columns.
	for _,item in pairs(g_kItemDefaults) do		
		
		local era	:table  = g_kEras[item.EraType];	
		
		if Locale.ToUpper(era.TechTreeLayoutMethod) == "PREREQ" then
			
			local largestPrereqNum :number  = 0;

			-- Recurse
			-- item, current item to inspect
			-- era, the era being looked at
			-- returns # of prereqs for item in era
			function GetItemsInEraPrereqChain(item, era)
				if (g_kEras[item.EraType] ~= era) then
					return 0;	-- Not in era, exit.
				end

				local largestDepth	:number  = 0;				
				for _,prereqId in pairs(item.Prereqs) do										
					if prereqId ~= PREREQ_ID_TREE_START then
						local kPrereq		:table  = g_kItemDefaults[prereqId];					
						if kPrereq ~= nil then
							local depth			:number = GetItemsInEraPrereqChain(kPrereq, era);	-- Recurse
							if (largestDepth < depth) then
								largestDepth = depth;
							end
						end
					end
				end

				-- Mark (for later) which column the item should be placed in the node grid.
				if (item["__tempLayoutColumn"] == nil) or (item.__tempLayoutColumn < largestDepth) then
					item.__tempLayoutColumn = largestDepth;
				end

				return largestDepth + 1;
			end

			largestPrereqNum = GetItemsInEraPrereqChain(item, era);

			if era.NumColumns < largestPrereqNum then
				era.NumColumns = largestPrereqNum;
			end
		else	
			-- Layout the nodes in columns based on increasing cost within an era.
			-- DEFAULT --elseif  Locale.ToUpper(era.TechTreeLayoutMethod) == "COST" or era.TechTreeLayoutMethod == "" then
			-- Create a column for each different cost in the era.
			if era.Columns[item.Cost] == nil then
				era.Columns[item.Cost] = {};
			end
			table.insert( era.Columns[item.Cost], item.Type );
			era.NumColumns = table.count( era.Columns );
		end
	end
			
	-- Loop items again to adjust 1 based index and/or set cost columns
	-- Set to a random row (for those using a random one).
	for _,item in pairs(g_kItemDefaults) do		
		local era :table  = g_kEras[item.EraType];
		
		-- Assigning column based off of total columns used		
		if Locale.ToUpper(era.TechTreeLayoutMethod) == "PREREQ" then
			item.Column = item.__tempLayoutColumn + 1;
			item.__tempLayoutColumn = nil;	

		else	-- DEFAULT --if Locale.ToUpper(era.TechTreeLayoutMethod) == "COST" then
			local i			:number = 0;
			local isFound	:boolean = false;
			for cost,columns in orderedPairs( era.Columns ) do
				if cost ~= "__orderedIndex" then			-- skip temp table used for order
					i = i + 1;
					for _,itemType in ipairs(columns) do
						if itemType == item.Type then
							item.Column = i;
							isFound = true;
							break;
						end
					end
					if isFound then break; end
				end
			end
			era.Columns.__orderedIndex = nil;
		end
	end

	-- Determine total # of columns prior to a given era, and max columns overall.
	local index = 0;
	local priorColumns:number = 0;
	m_maxColumns = 0;
	for row:table in GameInfo.Eras() do
		for era,eraData in pairs(g_kEras) do
			if eraData.Index == index then									-- Ensure indexed order
				eraData.PriorColumns = priorColumns;
				eraData.MiddleColumn = priorColumns + ((eraData.NumColumns + 1) / 2);
				priorColumns = priorColumns + eraData.NumColumns + 1;	-- Add one for era art between
				m_FirstEraIndex = m_FirstEraIndex < 0 and index or math.min(m_FirstEraIndex, index);
				break;
			end
		end
		index = index + 1;
	end
	m_maxColumns = priorColumns;

	-- Set nodes in the rows specified and columns computed above.	
	for i = ROW_MIN,ROW_MAX,1 do
		kNodeGrid[i] = {};
	end

	-- give everything its preferred slot
	for _,item in pairs(g_kItemDefaults) do
		local era		:table  = g_kEras[item.EraType];
		local columnNum :number = era.PriorColumns + item.Column;
		-- Only place the node if there isn't already another node there.  See below.
		if kNodeGrid[item.UITreeRow][columnNum] == nil then
			kNodeGrid[item.UITreeRow][columnNum] = item.Type;
		end
	end

	-- We don't know the columns the C++ intended, so there is a chance in the first era
	-- that coalescing into minimal columns will cause nodes to overlap.  Fix that if it's happening.
	for _,item in pairs(g_kItemDefaults) do
		local era		:table  = g_kEras[item.EraType];
		local columnNum :number = era.PriorColumns + item.Column;
		local placedThisNode :boolean = false;

		-- is there a collision between this and another node?
		if kNodeGrid[item.UITreeRow][columnNum] ~= nil and kNodeGrid[item.UITreeRow][columnNum] ~= item.Type then
			for j = ROW_MIN,ROW_MAX,1 do
				if kNodeGrid[j][columnNum] == nil then
					item.UITreeRow = j;
					kNodeGrid[item.UITreeRow][columnNum] = item.Type;
					placedThisNode = true;
					break;
				end
			end

			if not placedThisNode then
				UI.DataError("Too many collisions in a column!");
			end
		end
	end

	return kNodeGrid, kPaths;
end

-- ===========================================================================
--	Create UI controls based on the a node grid and connecting paths.
--	
--	kNodeGrid,	A 2D table array of [row][columns]=itemType
--	kPaths,		A table describing paths.  TODO: Describe this format. ??TRON
--
--	No state specific data (e.g., selected node) should be set here in order
--	to reuse the nodes across viewing other players' trees for single seat
--	multiplayer or if a (spy) game rule allows looking at another's tree.
-- ===========================================================================
function AllocateUI( kNodeGrid:table, kPaths:table )
		
	g_uiNodes = {};
	m_kNodeIM:ResetInstances();	

	g_uiConnectorSets = {};
	m_kLineIM:ResetInstances();

	-- Era divider information
	m_kEraArtIM:ResetInstances();
	m_kEraLabelIM:ResetInstances();
	m_kEraDotIM:ResetInstances();

	-- Autoplay check
	local playerId :number = Game.GetLocalPlayer();
	if (playerId == -1) then
		return;
	end
		
	local kkk = 0;
	for era,eraData in pairs(g_kEras) do		
		
		local instArt :table = m_kEraArtIM:GetInstance();
		if eraData.BGTexture ~= nil then
			instArt.BG:SetTexture( eraData.BGTexture );
		else
			UI.DataError("Tech tree is unable to find an EraTechBackgroundTexture entry for era '"..eraData.Description.."'; using a default.");
			instArt.BG:SetTexture(PIC_DEFAULT_ERA_BACKGROUND);
		end
		
		if eraData.EraType == "ERA_ANCIENT" then
			instArt.BG:SetOffsetX(300);
			instArt.BG:SetOffsetY(-37);
			instArt.BG:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 500, 695);
		elseif eraData.EraType == "ERA_CLASSICAL" then
			instArt.BG:SetOffsetX(GetEraArtXOffset(instArt, eraData) + 287);
			instArt.BG:SetOffsetY(-37);
			instArt.BG:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 565, 695);
		elseif eraData.EraType == "ERA_6T_POST_CLASSICAL" then
			instArt.BG:SetOffsetX(GetEraArtXOffset(instArt, eraData) + 287);
			instArt.BG:SetOffsetY(-37);
			instArt.BG:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 565, 695);
		elseif eraData.EraType == "ERA_MEDIEVAL" then
			instArt.BG:SetOffsetX(GetEraArtXOffset(instArt, eraData) + 287);
			instArt.BG:SetOffsetY(-37);
			instArt.BG:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 555, 695);
		elseif eraData.EraType == "ERA_RENAISSANCE" then
			instArt.BG:SetOffsetX(GetEraArtXOffset(instArt, eraData) + 282);
			instArt.BG:SetOffsetY(-37);
			instArt.BG:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 560, 695);
		elseif eraData.EraType == "ERA_INDUSTRIAL" then
			instArt.BG:SetOffsetX(GetEraArtXOffset(instArt, eraData) + 285);
			instArt.BG:SetOffsetY(-37);
			instArt.BG:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 550, 695);
		elseif eraData.EraType == "ERA_MODERN" then
			instArt.BG:SetOffsetX(GetEraArtXOffset(instArt, eraData) + 283);
			instArt.BG:SetOffsetY(-37);
			instArt.BG:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 555, 695);
		elseif eraData.EraType == "ERA_ATOMIC" then
			instArt.BG:SetOffsetX(GetEraArtXOffset(instArt, eraData) + 287);
			instArt.BG:SetOffsetY(-37);
			instArt.BG:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 555, 695);
		elseif eraData.EraType == "ERA_INFORMATION" then
			instArt.BG:SetOffsetX(GetEraArtXOffset(instArt, eraData) + 287);
			instArt.BG:SetOffsetY(-37);
			instArt.BG:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 565, 695);
		elseif eraData.EraType == "ERA_FUTURE" then
			instArt.BG:SetOffsetX(GetEraArtXOffset(instArt, eraData) + 287);
			instArt.BG:SetOffsetY(-37);
			instArt.BG:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 345, 695);
		end
		instArt.Top:SetOffsetY((SIZE_WIDESCREEN_HEIGHT * 0.5) - (instArt.BG:GetSizeY() * 0.5 - 152) - 120);
		instArt.Top:SetSizeVal(eraData.NumColumns * SIZE_NODE_X + 275*2, 693);

		local inst:table = m_kEraLabelIM:GetInstance();
		local eraMarkerx, _	= ColumnRowToPixelXY( eraData.PriorColumns + 1, 0) - PADDING_PAST_ERA_LEFT - 19 ;	-- Need to undo the padding in place that nodes use to get past the era marker column
		--inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED));
		if eraData.EraType == "ERA_ANCIENT" then
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED) - 15);
		elseif eraData.EraType == "ERA_CLASSICAL" then
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED)  - 65);
		elseif eraData.EraType == "ERA_6T_POST_CLASSICAL" then
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED)  - 60);
		elseif eraData.EraType == "ERA_MEDIEVAL" then
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED)  - 50);
		elseif eraData.EraType == "ERA_RENAISSANCE" then
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED)  - 50);
		elseif eraData.EraType == "ERA_INDUSTRIAL" then
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED)  - 40);
		elseif eraData.EraType == "ERA_MODERN" then
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED)  - 35);
		elseif eraData.EraType == "ERA_ATOMIC" then
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED)  - 25);
		elseif eraData.EraType == "ERA_INFORMATION" then
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED)  - 12);
		elseif eraData.EraType == "ERA_FUTURE" then
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED));
		else 
			inst.Top:SetOffsetX((eraMarkerx - (SIZE_NODE_X * 0.5)) * (1 / PARALLAX_SPEED) + 18);
		end
		inst.EraTitle:SetText(Locale.Lookup("LOC_GAME_ERA_DESC",eraData.Description));

		-- Dots on scrollbar
		local markerx:number = (eraData.PriorColumns / m_maxColumns) * Controls.ScrollbarBackgroundArt:GetSizeX();
		if markerx > 0 then
			local inst:table = m_kEraDotIM:GetInstance();
			inst.Dot:SetOffsetX(markerx);	
		end	
	end

	local playerUnlockables = GetFilteredUnlockableItems(playerId);		-- Expensive to calculate and we are going to call GetUnlockablesForTech_Cached repeatedly, pre-calculate it.
	
	-- Actually build UI nodes
	for _,item in pairs(g_kItemDefaults) do

		local tech:table		= GameInfo.Technologies[item.Type];
		local techType:string	= tech and tech.TechnologyType;

		local unlockableTypes	= techType and GetUnlockablesForTech_Cached(techType, playerId, playerUnlockables) or nil;
		local node				:table;
		local numUnlocks		:number = 0;

		if unlockableTypes ~= nil then
			for _, unlockItem in ipairs(unlockableTypes) do
				local typeInfo = GameInfo.Types[unlockItem[1]];
				numUnlocks = numUnlocks + 1;
			end
		end
				
		node = m_kNodeIM:GetInstance();
		node.Top:SetTag( item.Hash );	-- Set the hash of the technology to the tag of the node (for tutorial to be able to callout)

		local era:table = g_kEras[item.EraType];

		-- Horizontal # = All prior nodes across all previous eras + node position in current era (based on cost vs. other nodes in that era)
		local horizontal, vertical = ColumnRowToPixelXY(era.PriorColumns + item.Column, item.UITreeRow );

		-- Add data fields to UI component
		node.Type	= item.Type;					-- Dynamically add "Type" field to UI node for quick look ups in item data table.
		node.x		= horizontal;					-- Granted x,y can be looked up via GetOffset() but caching the values here for
		node.y		= vertical - VERTICAL_CENTER;	-- other LUA functions to use removes the necessity of a slow C++ roundtrip.

		if node["unlockIM"] ~= nil then
			node["unlockIM"]:DestroyInstances()
		end
		node["unlockIM"] = InstanceManager:new( "UnlockInstance", "UnlockIcon", node.UnlockStack );
		
		if node["unlockGOV"] ~= nil then
			node["unlockGOV"]:DestroyInstances()
		end
		node["unlockGOV"] = InstanceManager:new( "GovernmentIcon", "GovernmentInstanceGrid", node.UnlockStack );
	
		if tech ~= nil then
			PopulateUnlockablesForTech(playerId, tech.Index, node["unlockIM"], function() SetCurrentNode(item.Hash, item); end);
		end

		node.NodeButton:RegisterCallback( Mouse.eLClick, function() SetCurrentNode(item.Hash, item); end);
		node.OtherStates:RegisterCallback( Mouse.eLClick, function() SetCurrentNode(item.Hash, item); end);

		-- Set position and save.		
		node.Top:SetOffsetVal( horizontal, vertical);
		g_uiNodes[item.Type] = node;
	end
	
	if Controls.TreeStart ~= nil then
		local h,v = ColumnRowToPixelXY( TREE_START_COLUMN, TREE_START_ROW );
		Controls.TreeStart:SetOffsetVal( h+SIZE_NODE_X-42,v-71 );		-- TODO: Science-out the magic (numbers).
	end

	-- Determine the lines between nodes.
	-- NOTE: Potentially move this to view, since lines are constantly change in look, but
	--		 it makes sense to have at least the routes computed here since they are
	--		 consistent regardless of the look.
	local previousRow	:number = 0;
	local previousColumn:number = 0;
	for type,item in pairs(g_kItemDefaults) do
		
		local node:table = g_uiNodes[item.Type];
		for _,prereqId in pairs(item.Prereqs) do
			
			previousRow	   = TREE_START_ROW;
			previousColumn = TREE_START_COLUMN;

			if prereqId ~= PREREQ_ID_TREE_START then
				-- There had better be a preq if there is a prereq ID (unless debugging the tree).
				local prereq :table = g_kItemDefaults[prereqId];
				if (prereq ~= nil) then
					previousRow		= prereq.UITreeRow;
					previousColumn	= g_kEras[prereq.EraType].PriorColumns + prereq.Column;
				else			
					if table.count(debugExplicitList) == 0 then
						UI.DataError("Unable to find PREREQ for tech '"..item.Type.."'("..tostring(item.Index)..")");
					end
				end
			end

			local startColumn	:number = g_kEras[item.EraType].PriorColumns + item.Column;
			local column		:number	= startColumn;
			local isEarlyBend	:boolean= false;
			local isAtPrior		:boolean= false;

			while( not isAtPrior ) do
				column = column - 1;	-- Move backwards one

				-- If a node is found, make sure it's the previous node this is looking for.
				if (kNodeGrid[previousRow][column] ~= nil) then
					if kNodeGrid[previousRow][column] == prereqId then
						isAtPrior = true;
					end
				elseif column <= TREE_START_COLUMN then
					isAtPrior = true;
				end

				if (not isAtPrior) and kNodeGrid[item.UITreeRow][column] ~= nil then
					-- Was trying to hold off bend until start, but it looks to cross
					-- another node, so move the bend to the end.
					isEarlyBend = true;
				end

				if column < 0 then
					UI.DataError("Tech tree could not find prior for '"..prereqId.."'");
					break;
				end
			end


			if previousRow == TREE_START_NONE_ID then

				-- Nothing goes before this, not even a fake start area.

			elseif previousRow < item.UITreeRow or previousRow > item.UITreeRow  then				
				
				-- Obtain grid pieces to                            ____________________
				-- use in order to draw                ___ ________|                    |
				-- lines.                             |L2 |L1      |        NODE        |
				--                                    |___|________|                    |
				--   _____________________            |L3 |   x1   |____________________|
				--  |                     |___________|___|
				--	|    PREVIOUS NODE    | L5        |L4 |
				--  |                     |___________|___|
				--	|_____________________|     x2
				--
				local inst	:table = m_kLineIM:GetInstance();
				local line1	:table = inst.LineImage; inst = m_kLineIM:GetInstance();
				local line2	:table = inst.LineImage; inst = m_kLineIM:GetInstance();
				local line3	:table = inst.LineImage; inst = m_kLineIM:GetInstance();
				local line4	:table = inst.LineImage; inst = m_kLineIM:GetInstance();
				local line5	:table = inst.LineImage;
				
				-- Find all the empty space before the node before to make a bend.
				local LineEndX1:number = 0;
				local LineEndX2:number = 0;
				if isEarlyBend then
					LineEndX1 = (node.x - LINE_LENGTH_BEFORE_CURVE ) ;
					LineEndX2, _ = ColumnRowToPixelXY( column, item.UITreeRow );
					LineEndX2 = LineEndX2 + SIZE_NODE_X;
				else
					LineEndX1, _ = ColumnRowToPixelXY( column, item.UITreeRow );
					LineEndX2, _ = ColumnRowToPixelXY( column, item.UITreeRow );
					LineEndX1 = LineEndX1 + SIZE_NODE_X + LINE_LENGTH_BEFORE_CURVE;
					LineEndX2 = LineEndX2 + SIZE_NODE_X;
				end

				local prevY	:number = 0;	-- y position of the previous node being connected to

				if previousRow < item.UITreeRow  then
					prevY = node.y-((item.UITreeRow-previousRow)*SIZE_NODE_Y);-- above
					--line2:SetTexture("Controls_TreePathDashSE");
					--line4:SetTexture("Controls_TreePathDashES");
					line2:SetTexture("Tree_Path_DashSE_2.dds");
					line4:SetTexture("Tree_Path_DashES_2.dds");
					line2:SetColor(UI.GetColorValue("COLOR_WHITE"));
					line4:SetColor(UI.GetColorValue("COLOR_WHITE"));
				else
					prevY = node.y+((previousRow-item.UITreeRow)*SIZE_NODE_Y);-- below
					line2:SetTexture("Tree_Path_DashNE_2.dds");
					line4:SetTexture("Tree_Path_DashEN_2.dds");
					line2:SetColor(UI.GetColorValue("COLOR_WHITE"));
					line4:SetColor(UI.GetColorValue("COLOR_WHITE"));
				end
				
				line1:SetOffsetVal(LineEndX1 + SIZE_PATH_HALF, node.y - SIZE_PATH_HALF);				
				line1:SetSizeVal( node.x - LineEndX1 - SIZE_PATH_HALF, SIZE_PATH);
				line1:SetColor(UI.GetColorValue("COLOR_WHITE"));
				line1:SetTexture("Tree_Path_DashEW_2.dds");

				line2:SetOffsetVal(LineEndX1 - SIZE_PATH_HALF, node.y - SIZE_PATH_HALF);
				line2:SetSizeVal( SIZE_PATH, SIZE_PATH);
				line2:SetColor(UI.GetColorValue("COLOR_WHITE"));

				line3:SetOffsetVal(LineEndX1 - SIZE_PATH_HALF, math.min(node.y + SIZE_PATH_HALF, prevY + SIZE_PATH_HALF) );	
				line3:SetSizeVal( SIZE_PATH, math.abs(node.y - prevY) - SIZE_PATH );
				line3:SetColor(UI.GetColorValue("COLOR_WHITE"));
				line3:SetTexture("Tree_Path_DashNS_2.dds");
				
				
				line4:SetOffsetVal(LineEndX1 - SIZE_PATH_HALF, prevY - SIZE_PATH_HALF);
				line4:SetSizeVal( SIZE_PATH, SIZE_PATH);
				line4:SetColor(UI.GetColorValue("COLOR_WHITE"));

				line5:SetSizeVal(  LineEndX1 - LineEndX2 - SIZE_PATH_HALF, SIZE_PATH );
				line5:SetOffsetVal(LineEndX2, prevY - SIZE_PATH_HALF);
				line5:SetColor(UI.GetColorValue("COLOR_WHITE"));
				line1:SetColor(UI.GetColorValue("COLOR_WHITE"));			
				line1:SetTexture("Tree_Path_DashEW_2.dds");

				-- Directly store the line (not instance) with a key name made up of this type and the prereq's type.
				g_uiConnectorSets[item.Type..","..prereqId] = {line1,line2,line3,line4,line5};

			else
				-- Prereq is on the same row
				local inst:table = m_kLineIM:GetInstance();
				local line:table = inst.LineImage;
				line:SetTexture("Tree_Path_DashEW_2.dds");
				line:SetColor(UI.GetColorValue("COLOR_WHITE"));
				local end1, _ = ColumnRowToPixelXY( column, item.UITreeRow );
				end1 = end1 + SIZE_NODE_X;

				line:SetOffsetVal(end1, node.y - SIZE_PATH_HALF);				
				line:SetSizeVal( node.x - end1, SIZE_PATH);	

				-- Directly store the line (not instance) with a key name made up of this type and the prereq's type.
				g_uiConnectorSets[item.Type..","..prereqId] = {line};
			end				
		end
	end

	Controls.NodeScroller:CalculateSize();
	Controls.ArtScroller:CalculateSize();
	Controls.EraArtScroller:CalculateSize();

	Controls.NodeScroller:RegisterScrollCallback( OnScroll );

	-- We use a separate BG within the PeopleScroller control since it needs to scroll with the contents
	Controls.ModalBG:SetHide(true);
	Controls.ModalScreenClose:RegisterCallback(Mouse.eLClick, HideHonkaiWindow);	
	Controls.ModalScreenTitle:SetText(Locale.ToUpper(Locale.Lookup("LOC_TECH_TREE_HEADER")));
end

-- ===========================================================================
--	UI Event
--	Callback when the main scroll panel is scrolled.
-- ===========================================================================
function OnScroll( control:table, percent:number )
	
	-- Parallax 
	Controls.ArtScroller:SetScrollValue( percent );
	Controls.LineScroller:SetScrollValue( percent );
	Controls.EraArtScroller:SetScrollValue( percent );

    -- Audio
	if percent==0 or percent==1.0 then 
        if m_lastPercent == percent then
            return;
        end
        UI.PlaySound("UI_TechTree_ScrollTick_End"); 
	else 
		UI.PlaySound("UI_TechTree_ScrollTick"); 
	end
    
    m_lastPercent = percent; 
end

-- ===========================================================================
function UpdateAllianceIcon(node)
	node.Alliance:SetHide(true);
end


-- ===========================================================================
--	Now its own function so Mods / Expansions can modify the nodes
-- ===========================================================================
function PopulateNode(uiNode, playerTechData)
	local item		:table = g_kItemDefaults[uiNode.Type];						-- static item data
	local live		:table = playerTechData[DATA_FIELD_LIVEDATA][uiNode.Type];	-- live (changing) data
	local status	:number = live.IsRevealed and live.Status or ITEM_STATUS.UNREVEALED;
	local artInfo	:table = STATUS_ART[status];							-- art/styles for this state

	if(status == ITEM_STATUS.RESEARCHED) then
		for _,prereqId in pairs(item.Prereqs) do
			if(prereqId ~= PREREQ_ID_TREE_START) then
				local prereq		:table = g_kItemDefaults[prereqId];
				if prereq ~= nil then
					local previousRow	:number = prereq.UITreeRow;
					local previousColumn:number = g_kEras[prereq.EraType].PriorColumns;

					for lineNum,line in pairs(g_uiConnectorSets[item.Type..","..prereqId]) do
						if(lineNum == 1 or lineNum == 5) then
							--line:SetTexture("Controls_TreePathEW");
							line:SetTexture("Tree_Path_EW_2.dds");
						end
						if( lineNum == 3) then
							--line:SetTexture("Controls_TreePathNS");
							line:SetTexture("Tree_Path_NS_2.dds");
						end

						if(lineNum == 2)then
							if previousRow < item.UITreeRow  then
								--line:SetTexture("Controls_TreePathSE");
								line:SetTexture("Tree_Path_SE_2.dds");
							else
								--line:SetTexture("Controls_TreePathNE");
								line:SetTexture("Tree_Path_NE_2.dds");
							end
						end

						if(lineNum == 4)then
							if previousRow < item.UITreeRow  then
								--line:SetTexture("Controls_TreePathES");
								line:SetTexture("Tree_Path_ES_2.dds");
							else
								--line:SetTexture("Controls_TreePathEN");
								line:SetTexture("Tree_Path_EN_2.dds");
							end
						end
					end
				else
					print("Unresolved prereq "..prereqId);
				end
			end
		end
	end

	uiNode.NodeName:SetColor( artInfo.TextColor0, 0 );
	uiNode.NodeName:SetColor( artInfo.TextColor1, 1 );

	uiNode.UnlockStack:SetHide( status==ITEM_STATUS.UNREVEALED );	-- Show/hide unlockables based on revealed status.

	local nodeName :string = (status==ITEM_STATUS.UNREVEALED) and Locale.Lookup("LOC_TECH_TREE_NOT_REVEALED_TECH") or Locale.Lookup(item.Name);
	if debugShowIDWithName then
		uiNode.NodeName:SetText( tostring(item.Index).."  ".. nodeName);	-- Debug output
	else
		uiNode.NodeName:SetText( Locale.ToUpper( nodeName ));				-- Normal output
	end

	if live.Turns > 0 then
		uiNode.Turns:SetHide( false );
		uiNode.Turns:SetColor( artInfo.TextColor0, 0 );
		uiNode.Turns:SetColor( artInfo.TextColor1, 1 );
		uiNode.Turns:SetText( Locale.Lookup("LOC_TECH_TREE_TURNS",live.Turns) );
	else
		uiNode.Turns:SetHide( true );
	end

	if item.IsBoostable and status ~= ITEM_STATUS.RESEARCHED and status ~= ITEM_STATUS.UNREVEALED then
		uiNode.BoostIcon:SetHide( false );
		uiNode.BoostText:SetHide( false );
		uiNode.BoostText:SetColor( artInfo.TextColor0, 0 );
		uiNode.BoostText:SetColor( artInfo.TextColor1, 1 );

		local boostText:string;
		if live.IsBoosted then
			boostText = TXT_BOOSTED.." "..item.BoostText;
			uiNode.BoostIcon:SetTexture( PIC_BOOST_ON );
			uiNode.BoostMeter:SetHide( true );
			uiNode.BoostedBack:SetHide( false );
		else
			boostText = TXT_TO_BOOST.." "..item.BoostText;
			uiNode.BoostedBack:SetHide( true );
			uiNode.BoostIcon:SetTexture( PIC_BOOST_OFF );
			uiNode.BoostMeter:SetHide( false );
			local boostAmount = (item.BoostAmount*.01) + (live.Progress/ live.Cost);
			uiNode.BoostMeter:SetPercent( boostAmount );
		end
		TruncateStringWithTooltip(uiNode.BoostText, MAX_BEFORE_TRUNC_TO_BOOST, boostText);
	else
		uiNode.BoostIcon:SetHide( true );
		uiNode.BoostText:SetHide( true );
		uiNode.BoostedBack:SetHide( true );
		uiNode.BoostMeter:SetHide( true );
	end

	if status == ITEM_STATUS.CURRENT then
		uiNode.GearAnim:SetHide( false );
	else
		uiNode.GearAnim:SetHide( true );
	end

	if live.Progress > 0 and status ~= ITEM_STATUS.RESEARCHED then
		uiNode.ProgressMeter:SetHide( false );
		uiNode.ProgressMeter:SetPercent(live.Progress / live.Cost);
	else
		uiNode.ProgressMeter:SetHide( true );
	end

	-- Show/Hide Recommended Icon
	if live.IsRecommended and live.AdvisorType ~= nil and live.Status ~= ITEM_STATUS.RESEARCHED then
		uiNode.RecommendedIcon:SetIcon(live.AdvisorType);
		uiNode.RecommendedIcon:SetHide(false);
	else
		uiNode.RecommendedIcon:SetHide(true);
	end

	-- Set art and tool tip for icon area
	if status == ITEM_STATUS.UNREVEALED then
		uiNode.NodeButton:SetToolTipString(Locale.Lookup("LOC_TECH_TREE_NOT_REVEALED_TOOLTIP"));
		uiNode.Icon:SetIcon("ICON_TECH_UNREVEALED");
		uiNode.IconBacking:SetHide(true);
		uiNode.BoostMeter:SetColor(UI.GetColorValueFromHexLiteral(0x66ffffff));
		uiNode.BoostIcon:SetColor(UI.GetColorValueFromHexLiteral(0x66000000));
	else

		uiNode.NodeButton:SetToolTipString(item.Description);

		if(uiNode.Type ~= nil) then
			local iconName :string = DATA_ICON_PREFIX .. uiNode.Type;
			if (artInfo.Name == "BLOCKED") then
				uiNode.IconBacking:SetHide(true);
				iconName = iconName .. "_FOW";
				uiNode.BoostMeter:SetColor(UI.GetColorValueFromHexLiteral(0x66ffffff));
				uiNode.BoostIcon:SetColor(UI.GetColorValueFromHexLiteral(0x66000000));
			else
				uiNode.IconBacking:SetHide(false);
				iconName = iconName;
				uiNode.BoostMeter:SetColor(UI.GetColorValue("COLOR_WHITE"));
				uiNode.BoostIcon:SetColor(UI.GetColorValue("COLOR_WHITE"));
			end
			local textureOffsetX, textureOffsetY, textureSheet = IconManager:FindIconAtlas(iconName, 42);
			if (textureOffsetX ~= nil) then
				uiNode.Icon:SetTexture( textureOffsetX, textureOffsetY, textureSheet );
			end
		end
	end

	if artInfo.IsButton then
		uiNode.OtherStates:SetHide( true );
		uiNode.NodeButton:SetTextureOffsetVal( artInfo.BGU, artInfo.BGV );
	else
		uiNode.OtherStates:SetHide( false );
		uiNode.OtherStates:SetTextureOffsetVal( artInfo.BGU, artInfo.BGV );
	end

	if artInfo.FillTexture ~= nil then
		uiNode.FillTexture:SetHide( false );
		uiNode.FillTexture:SetTexture( artInfo.FillTexture );
	else
		uiNode.FillTexture:SetHide( true );
	end

	if artInfo.BoltOn then
		uiNode.Bolt:SetTexture(PIC_BOLT_ON);
	else
		uiNode.Bolt:SetTexture(PIC_BOLT_OFF);
	end

	uiNode.IconBacking:SetTexture(artInfo.IconBacking);

	-- Darken items not making it past filter.
	local currentFilter:table = playerTechData[DATA_FIELD_UIOPTIONS].filter;
	if currentFilter == nil or currentFilter.Func == nil or currentFilter.Func( item.Type ) then
		uiNode.FilteredOut:SetHide( true );
	else
		uiNode.FilteredOut:SetHide( false );
	end

	-- Civilopedia: Only show if revealed tech; only wire up handlers if not in an on-rails tutorial.
	function OpenPedia()
		if live.IsRevealed then
			LuaEvents.OpenCivilopedia(uiNode.Type);
		end
	end
	if IsTutorialRunning()==false then
		uiNode.NodeButton:RegisterCallback( Mouse.eRClick, OpenPedia);
		uiNode.OtherStates:RegisterCallback( Mouse.eRClick,OpenPedia);
	end

	UpdateAllianceIcon(uiNode);
end

-- ===========================================================================
--	Display the state of the tree (filter, node display, etc...) based on the 
--	active player's item data. 
-- ===========================================================================
function View( playerTechData:table )
	
	local pts = Players[m_ePlayer]:GetProperty("HONKAI_RESEARCH_POINTS") or 0
	Controls.ModalScreenTitle:SetText(Locale.ToUpper("崩坏指挥终端 / 当前崩坏能: " .. pts .. " 点"));
	
	-- Output the node states for the tree
	for _,uiNode in pairs(g_uiNodes) do
		PopulateNode( uiNode, playerTechData);
	end

	-- Fill in where the markers (representing players) are at:
	m_kMarkerIM:ResetInstances();
	local PADDING		:number = 24;
	local thisPlayerID	:number = Game.GetLocalPlayer();
	local markers		:table	= m_kCurrentData[DATA_FIELD_PLAYERINFO].Markers;
	for _,markerStat in ipairs( markers ) do

		-- Only build a marker if a player has started researching...
		if markerStat.HighestColumn ~= -1 then
			local instance	:table	= m_kMarkerIM:GetInstance();

			if markerStat.IsPlayerHere then
				-- Representing the player viewing the tree			
				instance.Portrait:SetHide( true );
				instance.TurnGrid:SetHide( false );
				instance.TurnLabel:SetText( Locale.Lookup("LOC_TECH_TREE_TURN_NUM" ));
				
				--instance.TurnNumber:SetText( tostring(Game.GetCurrentGameTurn()) );
				local turn = Game.GetCurrentGameTurn();
				instance.TurnNumber:SetText(tostring(turn));

				local turnLabelWidth = PADDING + instance.TurnLabel:GetSizeX() +  instance.TurnNumber:GetSizeX(); 
				instance.TurnGrid:SetSizeX( turnLabelWidth );
				instance.Marker:SetTexture( PIC_MARKER_PLAYER );
				instance.Marker:SetSizeVal( SIZE_MARKER_PLAYER_X, SIZE_MARKER_PLAYER_Y );
			else
				-- An other player				
				instance.TurnGrid:SetHide( true );
				instance.Marker:SetTexture( PIC_MARKER_OTHER );
				instance.Marker:SetSizeVal( SIZE_MARKER_OTHER_X, SIZE_MARKER_OTHER_Y );
			end

			-- Different content in marker based on if there is just 1 player in the column, or more than 1
			local tooltipString				:string = Locale.Lookup("LOC_TREE_ERA", Locale.Lookup(GameInfo.Eras[markerStat.HighestEra].Name) ).."[NEWLINE]";
			local numOfPlayersAtThisColumn	:number = table.count(markerStat.PlayerNums);
			if numOfPlayersAtThisColumn < 2 then
				instance.Num:SetHide( true );			
				local playerNum		:number = markerStat.PlayerNums[1];
				local pPlayerConfig :table =  PlayerConfigurations[playerNum];
				tooltipString = tooltipString.. Locale.Lookup(pPlayerConfig:GetPlayerName());	-- ??TRON: Temporary using player name until leaderame is fixed

				if not markerStat.IsPlayerHere then
					local iconName:string = "ICON_"..pPlayerConfig:GetLeaderTypeName();
					local textureOffsetX:number, textureOffsetY:number, textureSheet:string = IconManager:FindIconAtlas(iconName);
					instance.Portrait:SetHide( false );
					instance.Portrait:SetTexture( textureOffsetX, textureOffsetY, textureSheet );
				end
			else
				instance.Portrait:SetHide( true );
				instance.Num:SetHide( false );
				instance.Num:SetText(tostring(numOfPlayersAtThisColumn));
				for i,playerNum in ipairs(markerStat.PlayerNums) do
					local pPlayerConfig :table = PlayerConfigurations[playerNum];
					--tooltipString = tooltipString.. Locale.Lookup(pPlayerConfig:GetLeaderName()); 
					tooltipString = tooltipString.. Locale.Lookup(pPlayerConfig:GetPlayerName());	-- ??TRON: Temporary using player name until leaderame is fixed
					if i < numOfPlayersAtThisColumn then
						tooltipString = tooltipString.."[NEWLINE]";
					end
				end
			end
			instance.Marker:SetToolTipString( tooltipString );

			local MARKER_OFFSET_START:number = 20;
			local markerPercent :number = math.clamp( markerStat.HighestColumn / m_maxColumns, 0, 1 );
			local markerX		:number = MARKER_OFFSET_START + (markerPercent * m_scrollWidth );
			instance.Top:SetOffsetVal(markerX ,0);
		end
	end

	RealizePathMarkers();
end


-- ===========================================================================
--	Load all the 'live' data for a player.
-- ===========================================================================
function GetCurrentData( ePlayer:number, eCompletedTech:number )
	local data	:table = m_kAllPlayersTechData[ePlayer];	
	if data == nil then
		data = {};
		data[DATA_FIELD_LIVEDATA]			= {};
		data[DATA_FIELD_PLAYERINFO]			= {};
		data[DATA_FIELD_UIOPTIONS]			= {};
		data[DATA_FIELD_PLAYERINFO].Player	= ePlayer;
		data[DATA_FIELD_PLAYERINFO].Markers	= {};
		data[DATA_FIELD_PLAYERINFO].Stats	= {};
	end	

	local pPlayer = Players[ePlayer]
	local currentPoints = pPlayer:GetProperty("HONKAI_RESEARCH_POINTS") or 0
	local currentResearch = pPlayer:GetProperty("HONKAI_CURRENT_RESEARCH")

	for type,item in pairs(g_kItemDefaults) do
		local isUnlocked = (pPlayer:GetProperty("UNLOCKED_" .. type) == 1)
		local status = ITEM_STATUS.BLOCKED
		if isUnlocked then
			status = ITEM_STATUS.RESEARCHED
		else
			local hasAllPrereqs = true
			for _, prereqId in pairs(item.Prereqs) do
				if prereqId ~= PREREQ_ID_TREE_START then
					local prereqType = g_kItemDefaults[prereqId].Type
					if pPlayer:GetProperty("UNLOCKED_" .. prereqType) ~= 1 then
						hasAllPrereqs = false
						break
					end
				end
			end
			if hasAllPrereqs then status = ITEM_STATUS.READY end
			
			-- 检查是否为当前排队的科研目标
			if type == currentResearch then
				status = ITEM_STATUS.CURRENT
			end
		end
		
		local progress = 0
		local turnsLeft = 0
		if status == ITEM_STATUS.CURRENT then
			progress = currentPoints
			turnsLeft = math.ceil(math.max(0, item.Cost - currentPoints) / 10) -- 暂时写死每回合发 10 点，用于算剩余回合
		end
		data[DATA_FIELD_LIVEDATA][type] = {
			Cost		= item.Cost,
			IsBoosted	= false,
			Progress	= progress,
			Status		= status,
			Turns		= turnsLeft,
			IsRecommended = false,
			IsRevealed  = true
		}
	end

	data[DATA_FIELD_PLAYERINFO].Markers = {}
	return data;
end



-- ===========================================================================
function OnLocalPlayerTurnBegin()
	local ePlayer :number = Game.GetLocalPlayer();
	if ePlayer ~= -1 then
	    --local kPlayer :table = Players[ePlayer];
	    if m_ePlayer ~= ePlayer then
		    m_ePlayer = ePlayer;
		    m_kCurrentData = GetCurrentData( ePlayer );		    
	    end
    end
end

-- ===========================================================================
--	EVENT
--	Player turn is ending
-- ===========================================================================
function OnLocalPlayerTurnEnd()
	-- If current data set is for the player, save back any changes into
	-- the table of player tables.
	local ePlayer :number = Game.GetLocalPlayer();
	if ePlayer ~= -1 then
		if m_kCurrentData[DATA_FIELD_PLAYERINFO].Player == ePlayer then
			m_kAllPlayersTechData[ePlayer] = m_kCurrentData;
		end
	end

	if(GameConfiguration.IsHotseat()) then
		HideHonkaiWindow();
	end
end

-- ===========================================================================
function OnResearchChanged( ePlayer:number, eTech:number )	
	if (m_ePlayer == PlayerTypes.NONE or m_ePlayer == PlayerTypes.OBSERVER) then return; end			-- Autoplay support.	
	if not ContextPtr:IsHidden() and ShouldUpdateWhenResearchChanges( ePlayer ) then
		m_kCurrentData = GetCurrentData( m_ePlayer, -1 );
		View( m_kCurrentData );
	end
end
-- ===========================================================================
-- Updates the amount of turns needed to complete tech research when tech per-
-- turn is increased or decreased.
-- ===========================================================================
function OnUpdateResearchOnTechChanged(ePlayer:number, cityID:number, plotX:number, plotY:number)
	if (ePlayer == m_ePlayer) then
		m_kCurrentData = GetCurrentData( ePlayer, -1 );
		View( m_kCurrentData );
	end
end

-- ===========================================================================
--	Should a view be updated (an expensive operation.)
--	Broken out for eash override behavior in MODs.
--
--		ePlayer, the current player 
-- ===========================================================================
function ShouldUpdateWhenResearchChanges( ePlayer:number )
	return m_ePlayer == ePlayer or HasMaxLevelResearchAlliance(ePlayer);
end

-- ===========================================================================
function OnResearchComplete( ePlayer:number, eTech:number)
	if ePlayer == Game.GetLocalPlayer() then
		m_ePlayer = ePlayer;
		m_kCurrentData = GetCurrentData( m_ePlayer, eTech );
		if not ContextPtr:IsHidden() then
			View( m_kCurrentData );
		end
	end
end

-- ===========================================================================
--	Initially size static UI elements 
--	(or re-size if screen resolution changed)
-- ===========================================================================
function Resize()
	m_width, m_height	= UIManager:GetScreenSizeVal();		-- Cache screen dimensions
	m_scrollWidth		= m_width - 80;						-- Scrollbar area (where markers are placed) slightly smaller than screen width

	-- Determine how far art will span.
	-- First obtain the size of the tree by taking the visible size and multiplying it by the ratio of the full content
	local scrollPanelX:number = (Controls.NodeScroller:GetSizeX() / Controls.NodeScroller:GetRatio());

	local artAndEraScrollWidth:number = math.max( scrollPanelX * (1/PARALLAX_SPEED), m_width ) 
		+ SIZE_ART_ERA_OFFSET_X 
		+ SIZE_ART_ERA_START_X;

	Controls.ArtParchmentDecoTop:SetSizeX( artAndEraScrollWidth );
	Controls.ArtParchmentDecoBottom:SetSizeX( artAndEraScrollWidth );
	Controls.ArtParchmentRippleTop:SetSizeX( artAndEraScrollWidth );
	Controls.ArtParchmentRippleBottom:SetSizeX( artAndEraScrollWidth );
	Controls.ForceSizeX:SetSizeX( artAndEraScrollWidth );
	Controls.ForceArtSizeX:SetSizeX( scrollPanelX * (1/PARALLAX_ART_SPEED) );
	Controls.LineForceSizeX:SetSizeX( scrollPanelX );
	Controls.LineScroller:CalculateSize();
	Controls.ArtScroller:CalculateSize();

	local backArtScrollWidth:number = scrollPanelX * (1/PARALLAX_ART_SPEED) + 100;
	Controls.Background:SetSizeX( math.max(backArtScrollWidth, m_width) );
	Controls.Background:SetSizeY( SIZE_WIDESCREEN_HEIGHT - (SIZE_TIMELINE_AREA_Y - 8) );	
	Controls.EraArtScroller:CalculateSize();
end

-- ===========================================================================
function OnUpdateUI( type:number, tag:string, iData1:number, iData2:number, strData1:string)
	if type == SystemUpdateUI.ScreenResize then
		Resize();
	end
end

-- ===========================================================================
--	Obtain the data from the DB that doesn't change
--	Base costs and relationships (prerequisites)
--	RETURN: A table of node data (techs/civics/etc...) with a prereq for each entry.
-- ===========================================================================
function PopulateItemData()
	local kItemDefaults :table = {};		-- Table to return

	local HonkaiTechTreeData = {
		{
			Type = "HONKAI_TECH_PERCEPTION",
			Name = "崩坏能感知",
			Description = "一切的开始。允许开采崩坏能矿脉，并揭示基础的崩坏现象。",
			Cost = 25,
			EraType = "ERA_ANCIENT",
			UITreeRow = 0,
			Prereqs = {},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_ST_FREYA",
			Name = "圣芙蕾雅学园",
			Description = "解锁特色建筑【圣芙蕾雅学园】，允许训练初级女武神。",
			Cost = 60,
			EraType = "ERA_ANCIENT",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_PERCEPTION"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_SCHICKSAL",
			Name = "天命武装",
			Description = "解锁天命阵营的特色近战机甲与防御战术。",
			Cost = 60,
			EraType = "ERA_ANCIENT",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_PERCEPTION"},
			Column = 2
		}
	}

	for i, row in ipairs(HonkaiTechTreeData) do
		local kEntry:table	= {};
		kEntry.Type			= row.Type;
		kEntry.Name			= row.Name;
		kEntry.BoostText	= "";
		kEntry.Column		= row.Column;
		kEntry.Cost			= row.Cost;
		kEntry.Description	= row.Description;
		kEntry.EraType		= row.EraType;
		kEntry.Hash			= i; 
		kEntry.Index		= i; 
		kEntry.IsBoostable	= false;
		kEntry.Prereqs		= row.Prereqs;
		kEntry.UITreeRow	= row.UITreeRow;
		kEntry.Unlocks		= {};

		if table.count(kEntry.Prereqs) == 0 then
			table.insert(kEntry.Prereqs, PREREQ_ID_TREE_START);
		end

		AddTechToEra( kEntry );
		kItemDefaults[kEntry.Type] = kEntry;
	end

	return kItemDefaults;
end

-- ===========================================================================
--	Create a hash table of EraType to its chronological index.
-- ===========================================================================
function PopulateEraData()
	g_kEras = {};
	for row:table in GameInfo.Eras() do
		if m_kEraCounter[row.EraType] and m_kEraCounter[row.EraType] > 0 and debugFilterEraMaxIndex < 1 or row.ChronologyIndex <= debugFilterEraMaxIndex then		
			table.insert(g_kEras, { 
				EraType		= row.EraType,
				BGTexture	= row.EraTechBackgroundTexture,
				Description	= Locale.Lookup(row.Name),
				NumColumns	= 0,				
				ChronologyIndex = row.ChronologyIndex,
				Index		= -1,
				PriorColumns= -1,
				Columns		= {},		-- column data
				EraLayoutMethod = (row.TechTreeLayoutMethod ~= nil) and row.TechTreeLayoutMethod or "",
				TechTreeLayoutMethod = UITree.GetLayoutType();
			});
		end
	end	

	-- Correctly assign the index to be the index of the era sorted by chronology index.
	-- Also index
	table.sort(g_kEras, function(a,b) return a.ChronologyIndex < b.ChronologyIndex; end);
	for i,v in ipairs(g_kEras) do
		v.Index = i - 1 ; -- 0-based indexing.
		g_kEras[v.EraType] = v;

		-- if the code is saying cost-based but the era in the DB says prereq, take prereq
		if Locale.ToUpper(v.TechTreeLayoutMethod) ~= "PREREQ" then
			if Locale.ToUpper(v.EraLayoutMethod) == "PREREQ" then
				v.TechTreeLayoutMethod = v.EraLayoutMethod;
			end

			-- also, future era is always prereq
			if v.Description == "Future Era" then
				v.TechTreeLayoutMethod = "PREREQ";
			end
		end
	end
end


-- ===========================================================================
--
-- ===========================================================================

-- ===========================================================================
--	filterLabel,	Readable lable of the current filter.
--	filterFunc,		The funciton filter to apply to each node as it's built,
--					nil will reset the filters to none.
-- ===========================================================================
-- ===========================================================================
-- 全新的 UI 开关体系（极简稳定版 + 左上角按钮挂载）
-- ===========================================================================
function ShowHonkaiWindow()
    if (Game.GetLocalPlayer() == -1) then return end
    UI.PlaySound("UI_Screen_Open");
    m_kCurrentData = GetCurrentData( m_ePlayer );
    View( m_kCurrentData );
    ContextPtr:SetHide(false);
    if not RefreshYields() then		
        Controls.Vignette:SetSizeY( m_TopPanelConsideredHeight );
    end
    Controls.ScreenAnimIn:SetToBeginning();
    Controls.ScreenAnimIn:Play();
end

function HideHonkaiWindow()
    if not ContextPtr:IsHidden() then
        UI.PlaySound("UI_Screen_Close");
    end
    ContextPtr:SetHide(true);
end

function ToggleHonkaiWindow()
    if ContextPtr:IsHidden() then
        ShowHonkaiWindow()
    else
        HideHonkaiWindow()
    end
end

-- 拦截机制放行
function HonkaiInputHandler( pInputStruct:table )
    local uiMsg = pInputStruct:GetMessageType();
    if uiMsg == KeyEvents.KeyUp and pInputStruct:GetKey() == Keys.VK_ESCAPE then
        if not ContextPtr:IsHidden() then
            HideHonkaiWindow();
            return true;
        end
    end
    return false; 
end

function SetupLaunchBarButton()
    local ctrl = ContextPtr:LookUpControl("/InGame/LaunchBar/ButtonStack")
    if ctrl == nil then return end
    if EntryButtonInstance == nil then
        EntryButtonInstance = m_LaunchItemManager:GetInstance(ctrl)
        EntryButtonInstance.LaunchItemHonkaiButton:RegisterCallback(Mouse.eLClick, ToggleHonkaiWindow)
        ctrl:CalculateSize()
        ctrl:ReprocessAnchoring()
        local launchBar = ContextPtr:LookUpControl("/InGame/LaunchBar")
        if launchBar then
            launchBar:CalculateSize()
            launchBar:ReprocessAnchoring()
        end
    end
end

function HonkaiInitHandler(isReload)
    LateInitialize()
    SetupLaunchBarButton()
    ContextPtr:SetHide(true)
end

function OnShutdown()
    if EntryButtonInstance ~= nil then
        m_LaunchItemManager:ReleaseInstance(EntryButtonInstance)
    end
end

-- ===========================================================================
-- 核心构造与数据初始化
-- ===========================================================================
function BuildTree()
    local kNodeGrid	:table = nil;
    local kPaths	:table = nil;
    kNodeGrid, kPaths = LayoutNodeGrid(); 
    AllocateUI( kNodeGrid, kPaths );
end

function LateInitialize()
    m_ePlayer = Game.GetLocalPlayer();
    if (m_ePlayer == -1) then return; end
    
    g_kItemDefaults = PopulateItemData();
    PopulateEraData();
    BuildTree();


    Resize();	
    m_kCurrentData = GetCurrentData( m_ePlayer );
    View( m_kCurrentData );
end

function Initialize()
    if debugExplicitList == nil then debugExplicitList = {} end
    if table.count(debugExplicitList) ~= 0 then
        local temp:table = {};
        for i,v in ipairs(debugExplicitList) do temp[v] = true; end
        debugExplicitList = temp;
    end

    if debugExcludeList == nil then debugExcludeList = {} end
    if table.count(debugExcludeList) ~= 0 then
        local temp:table = {};
        for i,v in ipairs(debugExcludeList) do temp[v] = true; end
        debugExcludeList = temp;
    end

    -- 【绑定新的 UI 开关钩子】
    ContextPtr:SetInitHandler( HonkaiInitHandler );
    ContextPtr:SetInputHandler( HonkaiInputHandler, true );
    ContextPtr:SetShutdown( OnShutdown );
    

    -- 【侵蚀之律者同款伪监听拦截网】
    LuaEvents.Tutorial_ToggleInGameOptionsMenu.Add(HideHonkaiWindow)
    LuaEvents.DiplomacyActionView_HideIngameUI.Add(HideHonkaiWindow)
    LuaEvents.EndGameMenu_Shown.Add(HideHonkaiWindow)
    LuaEvents.FullscreenMap_Shown.Add(HideHonkaiWindow)
    LuaEvents.NaturalWonderPopup_Shown.Add(HideHonkaiWindow)
    LuaEvents.ProjectBuiltPopup_Shown.Add(HideHonkaiWindow)
    LuaEvents.WonderBuiltPopup_Shown.Add(HideHonkaiWindow)
    LuaEvents.NaturalDisasterPopup_Shown.Add(HideHonkaiWindow)
    LuaEvents.RockBandMoviePopup_Shown.Add(HideHonkaiWindow)
    
    -- 防止和原版科技树抢夺入口
    LuaEvents.LaunchBar_RaiseTechTree.Add(HideHonkaiWindow); 
    LuaEvents.ResearchChooser_RaiseTechTree.Add(HideHonkaiWindow); 

    -- Game engine Event
    Events.LocalPlayerTurnBegin.Add( OnLocalPlayerTurnBegin );
    Events.LocalPlayerTurnEnd.Add( OnLocalPlayerTurnEnd );
    Events.LocalPlayerChanged.Add( BuildTree );
    Events.ResearchChanged.Add( OnResearchChanged );
    Events.ResearchQueueChanged.Add( OnResearchChanged );
    Events.ResearchCompleted.Add( OnResearchComplete );
    Events.SystemUpdateUI.Add( OnUpdateUI );
    Events.CityWorkerChanged.Add( OnUpdateResearchOnTechChanged );
    Events.CityFocusChanged.Add( OnUpdateResearchOnTechChanged );

    m_TopPanelConsideredHeight = Controls.Vignette:GetSizeY() - TOP_PANEL_OFFSET;
    
    Controls.ModalScreenClose:RegisterCallback(Mouse.eLClick, HideHonkaiWindow);

    -- 监听底层发来的“已购买”广播，瞬间刷新 UI
    LuaEvents.HonkaiTech_RefreshUI.Add(function(playerID)
        if playerID == m_ePlayer then
            m_kCurrentData = GetCurrentData(m_ePlayer);
            if not ContextPtr:IsHidden() then View(m_kCurrentData); end
        end
    end)

    -- 手动触发初始化，因为 LoadGameViewStateDone 触发时 UI 引擎已经错过了 Init 阶段
    HonkaiInitHandler(false)
end

Events.LoadGameViewStateDone.Add(Initialize)
