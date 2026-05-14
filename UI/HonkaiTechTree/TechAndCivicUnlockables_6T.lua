-- ===========================================================================
--	Unlock Icon Sorting
--	Project 6T, JNR
-- Special Thanks: Dazz Aephiex
-- ===========================================================================

function GetUnlockableItems(playerId)
	
	local has_trait = GetTraitMapForPlayer(playerId);	-- Get the player trait map (expensive to calculate)

	local unlockables = {};
	
	for row in GameInfo.Governments() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.GovernmentType, row.Name, row.GovernmentType});
		end
	end

	for i, row in ipairs(DB.Query("SELECT * FROM Policies ORDER BY (CASE GovernmentSlotType WHEN 'SLOT_MILITARY' THEN 'A' WHEN 'SLOT_ECONOMIC' THEN 'B' WHEN 'SLOT_DIPLOMATIC' THEN 'C' WHEN 'SLOT_GREAT_PERSON' THEN 'Y' WHEN 'SLOT_WILDCARD' THEN 'Z' ELSE 'X_' + GovernmentSlotType END), Name")) do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.PolicyType, row.Name, row.PolicyType});
		end
	end

	for i, row in ipairs(DB.Query("SELECT * FROM Units ORDER BY (CASE FormationClass WHEN 'FORMATION_CLASS_NAVAL' THEN 'B' WHEN 'FORMATION_CLASS_AIR' THEN 'C' WHEN 'FORMATION_CLASS_SUPPORT' THEN 'D' WHEN 'FORMATION_CLASS_CIVILIAN' THEN 'E' ELSE 'A' END), Cost, Name")) do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.UnitType, row.Name, row.UnitType});
		end
	end
	
	for row in GameInfo.Districts() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.DistrictType, row.Name, row.DistrictType});
		end
	end

-- Buildings

	for i, row in ipairs(DB.Query("SELECT Buildings.*, Districts.Name FROM Buildings LEFT JOIN Districts ON Buildings.PrereqDistrict=Districts.DistrictType WHERE Buildings.IsWonder=0 AND Buildings.BuildingType NOT LIKE 'BUILDING_JNR_MODE_%' ORDER BY Districts.Name, Buildings.Cost, Buildings.Name")) do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.BuildingType, row.Name, row.BuildingType});
		end
	end
	
	for i, row in ipairs(DB.Query("SELECT Buildings.*, Districts.Name FROM Buildings LEFT JOIN Districts ON Buildings.PrereqDistrict=Districts.DistrictType WHERE Buildings.IsWonder=0 AND Buildings.BuildingType LIKE 'BUILDING_JNR_MODE_%' ORDER BY Districts.Name, Buildings.Cost, Buildings.Name")) do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.BuildingType, row.Name, row.BuildingType});
		end
	end
	
-- Projects - Projects to convert power plants or create strategic resource products (from Industry District Expansion mod) load first because they are affiliated with a building their icon should appear right next to
	
	for i, row in ipairs(DB.Query("SELECT * FROM Projects WHERE ProjectType LIKE '%_CONVERT_REACTOR_TO_%' ORDER BY PrereqDistrict, Cost, Name")) do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.ProjectType, row.Name, row.ProjectType});
		end
	end
	
	for i, row in ipairs(DB.Query("SELECT * FROM Projects WHERE ProjectType LIKE 'PROJECT_CREATE_PRODUCT_JNR_%' ORDER BY PrereqDistrict, Cost, Name")) do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.ProjectType, row.Name, row.ProjectType});
		end
	end
	
	for i, row in ipairs(DB.Query("SELECT * FROM Projects WHERE ProjectType NOT LIKE '%_CONVERT_REACTOR_TO_%' AND ProjectType NOT LIKE 'PROJECT_CREATE_PRODUCT_JNR_%' ORDER BY PrereqDistrict, Cost, Name")) do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.ProjectType, row.Name, row.ProjectType});
		end
	end

-- Wonders

	for i, row in ipairs(DB.Query("SELECT * FROM Buildings WHERE IsWonder=1 ORDER BY Name")) do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.BuildingType, row.Name, row.BuildingType});
		end
	end

	for row in GameInfo.Improvements() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.ImprovementType, row.Name, row.ImprovementType});
		end
	end
	
	if (GameInfo.Routes_XP2 ~= nil) then
		for row in GameInfo.Routes_XP2() do
			if(CanEverUnlock(has_trait, row)) then
				local baseTableRow = GameInfo.Routes[row.RouteType];
				if (baseTableRow ~= nil) then
					table.insert(unlockables, {row, row.RouteType, baseTableRow.Name, row.RouteType});
				end
			end
		end
	end
	
	for row in GameInfo.Resources() do
		if(CanEverUnlock(has_trait, row)) then
			table.insert(unlockables, {row, row.ResourceType, row.Name, row.ResourceType});
		end
	end
	
	for row in GameInfo.DiplomaticActions() do
		if(CanEverUnlock(has_trait, row)  and row.Name ~= nil) then
			table.insert(unlockables, {row, row.DiplomaticActionType, row.Name, row.CivilopediaKey});
		end
	end

	return unlockables;
end
