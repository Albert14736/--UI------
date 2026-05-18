-- ===========================================================================
-- 崩坏能 system - 核心逻辑控制 (Gameplay Context)
-- 负责：存储崩坏能、处理扣除请求、保存已解锁的科技节点
-- ===========================================================================
print(" --- | Honkai Energy System (Gameplay) Loaded! | ---")

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

function CalculateHonkaiEnergyBreakdown(playerID)
    local pPlayer = Players[playerID]
    if not pPlayer then return nil end

    local breakdown = {
        CityDetails = {},
        TechModifier = 0,
        TechCount = 0,
        CoreBonus = 0,
        TotalYield = 0,
        SubtotalFromCities = 0
    }

    -- 1. 遍历城市计算基础产出
    local pCities = pPlayer:GetCities()
    for _, pCity in pCities:Members() do
        local cityName = Locale.Lookup(pCity:GetName())
        
        -- 获取城市地格总数
        local cityPlots = Map.GetCityPlots():GetPlotsInCity(pCity)
        local plotCount = #cityPlots
        local population = pCity:GetPopulation()
        
        -- 计算 改良设施 + 区域 + 建筑总数
        local districtCount = pCity:GetDistricts():GetCount()
        local buildingCount = 0
        local pCityBuildings = pCity:GetBuildings()
        for row in GameInfo.Buildings() do
            if pCityBuildings:HasBuilding(row.Index) then
                buildingCount = buildingCount + 1
            end
        end

        local improvementCount = 0
        for _, plotIndex in ipairs(cityPlots) do
            local pPlot = Map.GetPlotByIndex(plotIndex)
            if pPlot and pPlot:GetImprovementType() ~= -1 then
                improvementCount = improvementCount + 1
            end
        end

        local cityBase = plotCount * 0.1
        local popMultiplier = 1 + (population * 0.05)
        local infrastructureMultiplier = 1 + ((districtCount + buildingCount + improvementCount) * 0.02)
        
        local cityTotal = cityBase * popMultiplier * infrastructureMultiplier
        breakdown.CityDetails[cityName] = cityTotal
        breakdown.SubtotalFromCities = breakdown.SubtotalFromCities + cityTotal
    end

    -- 2. 科技加成 (每个科技 +5%)
    local techCount = 0
    for honkaiTech, _ in pairs(ShadowCivicMap) do
        if pPlayer:GetProperty("UNLOCKED_" .. honkaiTech) == 1 then
            techCount = techCount + 1
        end
    end
    breakdown.TechCount = techCount
    breakdown.TechModifier = techCount * 0.05
    
    -- 3. 律者核心加成
    breakdown.CoreBonus = pPlayer:GetProperty("HONKAI_CORE_YIELD_BONUS") or 0

    -- 最终计算：(城市总和 * (1 + 科技加成)) + 核心加成
    breakdown.TotalYield = (breakdown.SubtotalFromCities * (1 + breakdown.TechModifier)) + breakdown.CoreBonus

    return breakdown
end

function CalculateHonkaiResearchBreakdown(playerID)
    local pPlayer = Players[playerID]
    if not pPlayer then return nil end

    local breakdown = {
        CityDetails = {},
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
        
        if cityResearch > 0 then
            breakdown.CityDetails[cityName] = cityResearch
            breakdown.TotalYield = breakdown.TotalYield + cityResearch
        end
    end

    breakdown.TotalYield = breakdown.TotalYield + breakdown.BaseYield
    return breakdown
end

-- 【核心逻辑】处理科研队列的扣费与解锁
function ProcessResearchQueue(playerID)
    local pPlayer = Players[playerID]
    if not pPlayer then return end

    local queueStr = pPlayer:GetProperty("HONKAI_RESEARCH_QUEUE")
    if not queueStr or queueStr == "" then
        pPlayer:SetProperty("HONKAI_CURRENT_RESEARCH", nil)
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
        local techCost = pPlayer:GetProperty("COST_" .. currentTarget) or 99999
        
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

    -- 摇醒 UI
    if ExposedMembers.HonkaiUI and ExposedMembers.HonkaiUI.RefreshUI then
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
    local energyCap = pPlayer:GetProperty("HONKAI_ENERGY_CAPACITY") or 1000
    
    local newEnergy = math.min(energyCap, currentEnergy + energyBreakdown.TotalYield)
    pPlayer:SetProperty("HONKAI_ENERGY", newEnergy)
    pPlayer:SetProperty("HONKAI_ENERGY_YIELD", energyBreakdown.TotalYield)

    -- 3. 处理队列结算
    ProcessResearchQueue(playerID)
end

-- 指令：由 UI 触发，设定新的研究路径（队列）
function OnHonkaiSetResearchTarget(playerID, parameters)
    local pPlayer = Players[playerID]
    if not pPlayer then return end
    
    local queueStr = parameters.QueueStr or ""
    local costs = parameters.Costs or {}

    pPlayer:SetProperty("HONKAI_RESEARCH_QUEUE", queueStr)
    
    for techType, cost in pairs(costs) do
        pPlayer:SetProperty("COST_" .. techType, cost)
    end

    print("【崩坏底层】接收到新科研路径：" .. queueStr)

    -- 立即尝试结算（但不增加资源产出）
    ProcessResearchQueue(playerID)
end

ExposedMembers.Honkai = ExposedMembers.Honkai or {}
ExposedMembers.Honkai.CalculateHonkaiEnergyBreakdown = CalculateHonkaiEnergyBreakdown
ExposedMembers.Honkai.CalculateHonkaiResearchBreakdown = CalculateHonkaiResearchBreakdown
ExposedMembers.Honkai.IsUnlocked = function(playerID, techType)
    local pPlayer = Players[playerID]
    return pPlayer and (pPlayer:GetProperty("UNLOCKED_" .. techType) == 1)
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
end

Events.LoadGameViewStateDone.Add(function()
    Initialize()
    -- 初次加载时，为本地玩家恢复一次影子科技
    local localPlayer = Game.GetLocalPlayer()
    if localPlayer ~= -1 then
        RestoreUnlockedTechs(localPlayer)
    end
end)
