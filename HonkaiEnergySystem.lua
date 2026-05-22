-- ===========================================================================
-- 崩坏能 system - 核心逻辑控制 (Gameplay Context)
-- 负责：存储崩坏能、处理扣除请求、保存已解锁的科技节点
-- ===========================================================================
print(" --- | Honkai Energy System (Gameplay) Loaded! | ---")
include("HonkaiTechTree_Data")

local HonkaiTechCostCache = nil

function GetHonkaiTechCost(techType)
    if HonkaiTechCostCache == nil then
        HonkaiTechCostCache = {}
        local speedMultiplier = 100
        local gameSpeedType = GameConfiguration.GetGameSpeedType()
        if GameInfo.GameSpeeds[gameSpeedType] then
            speedMultiplier = GameInfo.GameSpeeds[gameSpeedType].CostMultiplier
        end
        if GetHonkaiTechTreeData ~= nil then
            for _, tech in ipairs(GetHonkaiTechTreeData()) do
                HonkaiTechCostCache[tech.Type] = math.ceil(tech.Cost * speedMultiplier / 100)
            end
        end
    end

    return HonkaiTechCostCache[techType] or 99999
end

function IsHonkaiTechUnlocked(playerID, techType)
    local pPlayer = Players[playerID]
    return pPlayer and (pPlayer:GetProperty("UNLOCKED_" .. techType) == 1)
end

-- ===========================================================================
-- 崩坏科技与 影子市政 映射表
-- ===========================================================================
local ShadowCivicMap = {
    ["HONKAI_TECH_PERCEPTION"] = "CIVIC_SHADOW_PERCEPTION",
    ["HONKAI_TECH_OMEN"] = "CIVIC_SHADOW_OMEN",
    ["HONKAI_TECH_PATHOLOGY"] = "CIVIC_SHADOW_PATHOLOGY",
    ["HONKAI_TECH_BASIC_TACTICS"] = "CIVIC_SHADOW_BASIC_TACTICS",
    ["HONKAI_TECH_ENERGY_CONTAINER"] = "CIVIC_SHADOW_ENERGY_CONTAINER",
    ["HONKAI_TECH_DESTINY_CLERGY"] = "CIVIC_SHADOW_DESTINY_CLERGY",
    ["HONKAI_TECH_NUN_FORMATION"] = "CIVIC_SHADOW_NUN_FORMATION",
    ["HONKAI_TECH_BASIC_ISOLATION"] = "CIVIC_SHADOW_BASIC_ISOLATION",
    ["HONKAI_TECH_ST_FREYA"] = "CIVIC_SHADOW_ST_FREYA",
    ["HONKAI_TECH_WEAPON_PROTOTYPE"] = "CIVIC_SHADOW_WEAPON_PROTOTYPE",
    ["HONKAI_TECH_STIGMATA_PROTOTYPE"] = "CIVIC_SHADOW_STIGMATA_PROTOTYPE",
    ["HONKAI_TECH_HONKAI_FURNACE"] = "CIVIC_SHADOW_HONKAI_FURNACE",
    ["HONKAI_TECH_SCHICKSAL_DOCTRINE"] = "CIVIC_SHADOW_SCHICKSAL_DOCTRINE",
    ["HONKAI_TECH_PRAYER_ROOM"] = "CIVIC_SHADOW_PRAYER_ROOM",
    ["HONKAI_TECH_HONKAI_CONDUCTION"] = "CIVIC_SHADOW_HONKAI_CONDUCTION",
    ["HONKAI_TECH_ATONEMENT_SYSTEM"] = "CIVIC_SHADOW_ATONEMENT_SYSTEM",
    ["HONKAI_TECH_KNIGHT_LEGACY"] = "CIVIC_SHADOW_KNIGHT_LEGACY",
    ["HONKAI_TECH_POWER_ARMOR"] = "CIVIC_SHADOW_POWER_ARMOR",
    ["HONKAI_TECH_VALKYRIE_ADVANCED"] = "CIVIC_SHADOW_VALKYRIE_ADVANCED",
    ["HONKAI_TECH_STIGMATA_SCREENING"] = "CIVIC_SHADOW_STIGMATA_SCREENING",
    ["HONKAI_TECH_GENE_TOXIN"] = "CIVIC_SHADOW_GENE_TOXIN",
    ["HONKAI_TECH_AE_MANUFACTURING"] = "CIVIC_SHADOW_AE_MANUFACTURING",
    ["HONKAI_TECH_SCHICKSAL_GEN4"] = "CIVIC_SHADOW_SCHICKSAL_GEN4",
    ["HONKAI_TECH_MANTIS_EXPERIMENT"] = "CIVIC_SHADOW_MANTIS_EXPERIMENT",
    ["HONKAI_TECH_HONKAI_REVERSE_ENGINEERING"] = "CIVIC_SHADOW_HONKAI_REVERSE_ENGINEERING",
    ["HONKAI_TECH_HEAVY_ARTILLERY_MECHA"] = "CIVIC_SHADOW_HEAVY_ARTILLERY_MECHA",
    ["HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY"] = "CIVIC_SHADOW_IMAGINARY_INTERFERENCE_THEORY",
    ["HONKAI_TECH_FISSION_REACTOR"] = "CIVIC_SHADOW_FISSION_REACTOR",
    ["HONKAI_TECH_GRAY_SERPENT_NETWORK"] = "CIVIC_SHADOW_GRAY_SERPENT_NETWORK",
    ["HONKAI_TECH_ABSOLUTE_THEOCRACY"] = "CIVIC_SHADOW_ABSOLUTE_THEOCRACY",
    ["HONKAI_TECH_STIGMATA_GENE_COMPLETION"] = "CIVIC_SHADOW_STIGMATA_GENE_COMPLETION",
    ["HONKAI_TECH_HONKAI_ISOLATION_DOME"] = "CIVIC_SHADOW_HONKAI_ISOLATION_DOME",
    ["HONKAI_TECH_FANG_IN_THE_SHADOWS"] = "CIVIC_SHADOW_FANG_IN_THE_SHADOWS",
    ["HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT"] = "CIVIC_SHADOW_GOD_SLAYER_ARMOR_DEPLOYMENT",
    ["HONKAI_TECH_FLOATING_ISLAND_TECH"] = "CIVIC_SHADOW_FLOATING_ISLAND_TECH",
    ["HONKAI_TECH_STIGMATA_PRINCIPLE"] = "CIVIC_SHADOW_STIGMATA_PRINCIPLE",
    ["HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS"] = "CIVIC_SHADOW_GREAT_ERUPTION_HYPOTHESIS",
    ["HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION"] = "CIVIC_SHADOW_VALKYRIE_BLOODLINE_PURIFICATION",
    ["HONKAI_TECH_CLERGY_PRIVILEGE"] = "CIVIC_SHADOW_CLERGY_PRIVILEGE",
    ["HONKAI_TECH_SOULLIQUOR_SMELTING"] = "CIVIC_SHADOW_SOULLIQUOR_SMELTING",
    ["HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION"] = "CIVIC_SHADOW_HONKAI_CRYSTAL_EXTRACTION",
    ["HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE"] = "CIVIC_SHADOW_GOD_SLAYER_ARMOR_PROTOTYPE",
    ["HONKAI_TECH_SCHICKSAL_ARMED_FORMATION"] = "CIVIC_SHADOW_SCHICKSAL_ARMED_FORMATION",
    ["HONKAI_TECH_TACTICAL_TITAN"] = "CIVIC_SHADOW_TACTICAL_TITAN",
    ["HONKAI_TECH_TITAN_PRODUCTION_LINE"] = "CIVIC_SHADOW_TITAN_PRODUCTION_LINE",
    ["HONKAI_TECH_SALT_LAKE_CORE"] = "CIVIC_SHADOW_SALT_LAKE_CORE",
    ["HONKAI_TECH_STIGMATA_PLAN_EXECUTION"] = "CIVIC_SHADOW_STIGMATA_PLAN_EXECUTION",
    ["HONKAI_TECH_ARAHATO_PROJECT"] = "CIVIC_SHADOW_ARAHATO_PROJECT",
    ["HONKAI_TECH_AE_AUTONOMOUS_DEFENSE"] = "CIVIC_SHADOW_AE_AUTONOMOUS_DEFENSE",
}

function GrantTechModifiers(playerID, techType)
    local pPlayer = Players[playerID]
    if not pPlayer then return end
    
    local shadowCivicType = ShadowCivicMap[techType]
    if shadowCivicType then
        local civicEntry = GameInfo.Civics[shadowCivicType]
        if civicEntry then
            local pCulture = pPlayer:GetCulture()
            if not pCulture:HasCivic(civicEntry.Index) then
                -- 【核心核心核心】终极核武：直接赋予市政，无视进度、无视前置、瞬间激活权限
                pCulture:SetCivic(civicEntry.Index, true)
                print("【崩坏桥接】已通过 SetCivic 强制激活影子市政权限：" .. shadowCivicType)
            end
        end
    end
end

-- 【安全加固】检查并补发所有已解锁的影子市政
function RestoreUnlockedTechs(playerID)
    print("【崩坏自检】正在为玩家 " .. playerID .. " 检查影子市政完整性...")
    for honkaiTech, shadowCivic in pairs(ShadowCivicMap) do
        if ExposedMembers.Honkai.IsUnlocked(playerID, honkaiTech) then
            GrantTechModifiers(playerID, honkaiTech)
        end
    end
end

-- ===========================================================================
-- 产出核心算法 (Calculations)
-- ===========================================================================

local HonkaiDistricts = {
    ["DISTRICT_SCHICKSAL_HQ"] = true, 
    ["DISTRICT_ANTI_ENTROPY_HQ"] = true, 
    ["DISTRICT_WORLD_SERPENT_HQ"] = true,
    ["DISTRICT_SCHICKSAL_BRANCH"] = true, 
    ["DISTRICT_ARMED_INDUSTRY"] = true, 
    ["DISTRICT_HIDDEN_RESEARCH"] = true
}

local HONKAI_REUNION_PROJECT = "PROJECT_HOH_HONKAI_REUNION_REACTION"
local HONKAI_KNIGHT_OATH_POLICY = "POLICY_HOH_KNIGHT_OATH"

local FeatureDistrictEnergyBase = {
    ["DISTRICT_SCHICKSAL_BRANCH"] = 1,
    ["DISTRICT_ARMED_INDUSTRY"] = 1
}

local KnightOathAbilityTypes = {
    "ABILITY_HOH_KNIGHT_OATH_WALLS",
    "ABILITY_HOH_KNIGHT_OATH_CASTLE",
    "ABILITY_HOH_KNIGHT_OATH_STAR_FORT"
}

local KnightOathAbilityByWallLevel = {
    [1] = "ABILITY_HOH_KNIGHT_OATH_WALLS",
    [2] = "ABILITY_HOH_KNIGHT_OATH_CASTLE",
    [3] = "ABILITY_HOH_KNIGHT_OATH_STAR_FORT"
}

local EncampmentBuildingCache = nil
local WallBuildingCache = nil

function CalculateHonkaiEnergyCapacity(playerID)
    local pPlayer = Players[playerID]
    if not pPlayer then return 0 end

    if EncampmentBuildingCache == nil then
        EncampmentBuildingCache = {}
        WallBuildingCache = {}
        for building in GameInfo.Buildings() do
            if building.PrereqDistrict == "DISTRICT_ENCAMPMENT" then
                EncampmentBuildingCache[building.Index] = true
            end
            if building.BuildingType == "BUILDING_WALLS" or building.BuildingType == "BUILDING_CASTLE" or building.BuildingType == "BUILDING_STAR_FORT" then
                WallBuildingCache[building.Index] = true
            end
        end
    end

    local capacity = 0
    local encampment = GameInfo.Districts["DISTRICT_ENCAMPMENT"]
    local energyPool = GameInfo.Buildings["BUILDING_HOH_ENERGY_POOL"]

    local pCities = pPlayer:GetCities()
    for _, pCity in pCities:Members() do
        capacity = capacity + 50

        if encampment and pCity:GetDistricts():HasDistrict(encampment.Index) then
            capacity = capacity + 100
        end

        local pCityBuildings = pCity:GetBuildings()
        for buildingIndex, _ in pairs(EncampmentBuildingCache) do
            if pCityBuildings:HasBuilding(buildingIndex) then
                capacity = capacity + 100
            end
        end
        for buildingIndex, _ in pairs(WallBuildingCache) do
            if pCityBuildings:HasBuilding(buildingIndex) then
                capacity = capacity + 50
            end
        end

        if energyPool and pCityBuildings:HasBuilding(energyPool.Index) then
            capacity = capacity + 1000
        end
    end

    return capacity
end

function CountCityDistricts(pCity)
    local pCityDistricts = pCity:GetDistricts()
    if not pCityDistricts then return 0 end

    if type(pCityDistricts.GetNumDistricts) == "function" then
        return pCityDistricts:GetNumDistricts()
    end

    local count = 0
    if type(pCityDistricts.HasDistrict) == "function" then
        for district in GameInfo.Districts() do
            if pCityDistricts:HasDistrict(district.Index) then
                count = count + 1
            end
        end
    end
    return count
end

function GetUnlockedHonkaiTechCount(playerID)
    local techCount = 0
    for honkaiTech, _ in pairs(ShadowCivicMap) do
        if IsHonkaiTechUnlocked(playerID, honkaiTech) then
            techCount = techCount + 1
        end
    end
    return techCount
end

function AddCountedDetail(details, typeName, name)
    for _, detail in ipairs(details) do
        if detail.Type == typeName then
            detail.Count = detail.Count + 1
            return
        end
    end
    table.insert(details, { Type = typeName, Name = name, Count = 1, Yield = 0 })
end

function ApplyPerItemYield(details, perItemYield)
    for _, detail in ipairs(details) do
        detail.Yield = detail.Count * perItemYield
    end
end

function CalculateCityEnergyFormula(playerID, pCity)
    local details = {
        CityID = pCity:GetID(),
        CityName = Locale.Lookup(pCity:GetName()),
        PlotCount = 0,
        Population = pCity:GetPopulation(),
        ImprovementCount = 0,
        DistrictCount = 0,
        BuildingCount = 0,
        ImprovementDetails = {},
        DistrictDetails = {},
        BuildingDetails = {},
        TerritoryBase = 0,
        PopulationMultiplier = 0,
        BaseYield = 0,
        PerInfrastructureYield = 0,
        BuildingYield = 0,
        ImprovementYield = 0,
        DistrictYield = 0,
        InfrastructureMultiplier = 0,
        FormulaYield = 0
    }

    local cityX = pCity:GetX()
    local cityY = pCity:GetY()
    for dx = -3, 3 do
        for dy = -3, 3 do
            local pPlot = Map.GetPlotXYWithRangeCheck(cityX, cityY, dx, dy, 3)
            if pPlot and pPlot:GetOwner() == playerID then
                details.PlotCount = details.PlotCount + 1

                local improvementIndex = pPlot:GetImprovementType()
                if improvementIndex ~= -1 then
                    details.ImprovementCount = details.ImprovementCount + 1
                    local improvement = GameInfo.Improvements[improvementIndex]
                    local improvementType = improvement and improvement.ImprovementType or ("IMPROVEMENT_" .. tostring(improvementIndex))
                    local improvementName = improvement and Locale.Lookup(improvement.Name) or improvementType
                    AddCountedDetail(details.ImprovementDetails, improvementType, improvementName)
                end
            end
        end
    end

    local pCityDistricts = pCity:GetDistricts()
    if pCityDistricts and type(pCityDistricts.HasDistrict) == "function" then
        for district in GameInfo.Districts() do
            if pCityDistricts:HasDistrict(district.Index) then
                details.DistrictCount = details.DistrictCount + 1
                AddCountedDetail(details.DistrictDetails, district.DistrictType, Locale.Lookup(district.Name))
            end
        end
    else
        details.DistrictCount = CountCityDistricts(pCity)
    end

    local pCityBuildings = pCity:GetBuildings()
    for building in GameInfo.Buildings() do
        if pCityBuildings:HasBuilding(building.Index) then
            details.BuildingCount = details.BuildingCount + 1
            AddCountedDetail(details.BuildingDetails, building.BuildingType, Locale.Lookup(building.Name))
        end
    end

    details.TerritoryBase = details.PlotCount * 0.1
    details.PopulationMultiplier = 1 + (details.Population * 0.05)
    details.BaseYield = details.TerritoryBase * details.PopulationMultiplier
    details.PerInfrastructureYield = details.BaseYield * 0.02

    ApplyPerItemYield(details.BuildingDetails, details.PerInfrastructureYield)
    ApplyPerItemYield(details.ImprovementDetails, details.PerInfrastructureYield)
    ApplyPerItemYield(details.DistrictDetails, details.PerInfrastructureYield)

    details.BuildingYield = details.PerInfrastructureYield * details.BuildingCount
    details.ImprovementYield = details.PerInfrastructureYield * details.ImprovementCount
    details.DistrictYield = details.PerInfrastructureYield * details.DistrictCount
    details.InfrastructureMultiplier = 1 + ((details.DistrictCount + details.BuildingCount + details.ImprovementCount) * 0.02)
    details.FormulaYield = details.BaseYield * details.InfrastructureMultiplier

    return details
end

function GetCityCurrentProjectType(pCity)
    if pCity == nil then return nil end
    -- Gameplay Lua 的 BuildQueue API 不完整，通过 UI 上下文桥接查询
    if ExposedMembers.HonkaiUI and ExposedMembers.HonkaiUI.GetCityCurrentProject then
        local ok, result = pcall(ExposedMembers.HonkaiUI.GetCityCurrentProject, pCity:GetOwner(), pCity:GetID())
        return ok and result or nil
    end
    return nil
end

function GetCityProductionYield(pCity)
    if pCity == nil or type(pCity.GetYield) ~= "function" then return 0 end

    if YieldTypes ~= nil and YieldTypes.PRODUCTION ~= nil then
        return pCity:GetYield(YieldTypes.PRODUCTION) or 0
    end

    local productionYield = GameInfo.Yields and GameInfo.Yields["YIELD_PRODUCTION"] or nil
    if productionYield ~= nil then
        return pCity:GetYield(productionYield.Index) or 0
    end

    return 0
end

function CalculateHonkaiProjectEnergyBonus(playerID, pCity)
    if not IsHonkaiTechUnlocked(playerID, "HONKAI_TECH_HONKAI_FURNACE") then
        return 0
    end

    if GetCityCurrentProjectType(pCity) ~= HONKAI_REUNION_PROJECT then
        return 0
    end

    return GetCityProductionYield(pCity)
end

function HasCityDistrict(pCity, districtType)
    local districtInfo = GameInfo.Districts[districtType]
    if pCity == nil or districtInfo == nil then return false end

    local pCityDistricts = pCity:GetDistricts()
    return pCityDistricts ~= nil and type(pCityDistricts.HasDistrict) == "function" and pCityDistricts:HasDistrict(districtInfo.Index)
end

function GetCityFeatureDistrictEnergyBase(pCity)
    local base = 0
    for districtType, amount in pairs(FeatureDistrictEnergyBase) do
        if HasCityDistrict(pCity, districtType) then
            base = base + amount
        end
    end
    return base
end

function CalculateHonkaiTradeRouteEnergyBonus(playerID, pCity)
    if not IsHonkaiTechUnlocked(playerID, "HONKAI_TECH_HONKAI_CONDUCTION") then
        return 0, 0, 0
    end

    local cityBase = GetCityFeatureDistrictEnergyBase(pCity)
    if pCity == nil then return 0, 0, cityBase end

    -- Gameplay Lua 的 GetTrade API 不可用，通过 UI 上下文桥接查询国内商路数
    local domesticRouteCount = 0
    if ExposedMembers.HonkaiUI and ExposedMembers.HonkaiUI.GetCityDomesticTradeRouteCount then
        local ok, count = pcall(ExposedMembers.HonkaiUI.GetCityDomesticTradeRouteCount, playerID, pCity:GetID())
        domesticRouteCount = (ok and count) or 0
    end

    local bonus = domesticRouteCount * cityBase
    return bonus, domesticRouteCount, cityBase
end

function CountCitySpecialists(pCity)
    if pCity == nil or type(pCity.GetOwnedPlots) ~= "function" then return 0 end

    local total = 0
    local pCityPlots = pCity:GetOwnedPlots() or {}
    for _, pPlot in ipairs(pCityPlots) do
        if pPlot ~= nil and type(pPlot.GetDistrictType) == "function" and type(pPlot.GetWorkerCount) == "function" then
            local districtIndex = pPlot:GetDistrictType()
            if districtIndex ~= nil and districtIndex ~= -1 then
                local districtInfo = GameInfo.Districts[districtIndex]
                if districtInfo ~= nil and districtInfo.DistrictType ~= "DISTRICT_CITY_CENTER" then
                    total = total + (pPlot:GetWorkerCount() or 0)
                end
            end
        end
    end

    return total
end

function CalculateHonkaiSpecialistResearchBonus(playerID, pCity)
    if not IsHonkaiTechUnlocked(playerID, "HONKAI_TECH_STIGMATA_PROTOTYPE") then
        return 0, 0
    end

    local specialistCount = CountCitySpecialists(pCity)
    return specialistCount * 0.1, specialistCount
end

function CalculateHonkaiEnergyBreakdown(playerID)
    local pPlayer = Players[playerID]
    if not pPlayer then return nil end

    local breakdown = {
        CityDetails = {},
        TechModifier = 0,
        TechCount = 0,
        ActivationBonus = 0,
        CoreBonus = 0,
        TotalYield = 0,
        SubtotalFromCities = 0
    }

    if not IsHonkaiTechUnlocked(playerID, "HONKAI_TECH_PERCEPTION") then
        return breakdown
    end

    -- 1. 遍历城市计算基础产出
    local pCities = pPlayer:GetCities()
    for _, pCity in pCities:Members() do
        local cityDetails = CalculateCityEnergyFormula(playerID, pCity)
        cityDetails.ProjectBonus = CalculateHonkaiProjectEnergyBonus(playerID, pCity)
        cityDetails.TradeRouteBonus, cityDetails.DomesticTradeRouteCount, cityDetails.FeatureDistrictTradeBase = CalculateHonkaiTradeRouteEnergyBonus(playerID, pCity)

        local cityTotal = cityDetails.FormulaYield + cityDetails.ProjectBonus + cityDetails.TradeRouteBonus
        breakdown.CityDetails[cityDetails.CityName] = cityTotal
        breakdown.SubtotalFromCities = breakdown.SubtotalFromCities + cityTotal
    end

    -- 2. 科技加成 (每个科技 +5%)
    local pCapital = pCities:GetCapitalCity()
    if pCapital then
        local capitalName = Locale.Lookup(pCapital:GetName())
        breakdown.ActivationBonus = 2
        breakdown.CityDetails[capitalName] = (breakdown.CityDetails[capitalName] or 0) + breakdown.ActivationBonus
        breakdown.SubtotalFromCities = breakdown.SubtotalFromCities + breakdown.ActivationBonus
    end

    local techCount = GetUnlockedHonkaiTechCount(playerID)
    breakdown.TechCount = techCount
    breakdown.TechModifier = techCount * 0.05
    
    -- 3. 律者核心加成
    breakdown.CoreBonus = pPlayer:GetProperty("HONKAI_CORE_YIELD_BONUS") or 0

    -- 最终计算：(城市总和 * (1 + 科技加成)) + 核心加成
    breakdown.TotalYield = (breakdown.SubtotalFromCities * (1 + breakdown.TechModifier)) + breakdown.CoreBonus

    return breakdown
end

function CalculateHonkaiCityEnergyBreakdown(playerID, cityID)
    local pPlayer = Players[playerID]
    if not pPlayer then return nil end

    local pCity = pPlayer:GetCities():FindID(cityID)
    if not pCity then return nil end

    local details = CalculateCityEnergyFormula(playerID, pCity)
    details.IsUnlocked = IsHonkaiTechUnlocked(playerID, "HONKAI_TECH_PERCEPTION")
    if not details.IsUnlocked then
        details.ActivationBonus = 0
        details.ProjectBonus = 0
        details.TradeRouteBonus = 0
        details.DomesticTradeRouteCount = 0
        details.FeatureDistrictTradeBase = 0
        details.TechCount = 0
        details.TechModifier = 0
        details.CoreBonus = pPlayer:GetProperty("HONKAI_CORE_YIELD_BONUS") or 0
        details.TotalBeforeTech = 0
        details.TotalYield = 0
        return details
    end

    local pCapital = pPlayer:GetCities():GetCapitalCity()
    details.ActivationBonus = (pCapital and pCapital:GetID() == cityID) and 2 or 0
    details.ProjectBonus = CalculateHonkaiProjectEnergyBonus(playerID, pCity)
    details.TradeRouteBonus, details.DomesticTradeRouteCount, details.FeatureDistrictTradeBase = CalculateHonkaiTradeRouteEnergyBonus(playerID, pCity)
    details.TechCount = GetUnlockedHonkaiTechCount(playerID)
    details.TechModifier = details.TechCount * 0.05
    details.CoreBonus = pPlayer:GetProperty("HONKAI_CORE_YIELD_BONUS") or 0
    details.TotalBeforeTech = details.FormulaYield + details.ActivationBonus + details.ProjectBonus + details.TradeRouteBonus
    details.TotalYield = details.TotalBeforeTech * (1 + details.TechModifier)

    return details
end

function CalculateHonkaiResearchBreakdown(playerID)
    local pPlayer = Players[playerID]
    if not pPlayer then return nil end

    local breakdown = {
        CityDetails = {},
        SpecialistDetails = {},
        TotalYield = 0,
        BaseYield = 10 -- 基础还是给 10 点，保证前期能跑动
    }

    local pCities = pPlayer:GetCities()
    for _, pCity in pCities:Members() do
        local cityName = Locale.Lookup(pCity:GetName())
        local cityResearch = 0
        
        -- 扫描建筑产出：凡是属于崩坏特色区域的建筑，每个提供 2 点研究点
        local pCityBuildings = pCity:GetBuildings()
        for row in GameInfo.Buildings() do
            if pCityBuildings:HasBuilding(row.Index) then
                local districtType = row.PrereqDistrict
                if districtType and HonkaiDistricts[districtType] then
                    cityResearch = cityResearch + 2
                end
            end
        end

        local specialistResearch, specialistCount = CalculateHonkaiSpecialistResearchBonus(playerID, pCity)
        if specialistResearch > 0 then
            cityResearch = cityResearch + specialistResearch
            breakdown.SpecialistDetails[cityName] = {
                Count = specialistCount,
                Yield = specialistResearch
            }
        end

        -- 崩坏能逆向解析：每座武装工造区额外 +2 崩坏研究点
        if IsHonkaiTechUnlocked(playerID, "HONKAI_TECH_HONKAI_REVERSE_ENGINEERING") then
            if HasCityDistrict(pCity, "DISTRICT_ARMED_INDUSTRY") then
                cityResearch = cityResearch + 2
            end
        end

        if cityResearch > 0 then
            breakdown.CityDetails[cityName] = cityResearch
            breakdown.TotalYield = breakdown.TotalYield + cityResearch
        end
    end

    breakdown.TotalYield = breakdown.TotalYield + breakdown.BaseYield
    return breakdown
end

local VALKYRIE_TRAINING_BASE_LEVEL = 1
local VALKYRIE_TRAINING_MAX_LEVEL = 10

local ValkyrieEmpireTrainingTechSources = {
    { TechType = "HONKAI_TECH_VALKYRIE_ADVANCED", Amount = 1, NameTag = "LOC_HONKAI_TECH_VALKYRIE_ADVANCED_NAME", FallbackName = "女武神进阶教材" },
    { TechType = "HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION", Amount = 1, NameTag = "LOC_HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION_NAME", FallbackName = "女武神血脉提纯" },
}

local ValkyrieCityTrainingBuildingSources = {
    { BuildingType = "BUILDING_HOH_ST_FREYA", EmpireAmount = 2, CityAmount = 2, FallbackName = "圣芙蕾雅学园" },
}

function ClampValkyrieTrainingLevel(level)
    if level < VALKYRIE_TRAINING_BASE_LEVEL then
        return VALKYRIE_TRAINING_BASE_LEVEL
    end
    if level > VALKYRIE_TRAINING_MAX_LEVEL then
        return VALKYRIE_TRAINING_MAX_LEVEL
    end
    return level
end

function LookupHonkaiText(tag, fallback)
    if tag ~= nil then
        local localized = Locale.Lookup(tag)
        if localized ~= nil and localized ~= "" and localized ~= tag then
            return localized
        end
    end
    return fallback or tag or ""
end

function GetBuildingDisplayName(buildingType, fallback)
    local building = GameInfo.Buildings[buildingType]
    if building and building.Name then
        return LookupHonkaiText(building.Name, fallback or buildingType)
    end
    return fallback or buildingType
end

function AddValkyrieTrainingSource(sourceList, sourceType, name, amount)
    table.insert(sourceList, {
        SourceType = sourceType,
        Name = name,
        Amount = amount
    })
end

function CalculateValkyrieTrainingBreakdown(playerID)
    local pPlayer = Players[playerID]
    if not pPlayer then return nil end

    local breakdown = {
        BaseLevel = VALKYRIE_TRAINING_BASE_LEVEL,
        MaxLevel = VALKYRIE_TRAINING_MAX_LEVEL,
        EmpireBonus = 0,
        EmpireRawLevel = VALKYRIE_TRAINING_BASE_LEVEL,
        EmpireLevel = VALKYRIE_TRAINING_BASE_LEVEL,
        EmpireSources = {},
        CityDetails = {}
    }

    for _, source in ipairs(ValkyrieEmpireTrainingTechSources) do
        if IsHonkaiTechUnlocked(playerID, source.TechType) then
            local sourceName = LookupHonkaiText(source.NameTag, source.FallbackName)
            breakdown.EmpireBonus = breakdown.EmpireBonus + source.Amount
            AddValkyrieTrainingSource(breakdown.EmpireSources, "TECH", sourceName, source.Amount)
        end
    end

    local globalBuildingSourcesApplied = {}
    local pCities = pPlayer:GetCities()
    for _, pCity in pCities:Members() do
        local cityDetail = {
            CityID = pCity:GetID(),
            CityName = Locale.Lookup(pCity:GetName()),
            CityBonus = 0,
            RawFinalLevel = VALKYRIE_TRAINING_BASE_LEVEL,
            FinalLevel = VALKYRIE_TRAINING_BASE_LEVEL,
            Sources = {}
        }

        local pCityBuildings = pCity:GetBuildings()
        for _, source in ipairs(ValkyrieCityTrainingBuildingSources) do
            local building = GameInfo.Buildings[source.BuildingType]
            if building and pCityBuildings:HasBuilding(building.Index) then
                local sourceName = GetBuildingDisplayName(source.BuildingType, source.FallbackName)

                if source.EmpireAmount and source.EmpireAmount ~= 0 and not globalBuildingSourcesApplied[source.BuildingType] then
                    globalBuildingSourcesApplied[source.BuildingType] = true
                    breakdown.EmpireBonus = breakdown.EmpireBonus + source.EmpireAmount
                    AddValkyrieTrainingSource(breakdown.EmpireSources, "BUILDING_EMPIRE", sourceName, source.EmpireAmount)
                end

                if source.CityAmount and source.CityAmount ~= 0 then
                    cityDetail.CityBonus = cityDetail.CityBonus + source.CityAmount
                    AddValkyrieTrainingSource(cityDetail.Sources, "BUILDING_CITY", sourceName, source.CityAmount)
                end
            end
        end

        table.insert(breakdown.CityDetails, cityDetail)
    end

    breakdown.EmpireRawLevel = breakdown.BaseLevel + breakdown.EmpireBonus
    breakdown.EmpireLevel = ClampValkyrieTrainingLevel(breakdown.EmpireRawLevel)

    for _, cityDetail in ipairs(breakdown.CityDetails) do
        cityDetail.EmpireLevel = breakdown.EmpireLevel
        cityDetail.RawFinalLevel = breakdown.EmpireLevel + cityDetail.CityBonus
        cityDetail.FinalLevel = ClampValkyrieTrainingLevel(cityDetail.RawFinalLevel)
    end

    return breakdown
end

local VALKYRIE_UNIT_TYPES = {
    ["UNIT_HOH_VALKYRIE_MK1"] = true,
}

function IsHonkaiValkyrieUnit(pUnit)
    if pUnit == nil then return false end

    local unitInfo = GameInfo.Units[pUnit:GetType()]
    return unitInfo ~= nil and VALKYRIE_UNIT_TYPES[unitInfo.UnitType] == true
end

function IsHonkaiPolicyActive(playerID, policyType)
    local pPlayer = Players[playerID]
    local policyInfo = GameInfo.Policies[policyType]
    if pPlayer == nil or policyInfo == nil then return false end

    local pCulture = pPlayer:GetCulture()
    if pCulture ~= nil and type(pCulture.IsPolicyActive) == "function" then
        return pCulture:IsPolicyActive(policyInfo.Index)
    end

    return false
end

function SetUnitAbilityCount(pUnit, abilityType, targetCount)
    if pUnit == nil or abilityType == nil or type(pUnit.GetAbility) ~= "function" then return end

    local pUnitAbility = pUnit:GetAbility()
    if pUnitAbility == nil or type(pUnitAbility.ChangeAbilityCount) ~= "function" then return end

    local currentCount = 0
    if type(pUnitAbility.GetAbilityCount) == "function" then
        currentCount = pUnitAbility:GetAbilityCount(abilityType) or 0
    end

    local delta = (targetCount or 0) - currentCount
    if delta ~= 0 then
        pUnitAbility:ChangeAbilityCount(abilityType, delta)
    end
end

function ClearKnightOathAbilities(pUnit)
    for _, abilityType in ipairs(KnightOathAbilityTypes) do
        SetUnitAbilityCount(pUnit, abilityType, 0)
    end
end

function GetCityWallLevel(pCity)
    if pCity == nil then return 0 end

    local pCityBuildings = pCity:GetBuildings()
    if pCityBuildings == nil then return 0 end

    local starFort = GameInfo.Buildings["BUILDING_STAR_FORT"]
    if starFort ~= nil and pCityBuildings:HasBuilding(starFort.Index) then
        return 3
    end

    local castle = GameInfo.Buildings["BUILDING_CASTLE"]
    if castle ~= nil and pCityBuildings:HasBuilding(castle.Index) then
        return 2
    end

    local walls = GameInfo.Buildings["BUILDING_WALLS"]
    if walls ~= nil and pCityBuildings:HasBuilding(walls.Index) then
        return 1
    end

    return 0
end

function FindCityOwningPlot(playerID, pPlot)
    if pPlot == nil then return nil end

    if Cities ~= nil and type(Cities.GetPlotPurchaseCity) == "function" then
        local ok, pCity = pcall(Cities.GetPlotPurchaseCity, pPlot)
        if ok and pCity ~= nil and pCity:GetOwner() == playerID then
            return pCity
        end

        if type(pPlot.GetX) == "function" and type(pPlot.GetY) == "function" then
            ok, pCity = pcall(Cities.GetPlotPurchaseCity, pPlot:GetX(), pPlot:GetY())
            if ok and pCity ~= nil and pCity:GetOwner() == playerID then
                return pCity
            end
        end
    end

    local pPlayer = Players[playerID]
    if pPlayer == nil then return nil end

    local plotX = type(pPlot.GetX) == "function" and pPlot:GetX() or nil
    local plotY = type(pPlot.GetY) == "function" and pPlot:GetY() or nil
    for _, pCity in pPlayer:GetCities():Members() do
        if plotX ~= nil and plotY ~= nil and pCity:GetX() == plotX and pCity:GetY() == plotY then
            return pCity
        end

        if type(pCity.GetOwnedPlots) == "function" then
            for _, pCityPlot in ipairs(pCity:GetOwnedPlots() or {}) do
                if pCityPlot == pPlot then
                    return pCity
                end
                if plotX ~= nil and plotY ~= nil and type(pCityPlot.GetX) == "function" and type(pCityPlot.GetY) == "function" and pCityPlot:GetX() == plotX and pCityPlot:GetY() == plotY then
                    return pCity
                end
            end
        end
    end

    return nil
end

function FindOwningCityForUnit(playerID, pUnit)
    if pUnit == nil or type(pUnit.GetX) ~= "function" or type(pUnit.GetY) ~= "function" then return nil end

    local pPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
    return FindCityOwningPlot(playerID, pPlot)
end

function ApplyKnightOathToUnit(playerID, unitID)
    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if pUnit == nil or not IsHonkaiValkyrieUnit(pUnit) then return end

    ClearKnightOathAbilities(pUnit)

    if not IsHonkaiPolicyActive(playerID, HONKAI_KNIGHT_OATH_POLICY) then
        return
    end

    local pCity = FindOwningCityForUnit(playerID, pUnit)
    local wallLevel = GetCityWallLevel(pCity)
    local abilityType = KnightOathAbilityByWallLevel[wallLevel]
    if abilityType ~= nil then
        SetUnitAbilityCount(pUnit, abilityType, 1)
    end
end

function RefreshKnightOathForPlayer(playerID)
    local pPlayer = Players[playerID]
    if pPlayer == nil then return end

    for _, pUnit in pPlayer:GetUnits():Members() do
        ApplyKnightOathToUnit(playerID, pUnit:GetID())
    end
end

local ValkyrieRankOrder = {
    { Rank = "F", Name = "F级", AbilityType = "ABILITY_HOH_VALKYRIE_RANK_F", CombatBonus = 0 },
    { Rank = "E", Name = "E级", AbilityType = "ABILITY_HOH_VALKYRIE_RANK_E", CombatBonus = 1 },
    { Rank = "D", Name = "D级", AbilityType = "ABILITY_HOH_VALKYRIE_RANK_D", CombatBonus = 2 },
    { Rank = "C", Name = "C级", AbilityType = "ABILITY_HOH_VALKYRIE_RANK_C", CombatBonus = 3 },
    { Rank = "B", Name = "B级", AbilityType = "ABILITY_HOH_VALKYRIE_RANK_B", CombatBonus = 5 },
    { Rank = "A", Name = "A级", AbilityType = "ABILITY_HOH_VALKYRIE_RANK_A", CombatBonus = 8 },
    { Rank = "S", Name = "S级", AbilityType = "ABILITY_HOH_VALKYRIE_RANK_S", CombatBonus = 12 },
}

local ValkyrieRankByID = {}
for _, rankInfo in ipairs(ValkyrieRankOrder) do
    ValkyrieRankByID[rankInfo.Rank] = rankInfo
end

-- 概率以 1000 为总权重，方便表达 0.1% 这类小概率。
local ValkyrieRankProbabilityByTrainingLevel = {
    [1] = { F = 400, E = 300, D = 150, C = 100, B = 40, A = 9, S = 1 },
    [2] = { F = 250, E = 300, D = 200, C = 150, B = 80, A = 18, S = 2 },
    [3] = { F = 150, E = 250, D = 250, C = 200, B = 110, A = 35, S = 5 },
    [4] = { F = 80, E = 180, D = 270, C = 250, B = 160, A = 50, S = 10 },
    [5] = { F = 30, E = 120, D = 250, C = 280, B = 220, A = 80, S = 20 },
    [6] = { F = 0, E = 80, D = 180, C = 300, B = 280, A = 120, S = 40 },
    [7] = { F = 0, E = 0, D = 100, C = 300, B = 350, A = 180, S = 70 },
    [8] = { F = 0, E = 0, D = 0, C = 0, B = 300, A = 500, S = 200 },
    [9] = { F = 0, E = 0, D = 0, C = 0, B = 150, A = 550, S = 300 },
    [10] = { F = 0, E = 0, D = 0, C = 0, B = 0, A = 600, S = 400 },
}

function CopyValkyrieRankInfo(rankInfo, weight, totalWeight)
    if rankInfo == nil then return nil end

    local percent = 0
    if totalWeight and totalWeight > 0 and weight ~= nil then
        percent = (weight * 100) / totalWeight
    end

    return {
        Rank = rankInfo.Rank,
        Name = rankInfo.Name,
        AbilityType = rankInfo.AbilityType,
        CombatBonus = rankInfo.CombatBonus,
        Weight = weight or 0,
        Percent = percent
    }
end

function GetValkyrieRankProbabilityTable(trainingLevel)
    local level = ClampValkyrieTrainingLevel(trainingLevel or VALKYRIE_TRAINING_BASE_LEVEL)
    local weights = ValkyrieRankProbabilityByTrainingLevel[level] or ValkyrieRankProbabilityByTrainingLevel[VALKYRIE_TRAINING_BASE_LEVEL]
    local totalWeight = 0

    for _, rankInfo in ipairs(ValkyrieRankOrder) do
        totalWeight = totalWeight + (weights[rankInfo.Rank] or 0)
    end

    local probabilities = {}
    for _, rankInfo in ipairs(ValkyrieRankOrder) do
        local weight = weights[rankInfo.Rank] or 0
        table.insert(probabilities, CopyValkyrieRankInfo(rankInfo, weight, totalWeight))
    end

    return probabilities, totalWeight, level
end

function FindValkyrieTrainingCity(playerID, pUnit)
    local pPlayer = Players[playerID]
    if pPlayer == nil or pUnit == nil then return nil end

    local unitX = pUnit:GetX()
    local unitY = pUnit:GetY()
    if unitX == nil or unitY == nil then
        return pPlayer:GetCities():GetCapitalCity()
    end

    local closestCity = nil
    local closestDistance = nil

    for _, pCity in pPlayer:GetCities():Members() do
        if pCity:GetX() == unitX and pCity:GetY() == unitY then
            return pCity
        end

        local dx = pCity:GetX() - unitX
        local dy = pCity:GetY() - unitY
        local distance = (dx * dx) + (dy * dy)
        if closestDistance == nil or distance < closestDistance then
            closestDistance = distance
            closestCity = pCity
        end
    end

    return closestCity
end

function GetValkyrieCityTrainingDetail(playerID, cityID)
    local trainingBreakdown = CalculateValkyrieTrainingBreakdown(playerID)
    if trainingBreakdown == nil then return nil, nil end

    for _, cityDetail in ipairs(trainingBreakdown.CityDetails) do
        if cityDetail.CityID == cityID then
            return cityDetail, trainingBreakdown
        end
    end

    return nil, trainingBreakdown
end

function CalculateValkyrieCityRankBreakdown(playerID, cityID)
    local cityDetail, trainingBreakdown = GetValkyrieCityTrainingDetail(playerID, cityID)
    if cityDetail == nil or trainingBreakdown == nil then return nil end

    local probabilities, totalWeight, level = GetValkyrieRankProbabilityTable(cityDetail.FinalLevel)
    return {
        CityID = cityDetail.CityID,
        CityName = cityDetail.CityName,
        TrainingLevel = level,
        EmpireLevel = trainingBreakdown.EmpireLevel,
        CityBonus = cityDetail.CityBonus,
        RawFinalLevel = cityDetail.RawFinalLevel,
        MaxLevel = trainingBreakdown.MaxLevel,
        EmpireSources = trainingBreakdown.EmpireSources,
        CitySources = cityDetail.Sources,
        RankProbabilities = probabilities,
        TotalWeight = totalWeight
    }
end

function RollValkyrieRank(trainingLevel)
    local probabilities, totalWeight = GetValkyrieRankProbabilityTable(trainingLevel)
    if totalWeight <= 0 then
        return CopyValkyrieRankInfo(ValkyrieRankByID.F, 0, 0), 0, totalWeight
    end

    local roll = Game.GetRandNum(totalWeight, "Honkai Valkyrie rank roll") + 1
    local runningWeight = 0

    for _, rankInfo in ipairs(probabilities) do
        runningWeight = runningWeight + (rankInfo.Weight or 0)
        if roll <= runningWeight then
            return rankInfo, roll, totalWeight
        end
    end

    return probabilities[#probabilities], roll, totalWeight
end

function ClearValkyrieRankAbilities(pUnit)
    if pUnit == nil or type(pUnit.GetAbility) ~= "function" then return end

    local pUnitAbility = pUnit:GetAbility()
    if pUnitAbility == nil or type(pUnitAbility.ChangeAbilityCount) ~= "function" then return end

    for _, rankInfo in ipairs(ValkyrieRankOrder) do
        local currentCount = 0
        if type(pUnitAbility.GetAbilityCount) == "function" then
            currentCount = pUnitAbility:GetAbilityCount(rankInfo.AbilityType) or 0
        end

        if currentCount > 0 then
            pUnitAbility:ChangeAbilityCount(rankInfo.AbilityType, -currentCount)
        end
    end
end

function ApplyValkyrieRankToUnit(pUnit, rankInfo, trainingLevel, cityID)
    if pUnit == nil or rankInfo == nil then return end

    if type(pUnit.SetProperty) == "function" then
        pUnit:SetProperty("HOH_VALKYRIE_RANK", rankInfo.Rank)
        pUnit:SetProperty("HOH_VALKYRIE_RANK_NAME", rankInfo.Name)
        pUnit:SetProperty("HOH_VALKYRIE_RANK_COMBAT_BONUS", rankInfo.CombatBonus)
        pUnit:SetProperty("HOH_VALKYRIE_TRAINING_LEVEL_ON_CREATE", trainingLevel)
        pUnit:SetProperty("HOH_VALKYRIE_TRAINING_CITY_ID", cityID)
    end

    if type(pUnit.GetAbility) == "function" then
        local pUnitAbility = pUnit:GetAbility()
        if pUnitAbility ~= nil and type(pUnitAbility.ChangeAbilityCount) == "function" then
            ClearValkyrieRankAbilities(pUnit)
            pUnitAbility:ChangeAbilityCount(rankInfo.AbilityType, 1)

            if type(pUnitAbility.GetAbilityCount) == "function" then
                local finalCount = pUnitAbility:GetAbilityCount(rankInfo.AbilityType) or 0
                if finalCount <= 0 then
                    print("【崩坏女武神】警告：评级能力未成功启用：" .. tostring(rankInfo.AbilityType))
                end
            end
        end
    end
end

function AssignValkyrieRank(playerID, unitID)
    local pPlayer = Players[playerID]
    if pPlayer == nil then return end

    local pUnit = UnitManager.GetUnit(playerID, unitID)
    if pUnit == nil then return end

    if not IsHonkaiValkyrieUnit(pUnit) then return end

    if type(pUnit.GetProperty) == "function" then
        local storedRankID = pUnit:GetProperty("HOH_VALKYRIE_RANK")
        if storedRankID ~= nil then
            local storedRankInfo = ValkyrieRankByID[storedRankID]
            if storedRankInfo ~= nil then
                ApplyValkyrieRankToUnit(
                    pUnit,
                    storedRankInfo,
                    pUnit:GetProperty("HOH_VALKYRIE_TRAINING_LEVEL_ON_CREATE") or VALKYRIE_TRAINING_BASE_LEVEL,
                    pUnit:GetProperty("HOH_VALKYRIE_TRAINING_CITY_ID")
                )
            end
            return
        end
    end

    local trainingLevel = VALKYRIE_TRAINING_BASE_LEVEL
    local cityID = nil
    local pTrainingCity = FindValkyrieTrainingCity(playerID, pUnit)

    if pTrainingCity ~= nil then
        cityID = pTrainingCity:GetID()
        local rankBreakdown = CalculateValkyrieCityRankBreakdown(playerID, cityID)
        if rankBreakdown ~= nil then
            trainingLevel = rankBreakdown.TrainingLevel
        end
    else
        local trainingBreakdown = CalculateValkyrieTrainingBreakdown(playerID)
        if trainingBreakdown ~= nil then
            trainingLevel = trainingBreakdown.EmpireLevel
        end
    end

    local rankInfo = RollValkyrieRank(trainingLevel)
    ApplyValkyrieRankToUnit(pUnit, rankInfo, trainingLevel, cityID)

    print("【崩坏女武神】玩家 " .. tostring(playerID) .. " 生成女武神，训练等级 Lv" .. tostring(trainingLevel) .. "，评级 " .. tostring(rankInfo.Name) .. "，战斗力 +" .. tostring(rankInfo.CombatBonus))
end

function OnHonkaiUnitCreated(playerID, unitID)
    AssignValkyrieRank(playerID, unitID)
    ApplyKnightOathToUnit(playerID, unitID)
end

function OnHonkaiUnitMoved(playerID, unitID)
    ApplyKnightOathToUnit(playerID, unitID)
end

function OnHonkaiPolicyChanged(playerID)
    RefreshKnightOathForPlayer(playerID)
end

function OnHonkaiCityProductionCompleted(playerID)
    RefreshKnightOathForPlayer(playerID)
end

function AssignExistingValkyrieRanks()
    if PlayerManager == nil or type(PlayerManager.GetAliveIDs) ~= "function" then return end

    for _, playerID in ipairs(PlayerManager.GetAliveIDs()) do
        local pPlayer = Players[playerID]
        if pPlayer ~= nil then
            for _, pUnit in pPlayer:GetUnits():Members() do
                AssignValkyrieRank(playerID, pUnit:GetID())
            end
            RefreshKnightOathForPlayer(playerID)
        end
    end
end

-- 【核心逻辑】处理科研队列的扣费与解锁
function ProcessResearchQueue(playerID, shouldRefreshUI)
    local pPlayer = Players[playerID]
    if not pPlayer then return end

    local queueStr = pPlayer:GetProperty("HONKAI_RESEARCH_QUEUE")
    if not queueStr or queueStr == "" then
        pPlayer:SetProperty("HONKAI_CURRENT_RESEARCH", nil)
        if shouldRefreshUI and ExposedMembers.HonkaiUI and ExposedMembers.HonkaiUI.RefreshUI then
            ExposedMembers.HonkaiUI.RefreshUI(playerID)
        end
        return
    end

    local queue = {}
    for s in string.gmatch(queueStr, '([^,]+)') do
        table.insert(queue, s)
    end

    local currentPoints = pPlayer:GetProperty("HONKAI_RESEARCH_POINTS") or 0
    local stillProcessing = true

    while stillProcessing and #queue > 0 do
        local currentTarget = queue[1]
        local techCost = pPlayer:GetProperty("COST_" .. currentTarget)
        if techCost == nil or techCost <= 0 then
            techCost = GetHonkaiTechCost(currentTarget)
            pPlayer:SetProperty("COST_" .. currentTarget, techCost)
        end
        
        if currentPoints >= techCost then
            -- 钱够了，解锁！
            currentPoints = currentPoints - techCost
            pPlayer:SetProperty("UNLOCKED_" .. currentTarget, 1)
            GrantTechModifiers(playerID, currentTarget)
            
            print("【崩坏底层】自动解锁：" .. currentTarget)
            
            table.remove(queue, 1)
            pPlayer:SetProperty("HONKAI_RESEARCH_POINTS", currentPoints)
        else
            stillProcessing = false
        end
    end

    -- 写回队列并同步状态
    local newQueueStr = table.concat(queue, ",")
    pPlayer:SetProperty("HONKAI_RESEARCH_QUEUE", newQueueStr)
    pPlayer:SetProperty("HONKAI_CURRENT_RESEARCH", queue[1])

    -- 只在玩家主动改队列时摇醒 UI；回合开始结算期间跨上下文刷新 UI 容易卡住回合推进。
    if shouldRefreshUI and ExposedMembers.HonkaiUI and ExposedMembers.HonkaiUI.RefreshUI then
        ExposedMembers.HonkaiUI.RefreshUI(playerID)
    end
end

-- 【核心逻辑】每回合自动发放资源
function OnPlayerTurnStarted(playerID)
    local pPlayer = Players[playerID]
    if not pPlayer then return end
    
    -- 1. 计算并增加崩坏研究点
    local researchBreakdown = CalculateHonkaiResearchBreakdown(playerID)
    local currentResearchPoints = pPlayer:GetProperty("HONKAI_RESEARCH_POINTS") or 0
    pPlayer:SetProperty("HONKAI_RESEARCH_POINTS", currentResearchPoints + researchBreakdown.TotalYield)

    -- 2. 计算并增加战术崩坏能
    local energyBreakdown = CalculateHonkaiEnergyBreakdown(playerID)
    local currentEnergy = pPlayer:GetProperty("HONKAI_ENERGY") or 0
    local energyCap = CalculateHonkaiEnergyCapacity(playerID)
    
    local newEnergy = math.min(energyCap, currentEnergy + energyBreakdown.TotalYield)
    pPlayer:SetProperty("HONKAI_ENERGY", newEnergy)
    pPlayer:SetProperty("HONKAI_ENERGY_CAPACITY", energyCap)
    pPlayer:SetProperty("HONKAI_ENERGY_YIELD", energyBreakdown.TotalYield)

    -- 3. 圣痕谱系解剖学：每2专家 +1住房 +1食物（正负 Modifier 对冲，支持可增可减）
    if IsHonkaiTechUnlocked(playerID, "HONKAI_TECH_STIGMATA_GENE_COMPLETION") then
        local totalSpec = 0
        for _, pCity in pPlayer:GetCities():Members() do
            totalSpec = totalSpec + CountCitySpecialists(pCity)
        end
        local newBonus = math.floor(totalSpec / 2)
        local oldBonus = pPlayer:GetProperty("STIGMATA_GENE_BONUS") or 0
        local delta = newBonus - oldBonus
        if delta > 0 then
            for _ = 1, delta do
                pPlayer:AttachModifierByID("MOD_HOH_STIGMATA_GENE_HOUSING")
                pPlayer:AttachModifierByID("MOD_HOH_STIGMATA_GENE_FOOD")
            end
        elseif delta < 0 then
            for _ = 1, -delta do
                pPlayer:AttachModifierByID("MOD_HOH_STIGMATA_GENE_HOUSING_NEG")
                pPlayer:AttachModifierByID("MOD_HOH_STIGMATA_GENE_FOOD_NEG")
            end
        end
        if delta ~= 0 then
            pPlayer:SetProperty("STIGMATA_GENE_BONUS", newBonus)
        end
    end

    -- 4. 处理队列结算
    ProcessResearchQueue(playerID, false)

    -- 4. 刷新基于当前位置和政策的女武神动态能力
    RefreshKnightOathForPlayer(playerID)
end

-- 指令：由 UI 触发，设定新的研究路径（队列）
function OnHonkaiSetResearchTarget(playerID, parameters)
    local pPlayer = Players[playerID]
    if not pPlayer then return end
    parameters = parameters or {}
    
    local queueStr = parameters.QueueStr or ""

    pPlayer:SetProperty("HONKAI_RESEARCH_QUEUE", queueStr)
    
    for techType in string.gmatch(queueStr, '([^,]+)') do
        pPlayer:SetProperty("COST_" .. techType, GetHonkaiTechCost(techType))
    end

    print("【崩坏底层】接收到新科研路径：" .. queueStr)

    -- 立即尝试结算（但不增加资源产出）
    ProcessResearchQueue(playerID, true)
end

ExposedMembers.Honkai = ExposedMembers.Honkai or {}
ExposedMembers.Honkai.CalculateHonkaiEnergyBreakdown = CalculateHonkaiEnergyBreakdown
ExposedMembers.Honkai.CalculateHonkaiEnergyCapacity = CalculateHonkaiEnergyCapacity
ExposedMembers.Honkai.CalculateHonkaiCityEnergyBreakdown = CalculateHonkaiCityEnergyBreakdown
ExposedMembers.Honkai.CalculateHonkaiResearchBreakdown = CalculateHonkaiResearchBreakdown
ExposedMembers.Honkai.CalculateValkyrieTrainingBreakdown = CalculateValkyrieTrainingBreakdown
ExposedMembers.Honkai.CalculateValkyrieCityRankBreakdown = CalculateValkyrieCityRankBreakdown
ExposedMembers.Honkai.GetValkyrieRankProbabilityTable = function(trainingLevel)
    local probabilities, totalWeight, level = GetValkyrieRankProbabilityTable(trainingLevel)
    return {
        TrainingLevel = level,
        RankProbabilities = probabilities,
        TotalWeight = totalWeight
    }
end
ExposedMembers.Honkai.IsUnlocked = function(playerID, techType)
    return IsHonkaiTechUnlocked(playerID, techType)
end
ExposedMembers.Honkai.GetResearchPoints = function(playerID)
    local pPlayer = Players[playerID]
    return pPlayer and (pPlayer:GetProperty("HONKAI_RESEARCH_POINTS") or 0) or 0
end
ExposedMembers.Honkai.GetCurrentResearch = function(playerID)
    local pPlayer = Players[playerID]
    return pPlayer and pPlayer:GetProperty("HONKAI_CURRENT_RESEARCH") or nil
end
ExposedMembers.Honkai.GetResearchQueue = function(playerID)
    local pPlayer = Players[playerID]
    local queueStr = pPlayer:GetProperty("HONKAI_RESEARCH_QUEUE") or ""
    local queue = {}
    if queueStr ~= "" then
        for s in string.gmatch(queueStr, '([^,]+)') do
            table.insert(queue, s)
        end
    end
    return queue
end

function Initialize()
    GameEvents.PlayerTurnStarted.Add(OnPlayerTurnStarted)
    GameEvents.HonkaiSetResearchTarget.Add(OnHonkaiSetResearchTarget)
    if GameEvents.UnitInitialized ~= nil and type(GameEvents.UnitInitialized.Add) == "function" then
        GameEvents.UnitInitialized.Add(OnHonkaiUnitCreated)
    end
    if GameEvents.UnitCreated ~= nil and type(GameEvents.UnitCreated.Add) == "function" then
        GameEvents.UnitCreated.Add(OnHonkaiUnitCreated)
    end
    if GameEvents.OnUnitMoved ~= nil and type(GameEvents.OnUnitMoved.Add) == "function" then
        GameEvents.OnUnitMoved.Add(OnHonkaiUnitMoved)
    end
    if Events.UnitMoved ~= nil and type(Events.UnitMoved.Add) == "function" then
        Events.UnitMoved.Add(OnHonkaiUnitMoved)
    end
    if Events.GovernmentPolicyChanged ~= nil and type(Events.GovernmentPolicyChanged.Add) == "function" then
        Events.GovernmentPolicyChanged.Add(OnHonkaiPolicyChanged)
    end
    if Events.CityProductionCompleted ~= nil and type(Events.CityProductionCompleted.Add) == "function" then
        Events.CityProductionCompleted.Add(OnHonkaiCityProductionCompleted)
    end
end

Events.LoadGameViewStateDone.Add(function()
    Initialize()
    -- 初次加载时，为本地玩家恢复一次影子科技
    local localPlayer = Game.GetLocalPlayer()
    if localPlayer ~= -1 then
        RestoreUnlockedTechs(localPlayer)
    end
    AssignExistingValkyrieRanks()
end)
