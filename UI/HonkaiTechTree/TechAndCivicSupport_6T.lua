-- ===========================================================================
-- Better Tech Tree
-- Author: Infixo
-- 2018-03-19: Created
-- 2018-12-01: Version 1.1, added option to switch off the harvest icons
-- 2019-04-09: Version 1.2, added Unit Commands
-- 2019-04-19: Version 2.0, new icons, modifiers, feature removals, embarkment

-- JNR changelog:
-- added configuration options check for showing boosts
-- new background textures
-- grabbing items to display from new table for custom unlocks
-- commented out items better fit to be implemented as custom unlock
-- hiding adjacency bonuses if the improvement/district to be adjacent to is an unavailable unique
-- ===========================================================================

-- configuration options

local LL = Locale.Lookup;


-- ===========================================================================
-- CACHE BASE FUNCTIONS
-- ===========================================================================
BTT_BASE_PopulateUnlockablesForCivic = PopulateUnlockablesForCivic;
BTT_BASE_PopulateUnlockablesForTech = PopulateUnlockablesForTech;

-- ===========================================================================
-- DATA AND HELPERS
-- ===========================================================================

local m_kExtraUnlockables:table = {}; -- simple table, each value is data for 1 extra unlock


-- filter out the unlockables for a specific tech or civic
function GetExtraUnlockables(sType:string)
	local tExtras:table = {};
	for _,item in ipairs(m_kExtraUnlockables) do
		if item.Type == sType then table.insert(tExtras, item); end
	end
	--print("found", #tExtras, "for", sType)
	return tExtras;
end

function AddExtraUnlockable(sType:string, sUnlockKind:string, sUnlockType:string, sDescription:string, sPediaKey:string)
	--print("FUN AddExtraUnlockable",sType, sUnlockKind, sUnlockType, sDescription, sPediaKey);
	local tItem:table = {
		Type = sType,
		UnlockKind = sUnlockKind, -- "BOOST", "IMPROVEMENT", "SPY", "HARVEST"
		UnlockType = sUnlockType, -- actual object to be shown
		Description = sDescription, -- additional info, to put on the icon OR into the tooltip
		PediaKey = sPediaKey,
	}
	table.insert(m_kExtraUnlockables, tItem);
end

function IsExtraUnlockableAdded(sType:string, sUnlockKind:string, sUnlockType:string)
	for _,item in ipairs(m_kExtraUnlockables) do
		if item.Type == sType and item.UnlockKind == sUnlockKind and item.UnlockType == sUnlockType then return true; end
	end
	return false;
end

-- ===========================================================================
--
-- ===========================================================================

local tBackgroundTextures:table = {
	POWER = "ICON_BTT_BG_POWER",
	GDR = "ICON_BTT_BG_GDR",
	COMMAND = "ICON_BTT_BG_COMMAND",
	COAST = "ICON_BTT_BG_COAST",
	OCEAN = "ICON_BTT_BG_OCEAN",
	GOVT = "ICON_TECHUNLOCK_6",
	DIPL = "ICON_TECHUNLOCK_8",
	OTHER = "ICON_BTT_BG_MISC",
	IMPR_BONUS_GENERIC = "ICON_TECHUNLOCK_3",
	IMPR_BONUS_YIELD_FOOD = "ICON_BTT_BG_IMP_YIELD_FOOD",
	IMPR_BONUS_YIELD_PRODUCTION = "ICON_BTT_BG_IMP_YIELD_PRODUCTION",
	IMPR_BONUS_YIELD_GOLD = "ICON_BTT_BG_IMP_YIELD_GOLD",
	IMPR_BONUS_YIELD_SCIENCE = "ICON_BTT_BG_IMP_YIELD_SCIENCE",
	IMPR_BONUS_YIELD_CULTURE = "ICON_BTT_BG_IMP_YIELD_CULTURE",
	IMPR_BONUS_YIELD_FAITH = "ICON_BTT_BG_IMP_YIELD_FAITH",
	IMPR_SPECIAL = "ICON_BTT_BG_IMP_SPECIAL",
	HARVEST = "ICON_BTT_BG_HARVEST"
};


-- this will add 1 simple unlockable, i.e. only background and icon
function PopulateUnlockableSimple(tItem:table, instanceManager:table)
	--print("FUN PopulateUnlockableSimple"); dshowtable(tItem);

	local unlockInstance = instanceManager:GetInstance();

	-- background is taken from Kind
	unlockInstance.UnlockIcon:SetTexture( IconManager:FindIconAtlas(tBackgroundTextures[tItem.UnlockKind], 38) );
	
	-- the actual icon is taken from Type
	unlockInstance.Icon:SetIcon("ICON_"..tItem.UnlockType);
	unlockInstance.Icon:SetHide(false);
	
	-- tooltip
	unlockInstance.UnlockIcon:SetToolTipString(tItem.Description);

	-- civilopedia
	if not IsTutorialRunning() and tItem.PediaKey then
		unlockInstance.UnlockIcon:RegisterCallback(
			Mouse.eRClick,
			function() LuaEvents.OpenCivilopedia(tItem.PediaKey);
		end);
	end

end


function PopulateUnlockablesForCivic(playerID:number, civicID:number, kItemIM:table, kGovernmentIM:table, callback:ifunction, hideDescriptionIcon:boolean )
	--print("FUN PopulateUnlockablesForCivic (pid,cid,bhide)",playerID,civicID,hideDescriptionIcon);
	
	local civicInfo:table = GameInfo.Civics[civicID];
	if civicInfo == nil then
		print("ERROR: PopulateUnlockablesForCivic Unable to find a civic type in the database with an ID value of", civicID);
		return;
	end
	
	local sCivicType:string = civicInfo.CivicType;
	local iNumIcons:number = 0;
	
	-- I can block showing extra star by passing hideDescriptionIcon = true
	-- BUT: not all can be disabled unfortunately...
	-- must stay: other modifiers than spies, feature removal, adjacency bonuses
	-- we're gonna HIDE the star by default - it will only be shown if a record exists in m_kShowStar
	-- there's no flag like this in TechTree anyway, so no use doing it only for Civics
	
	iNumIcons = BTT_BASE_PopulateUnlockablesForCivic(playerID, civicID, kItemIM, kGovernmentIM, callback, hideDescriptionIcon );
	if iNumIcons == nil then iNumIcons = 0; end
	
	--print("Adding additional icons for", sCivicType);
	
	for _,item in ipairs( GetExtraUnlockables(sCivicType) ) do
		PopulateUnlockableSimple(item, kItemIM);
		iNumIcons = iNumIcons + 1;
	end
	
	kItemIM.m_ParentControl:CalculateSize();
	
	return iNumIcons;
end


-- ===========================================================================
--
-- ===========================================================================
function PopulateUnlockablesForTech(playerID:number, techID:number, instanceManager:table, callback:ifunction )
	--print("FUN PopulateUnlockablesForTech (pid,tid)",playerID,techID);

	local techInfo:table = GameInfo.Technologies[techID];
	if techInfo == nil then
		print("ERROR: PopulateUnlockablesForTech Unable to find a tech type in the database with an ID value of", techID);
		return;
	end
	
	local sTechType:string = techInfo.TechnologyType;
	local iNumIcons:number = 0;
	
	iNumIcons = BTT_BASE_PopulateUnlockablesForTech(playerID, techID, instanceManager, callback);
	if iNumIcons == nil then iNumIcons = 0; end
	
	--print("Adding additional icons for", sTechType);



	for _,item in ipairs( GetExtraUnlockables(sTechType) ) do
		PopulateUnlockableSimple(item, instanceManager);
		iNumIcons = iNumIcons + 1;
	end
	
	instanceManager.m_ParentControl:CalculateSize();
	
	return iNumIcons;
end


-- ===========================================================================
-- POPULATE EXTRA UNLOCKABLES
-- ===========================================================================

function PopulateHarvests()
	local sTT:string;
	local tHarvests:table = {};
	-- first, collate harvests of the same resource into 1 string
	for row in GameInfo.Resource_Harvests() do
		if row.PrereqTech ~= nil then -- support for mods that add harvests with no tech req
			if tHarvests[ row.PrereqTech ] == nil then tHarvests[ row.PrereqTech ] = {}; end -- init a new tech
			local tTechHarvests:table = tHarvests[ row.PrereqTech ];
			if tTechHarvests[ row.ResourceType ] == nil then
				-- init a new resource
				tTechHarvests[ row.ResourceType ] = "[ICON_"..row.ResourceType.."] "..LL(GameInfo.Resources[row.ResourceType].Name)..":"; --  don't put resource font icon, modded ones usually don't have it
			end
			tTechHarvests[ row.ResourceType ] = tTechHarvests[ row.ResourceType ]..string.format(" %+d", row.Amount)..GameInfo.Yields[row.YieldType].IconString;
		end
	end
		--if sDesc == nil then -- insert name as initial insert
			--sDesc = LL("LOC_UNITOPERATION_HARVEST_RESOURCE_DESCRIPTION")..": "..LL(GameInfo.Resources[row.ResourceType].Name); --  don't put resource font icon, modded ones usually don't have it
		--end
	-- second, add to the proper techs
	for tech,harvests in pairs(tHarvests) do
		-- create a collated tooltip
		local sTT:string = LL("LOC_UNITOPERATION_HARVEST_RESOURCE_DESCRIPTION");
		for _,tooltip in pairs(harvests) do sTT = sTT.."[NEWLINE]"..tooltip; end
		AddExtraUnlockable(tech, "HARVEST", "UNITOPERATION_HARVEST_RESOURCE", sTT, "WORLD_2");
	end
end

function PopulateFeatureRemovals()
	for row in GameInfo.Features() do
		if row.RemoveTech ~= nil then
			-- removable feature, build yields
			local sTT:string = LL("LOC_UNITOPERATION_REMOVE_FEATURE_DESCRIPTION")..": "..LL(row.Name);
			for yield in GameInfo.Feature_Removes() do
				if yield.FeatureType == row.FeatureType then
					sTT = sTT..string.format(" %+d", yield.Yield)..GameInfo.Yields[yield.YieldType].IconString;
				end
			end
			AddExtraUnlockable(row.RemoveTech, "HARVEST", "UNITOPERATION_REMOVE_FEATURE", sTT, row.FeatureType);
		end
	end
end


-- many improvements are unique to a Civ
-- must not show them unless the player is that Civ
-- must not show adjacencies for being next to them them unless the player is that Civ
function CanShowImprovement(sImprovementType:string)
	--print("FUN CanShowImprovement(imp)",sImprovementType);
	local imprInfo:table = GameInfo.Improvements[sImprovementType];
	if imprInfo == nil then return false; end -- assert
	if imprInfo.TraitType == nil then return true; end -- not unique
	if imprInfo.TraitType == "TRAIT_CIVILIZATION_NO_PLAYER" then return true; end -- generic for all players
--	if string.find(imprInfo.TraitType, "MINOR_CIV") then return false; end -- we may acquire that! ugly hack, but I don't to iterate LeaderTraits to check for 1 instance (Colossal Head)
	-- find civ
	if Game.GetLocalPlayer() == -1 then return true; end
	local sLocalPlayerCivType:string = PlayerConfigurations[ Game.GetLocalPlayer() ]:GetCivilizationTypeName();
	--print("checking trait for",sLocalPlayerCivType);
	local bCanShow:boolean = false;
	for row in GameInfo.CivilizationTraits() do
		-- true only if that's our improvement
		if row.TraitType == imprInfo.TraitType and row.CivilizationType == sLocalPlayerCivType then bCanShow = true; end
	end
	return bCanShow;
end

-- many districts are unique to a Civ
-- must not show adjacencies for being next to them them unless the player is that Civ
function CanShowDistrictAdjacency(sDistrictType:string)
	--print("FUN CanShowDistrictAdjacency(dis)",sDistrictType);
	local distInfo:table = GameInfo.Districts[sDistrictType];
	if distInfo == nil then return false; end -- assert
	if distInfo.TraitType == nil then return true; end -- not unique
	-- find civ
	if Game.GetLocalPlayer() == -1 then return true; end
	local sLocalPlayerCivType:string = PlayerConfigurations[ Game.GetLocalPlayer() ]:GetCivilizationTypeName();
	--print("checking trait for",sLocalPlayerCivType);
	local bCanShow:boolean = false;
	for row in GameInfo.CivilizationTraits() do
		-- true only if that's our improvement
		if row.TraitType == distInfo.TraitType and row.CivilizationType == sLocalPlayerCivType then bCanShow = true; end
	end
	return bCanShow;
end

function PopulateImprovementBonus()
	local sType:string, sDesc:string;
	for row in GameInfo.Improvement_BonusYieldChanges() do
		if     row.PrereqTech  then sType = row.PrereqTech;
		elseif row.PrereqCivic then sType = row.PrereqCivic;
		else -- error in configuration
		end
		if CanShowImprovement(row.ImprovementType) then
			sDesc = LL(GameInfo.Improvements[row.ImprovementType].Name)..": +"..tostring(row.BonusYieldChange)..GameInfo.Yields[row.YieldType].IconString;
			AddExtraUnlockable(sType, "IMPR_BONUS_"..row.YieldType, row.ImprovementType, sDesc, row.ImprovementType);
		end
	end
end

function PopulateImprovementAdjacency()
	local adjacency_yields = {};
	local has_bonus = {};
	for impradj in GameInfo.Improvement_Adjacencies() do
		if CanShowImprovement(impradj.ImprovementType) then
			for row in GameInfo.Adjacency_YieldChanges() do
				if row.ID == impradj.YieldChangeId and (row.PrereqTech ~= nil or row.PrereqCivic ~= nil) and row.ID ~= "Farms_MechanizedAdjacency" and row.ID ~= "Flood_Farms_MechanizedAdjacency" and row.ID ~= "JNR_WetFarm_MechanizedAdjacency" then
					-- ensures only adjacencies for being next to an improvement or district are shown
					if CanShowImprovement(row.AdjacentImprovement) or CanShowDistrictAdjacency(row.AdjacentDistrict) or (row.AdjacentImprovement == nil and row.AdjacentDistrict == nil) then
						-- this part analyzes a single adjacency bonus
						-- it uses code from Civilopedia Improvement page to build a dynamic tooltip
						local object;
						if(row.OtherDistrictAdjacent) then
							object = "LOC_TYPE_TRAIT_ADJACENT_OBJECT_DISTRICT";
						elseif(row.AdjacentResource) then
							object = "LOC_TYPE_TRAIT_ADJACENT_OBJECT_RESOURCE";
						elseif(row.AdjacentSeaResource) then
							object = "LOC_TYPE_TRAIT_ADJACENT_OBJECT_SEA_RESOURCE";
						elseif(row.AdjacentResourceClass ~= "NO_RESOURCECLASS") then
							if(row.AdjacentResourceClass == "RESOURCECLASS_BONUS") then
								object = "LOC_TOOLTIP_BONUS_RESOURCE";
							elseif(row.AdjacentResourceClass == "RESOURCECLASS_LUXURY") then
								object = "LOC_TOOLTIP_LUXURY_RESOURCE";
							elseif(row.AdjacentResourceClass == "RESOURCECLASS_STRATEGIC") then
								object = "LOC_TOOLTIP_BONUS_STRATEGIC";
							else
								object = "LOC_TYPE_TRAIT_ADJACENT_OBJECT_RESOURCE_CLASS";
							end
						elseif(row.AdjacentRiver) then
							object = "LOC_TYPE_TRAIT_ADJACENT_OBJECT_RIVER";
						elseif(row.AdjacentWonder) then
							object = "LOC_TYPE_TRAIT_ADJACENT_OBJECT_WONDER";
						elseif(row.AdjacentNaturalWonder) then
							object = "LOC_TYPE_TRAIT_ADJACENT_OBJECT_NATURAL_WONDER";
						elseif(row.AdjacentTerrain) then
							local terrain = GameInfo.Terrains[row.AdjacentTerrain];
							if(terrain) then
								object = terrain.Name;
							end
						elseif(row.AdjacentFeature) then
							local feature = GameInfo.Features[row.AdjacentFeature];
							if(feature) then
								object = feature.Name;
							end
						elseif(row.AdjacentImprovement) then
							local improvement = GameInfo.Improvements[row.AdjacentImprovement];
							if(improvement) then
								object = improvement.Name;
							end
						elseif(row.AdjacentDistrict) then		
							local district = GameInfo.Districts[row.AdjacentDistrict];
							if(district) then
								object = district.Name;
							end
						end

						local yield = GameInfo.Yields[row.YieldType];

						if(object and yield) then

							local key = (row.TilesRequired > 1) and "LOC_TYPE_TRAIT_ADJACENT_BONUS_PER" or "LOC_TYPE_TRAIT_ADJACENT_BONUS";

							local value = Locale.Lookup(key, row.YieldChange, yield.IconString, yield.Name, row.TilesRequired, object);

							--[[ Infixo: this part is not needed
							if(row.PrereqCivic or row.PrereqTech) then
								local item;
								if(row.PrereqCivic) then
									item = GameInfo.Civics[row.PrereqCivic];
								else
									item = GameInfo.Technologies[row.PrereqTech];
								end

								if(item) then
									local text = Locale.Lookup("LOC_TYPE_TRAIT_ADJACENT_BONUS_REQUIRES_TECH_OR_CIVIC", item.Name);
									value = value .. "  " .. text;
								end
							end
							--]]

							if(row.ObsoleteCivic or row.ObsoleteTech) then
								local item;
								if(row.ObsoleteCivic) then
									item = GameInfo.Civics[row.ObsoleteCivic];
								else
									item = GameInfo.Technologies[row.ObsoleteTech];
								end
							
								if(item) then
									local text = Locale.Lookup("LOC_TYPE_TRAIT_ADJACENT_BONUS_OBSOLETE_WITH_TECH_OR_CIVIC", item.Name);
									value = value .. "  " .. text;
								end
							end
						
							-- register a new icon
							local sTechCivic:string = row.PrereqTech;
							if row.PrereqCivic ~= nil then sTechCivic = row.PrereqCivic; end
							AddExtraUnlockable(sTechCivic, "IMPR_BONUS_"..row.YieldType, impradj.ImprovementType, LL(GameInfo.Improvements[impradj.ImprovementType].Name)..": "..value, impradj.ImprovementType);
						
						end -- object and yield
					end -- can show Adjacent
				end -- tech or civic not nil
			end -- adj
		end -- if can show
	end -- improvs
end

function GetModifierArgument(sModifierId:string, sName:string)
	for row in GameInfo.ModifierArguments() do
		if row.ModifierId == sModifierId and row.Name == sName then return row.Value; end
	end
	return nil;
end

function PopulateFromModifiers(sTreeKind:string)
	local sType:string, sDesc:string;
	for row in GameInfo[sTreeKind.."Modifiers"]() do
		sType = row[sTreeKind.."Type"];
		for mod in GameInfo.Modifiers() do
			if mod.ModifierId == row.ModifierId then
				if mod.ModifierType == "MODIFIER_PLAYER_GRANT_SPY" then
					sDesc = "+1 "..LL(GameInfo.Units["UNIT_SPY"].Name).." "..LL("LOC_BTT_CAPACITY");
					AddExtraUnlockable(sType, "OTHER", "UNIT_SPY", sDesc, "UNIT_SPY");
				elseif mod.ModifierType == "MODIFIER_PLAYER_ADJUST_EMBARKED_MOVEMENT"    then
					AddExtraUnlockable(sType, "COAST", "UNITOPERATION_MOVE_TO", LL("LOC_BTT_EMBARKED_MOVEMENT", GetModifierArgument(mod.ModifierId, "Amount")), "MOVEMENT_5");
				
				elseif mod.ModifierType == "MODIFIER_PLAYER_UNITS_ADJUST_SEA_MOVEMENT"   then
					AddExtraUnlockable(sType, "COAST", "UNITOPERATION_MOVE_TO", LL("LOC_BTT_ALL_NAVAL_UNITS_MOVEMENT", GetModifierArgument(mod.ModifierId, "Amount")), "MOVEMENT_4");
				
				else
					-- check for other modifiers here
				end
				break;
			end
		end
	end
end

function CanShowCustomTech(sUnlockableType:string)
	local unlockableTechInfo:table = GameInfo.TechSpecialUnlockables[sUnlockableType];
	if unlockableTechInfo == nil then return false; end -- assert
	if Game.GetLocalPlayer() == -1 then return true; end
	local sLocalPlayerCivType:string = PlayerConfigurations[ Game.GetLocalPlayer() ]:GetCivilizationTypeName();
	local sLocalPlayerLeaderType:string = PlayerConfigurations[ Game.GetLocalPlayer() ]:GetLeaderTypeName();
	for row in GameInfo.TechSpecialUnlockablesExcluded() do
		local techUnlockableTrait = row.TraitType;
		if row.Unlockable == sUnlockableType then
			for row in GameInfo.CivilizationTraits() do
				if row.TraitType == techUnlockableTrait and row.CivilizationType == sLocalPlayerCivType then return false; end
			end
			for row in GameInfo.LeaderTraits() do
				if row.TraitType == techUnlockableTrait and row.LeaderType == sLocalPlayerLeaderType then return false; end
			end;
		end
	end
	for row in GameInfo.CivicSpecialUnlockablesExcluded() do
		local civicUnlockableTrait = row.TraitType;
		if row.Unlockable == sUnlockableType then
			for row in GameInfo.CivilizationTraits() do
				if row.TraitType == civicUnlockableTrait and row.CivilizationType == sLocalPlayerCivType then return false; end
			end
			for row in GameInfo.LeaderTraits() do
				if row.TraitType == civicUnlockableTrait and row.LeaderType == sLocalPlayerLeaderType then return false; end
			end;
		end
	end
	if unlockableTechInfo.TraitType == nil then return true; end -- not unique
	local bCanShow:boolean = false;
	for row in GameInfo.CivilizationTraits() do
		if row.TraitType == unlockableTechInfo.TraitType and row.CivilizationType == sLocalPlayerCivType then bCanShow = true; end
	end
	for row in GameInfo.LeaderTraits() do
		if row.TraitType == unlockableTechInfo.TraitType and row.LeaderType == sLocalPlayerLeaderType then bCanShow = true; end
	end
	return bCanShow;
end

function CanShowCustomCivic(sUnlockableType:string)
	local unlockableCivicInfo:table = GameInfo.CivicSpecialUnlockables[sUnlockableType];
	if unlockableCivicInfo == nil then return false; end -- assert
	if Game.GetLocalPlayer() == -1 then return true; end
	local sLocalPlayerCivType:string = PlayerConfigurations[ Game.GetLocalPlayer() ]:GetCivilizationTypeName();
	local sLocalPlayerLeaderType:string = PlayerConfigurations[ Game.GetLocalPlayer() ]:GetLeaderTypeName();
	for row in GameInfo.TechSpecialUnlockablesExcluded() do
		local techUnlockableTrait = row.TraitType;
		if row.Unlockable == sUnlockableType then
			for row in GameInfo.CivilizationTraits() do
				if row.TraitType == techUnlockableTrait and row.CivilizationType == sLocalPlayerCivType then return false; end
			end
			for row in GameInfo.LeaderTraits() do
				if row.TraitType == techUnlockableTrait and row.LeaderType == sLocalPlayerLeaderType then return false; end
			end;
		end
	end
	for row in GameInfo.CivicSpecialUnlockablesExcluded() do
		local civicUnlockableTrait = row.TraitType;
		if row.Unlockable == sUnlockableType then
			for row in GameInfo.CivilizationTraits() do
				if row.TraitType == civicUnlockableTrait and row.CivilizationType == sLocalPlayerCivType then return false; end
			end
			for row in GameInfo.LeaderTraits() do
				if row.TraitType == civicUnlockableTrait and row.LeaderType == sLocalPlayerLeaderType then return false; end
			end;
		end
	end
	if unlockableCivicInfo.TraitType == nil then return true; end -- not unique
	local bCanShow:boolean = false;
	for row in GameInfo.CivilizationTraits() do
		if row.TraitType == unlockableCivicInfo.TraitType and row.CivilizationType == sLocalPlayerCivType then bCanShow = true; end
	end
	for row in GameInfo.LeaderTraits() do
		if row.TraitType == unlockableCivicInfo.TraitType and row.LeaderType == sLocalPlayerLeaderType then bCanShow = true; end
	end
	return bCanShow;
end

function PopulateFromCustom(sTreeKind:string)
	local sType:string, sDesc:string;
	for row in GameInfo[sTreeKind.."SpecialUnlockables"]() do
		if (sTreeKind == "Tech" and CanShowCustomTech(row.Unlockable)) or (sTreeKind == "Civic" and CanShowCustomCivic(row.Unlockable)) then
			sType = row["Prereq"..sTreeKind];
			sDescription = row["Description"];
			sBackground = row["Background"];
			sIcon = row["Icon"];
			sCivilopedia = row["Civilopedia"];
			AddExtraUnlockable(sType, sBackground, sIcon, LL(sDescription), sCivilopedia);
		end
	end
end

-- Unit Commands and Embarkment now added via custom unlocks table to set description text and visibility for civs more accurately.

-- 2019-04-09 UnitCommands
function PopulateUnitCommands(sPrereq:string)
	local sType:string, sDesc:string;
	for row in GameInfo.UnitCommands() do
		sType = row[sPrereq];
		if sType ~= nil then
			sDesc = LL(row.Description);
			AddExtraUnlockable(sType, "COMMAND", row.CommandType, sDesc, row.CommandType);
		end
	end
end

-- 2019-04-19 Embarkment
function PopulateEmbarkment(sTable:string, sType:string)
	--print("FUN PopulateEmbarkment", sTable, sType);
	for row in GameInfo[sTable]() do
		-- unit
		if row.EmbarkUnitType ~= nil then
			--print("...unit", row.EmbarkUnitType); dshowtable(row);
			AddExtraUnlockable(row[sType], "COAST", row.EmbarkUnitType, LL("LOC_UNITOPERATION_EMBARK_DESCRIPTION")..": "..LL(GameInfo.Units[row.EmbarkUnitType].Name), "MOVEMENT_5");
		end
		-- all units
		if row.EmbarkAll then
			--print("...all units"); dshowtable(row);
			AddExtraUnlockable(row[sType], "COAST", "BTT_ALL_UNITS", LL("LOC_BTT_EMBARK_ALL_UNITS"), "MOVEMENT_5");
		end
	end
end

function InitializeExtraUnlockablesForAll()
	PopulateHarvests();
	PopulateFeatureRemovals();
	PopulateImprovementBonus();
	PopulateImprovementAdjacency();
end

function InitializeExtraUnlockablesForTech()
	PopulateFromCustom("Tech");
	PopulateFromModifiers("Technology");
--	PopulateUnitCommands("PrereqTech");
--	PopulateEmbarkment("Technologies", "TechnologyType");
end

function InitializeExtraUnlockablesForCivic()
	PopulateFromCustom("Civic");
	PopulateFromModifiers("Civic");
--	PopulateUnitCommands("PrereqCivic");
--	PopulateEmbarkment("Civics", "CivicType");
end