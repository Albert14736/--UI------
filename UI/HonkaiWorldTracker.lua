-- ===========================================================================
-- Honkai World Tracker UI - 资源显示注入 (修正版)
-- ===========================================================================

function FormatValkyrieTrainingBonus(amount)
    if amount and amount > 0 then
        return "+" .. tostring(amount)
    end
    return tostring(amount or 0)
end

function AppendValkyrieTrainingSources(lines, prefix, sources)
    if sources == nil or #sources == 0 then
        return false
    end

    for _, source in ipairs(sources) do
        table.insert(lines, prefix .. source.Name .. "：" .. FormatValkyrieTrainingBonus(source.Amount))
    end
    return true
end

function BuildValkyrieTrainingTooltip(trainingBreakdown)
    local lines = {}
    local baseLevel = trainingBreakdown.BaseLevel or 1
    local empireLevel = trainingBreakdown.EmpireLevel or baseLevel
    local empireRawLevel = trainingBreakdown.EmpireRawLevel or empireLevel
    local maxLevel = trainingBreakdown.MaxLevel or 10

    table.insert(lines, "女武神训练课程等级")
    table.insert(lines, "帝国基础等级：Lv " .. tostring(baseLevel))

    if trainingBreakdown.EmpireSources and #trainingBreakdown.EmpireSources > 0 then
        table.insert(lines, "帝国等级来源：")
        AppendValkyrieTrainingSources(lines, "  ", trainingBreakdown.EmpireSources)
    else
        table.insert(lines, "帝国等级来源：无")
    end

    local empireLine = "帝国当前等级：Lv " .. tostring(empireLevel)
    if empireRawLevel > empireLevel then
        empireLine = empireLine .. "（原始 Lv " .. tostring(empireRawLevel) .. "，上限 Lv " .. tostring(maxLevel) .. "）"
    end
    table.insert(lines, empireLine)

    table.insert(lines, "")
    table.insert(lines, "每城最终训练等级：")

    if trainingBreakdown.CityDetails == nil or #trainingBreakdown.CityDetails == 0 then
        table.insert(lines, "  无城市")
    else
        for _, cityDetail in ipairs(trainingBreakdown.CityDetails) do
            local cityName = cityDetail.CityName or "未知城市"
            local cityBonus = cityDetail.CityBonus or 0
            local finalLevel = cityDetail.FinalLevel or empireLevel
            local rawFinalLevel = cityDetail.RawFinalLevel or finalLevel
            local cityLine = "  " .. cityName .. "：Lv " .. tostring(finalLevel) .. "（帝国 Lv " .. tostring(cityDetail.EmpireLevel or empireLevel) .. "，本城额外 " .. FormatValkyrieTrainingBonus(cityBonus) .. "）"
            if rawFinalLevel > finalLevel then
                cityLine = cityLine .. "（原始 Lv " .. tostring(rawFinalLevel) .. "，已封顶）"
            end
            table.insert(lines, cityLine)
            AppendValkyrieTrainingSources(lines, "    ", cityDetail.Sources)
        end
    end

    return table.concat(lines, "[NEWLINE]")
end

function RefreshHonkaiResources()
    local localPlayerID = Game.GetLocalPlayer()
    if localPlayerID == -1 then return end
    
    local pPlayer = Players[localPlayerID]
    if pPlayer == nil then return end
    if ExposedMembers.Honkai == nil then return end
    if ExposedMembers.Honkai.CalculateHonkaiResearchBreakdown == nil then return end
    if ExposedMembers.Honkai.CalculateHonkaiEnergyBreakdown == nil then return end

    -- 1. 获取研究点明细与总产出
    local researchPoints = pPlayer:GetProperty("HONKAI_RESEARCH_POINTS") or 0
    local researchBreakdown = ExposedMembers.Honkai.CalculateHonkaiResearchBreakdown(localPlayerID)
    local researchYield = researchBreakdown and researchBreakdown.TotalYield or 0

    -- 2. 获取战术崩坏能明细与总产出
    local honkaiEnergy = pPlayer:GetProperty("HONKAI_ENERGY") or 0
    local honkaiEnergyCap = pPlayer:GetProperty("HONKAI_ENERGY_CAPACITY")
    if honkaiEnergyCap == nil and ExposedMembers.Honkai.CalculateHonkaiEnergyCapacity then
        honkaiEnergyCap = ExposedMembers.Honkai.CalculateHonkaiEnergyCapacity(localPlayerID)
    end
    honkaiEnergyCap = honkaiEnergyCap or 0
    local energyBreakdown = ExposedMembers.Honkai.CalculateHonkaiEnergyBreakdown(localPlayerID)
    local honkaiEnergyYield = energyBreakdown and energyBreakdown.TotalYield or 0
    local valkyrieTrainingBreakdown = nil
    if ExposedMembers.Honkai.CalculateValkyrieTrainingBreakdown then
        valkyrieTrainingBreakdown = ExposedMembers.Honkai.CalculateValkyrieTrainingBreakdown(localPlayerID)
    end

    -- 3. 更新 UI 主文本
    Controls.HonkaiResearchLabel:SetText(Locale.Lookup("LOC_WORLD_TRACKER_HONKAI_RESEARCH", math.floor(researchPoints), math.floor(researchYield)))
    Controls.HonkaiEnergyLabel:SetText(Locale.Lookup("LOC_WORLD_TRACKER_HONKAI_ENERGY", math.floor(honkaiEnergy), math.floor(honkaiEnergyCap), math.floor(honkaiEnergyYield)))
    if Controls.HonkaiValkyrieTrainingLabel then
        local empireTrainingLevel = 1
        if valkyrieTrainingBreakdown and valkyrieTrainingBreakdown.EmpireLevel then
            empireTrainingLevel = valkyrieTrainingBreakdown.EmpireLevel
        end
        Controls.HonkaiValkyrieTrainingLabel:SetText("女武神训练课程等级：" .. tostring(empireTrainingLevel))
        if valkyrieTrainingBreakdown then
            Controls.HonkaiValkyrieTrainingLabel:SetToolTipString(BuildValkyrieTrainingTooltip(valkyrieTrainingBreakdown))
        end
    end

    -- 4. 构建战术崩坏能 Tooltip
    if energyBreakdown then
        local energyTT = Locale.Lookup("LOC_HONKAI_TOOLTIP_ENERGY_HEADER")
        -- 城市产出
        for cityName, cityYield in pairs(energyBreakdown.CityDetails) do
            energyTT = energyTT .. "[NEWLINE]" .. Locale.Lookup("LOC_HONKAI_TOOLTIP_CITY_SOURCE", math.floor(cityYield * 10)/10, cityName)
        end
        -- 科技加成
        if energyBreakdown.TechModifier > 0 then
            energyTT = energyTT .. "[NEWLINE]" .. Locale.Lookup("LOC_HONKAI_TOOLTIP_TECH_MODIFIER", energyBreakdown.TechModifier * 100, energyBreakdown.TechCount)
        end
        -- 律者核心
        if energyBreakdown.CoreBonus > 0 then
            energyTT = energyTT .. "[NEWLINE]" .. Locale.Lookup("LOC_HONKAI_TOOLTIP_CORE_BONUS", energyBreakdown.CoreBonus)
        end
        -- 总计
        energyTT = energyTT .. "[NEWLINE]" .. Locale.Lookup("LOC_HONKAI_TOOLTIP_TOTAL", math.floor(honkaiEnergyYield * 10)/10)
        Controls.HonkaiEnergyLabel:SetToolTipString(energyTT)
    end

    -- 5. 构建崩坏研究点 Tooltip
    if researchBreakdown then
        local researchTT = Locale.Lookup("LOC_HONKAI_TOOLTIP_RESEARCH_HEADER")
        -- 基础产出
        researchTT = researchTT .. "[NEWLINE]" .. Locale.Lookup("LOC_HONKAI_TOOLTIP_BASE_YIELD", researchBreakdown.BaseYield)
        -- 城市产出 (来自特色区域建筑)
        for cityName, cityYield in pairs(researchBreakdown.CityDetails) do
            researchTT = researchTT .. "[NEWLINE]" .. Locale.Lookup("LOC_HONKAI_TOOLTIP_CITY_SOURCE", cityYield, cityName)
        end
        -- 总计
        researchTT = researchTT .. "[NEWLINE]" .. Locale.Lookup("LOC_HONKAI_TOOLTIP_TOTAL", researchBreakdown.TotalYield)
        Controls.HonkaiResearchLabel:SetToolTipString(researchTT)
    end
    
    -- 强制刷新容器尺寸，确保 PanelStack 重新排版
    local pTrackerStack = ContextPtr:LookUpControl("/InGame/WorldTracker/PanelStack")
    if pTrackerStack then
        pTrackerStack:CalculateSize()
        pTrackerStack:ReprocessAnchoring()
    end
end

function OnInitialize()
    -- 定位到原版 WorldTracker 的主面板栈
    local pTrackerStack = ContextPtr:LookUpControl("/InGame/WorldTracker/PanelStack")
    if pTrackerStack == nil then
        print("【崩坏UI】错误：未找到 WorldTracker/PanelStack")
        return
    end

    -- 将我们的面板挂载为 PanelStack 的子项
    Controls.HonkaiTrackerGrid:ChangeParent(pTrackerStack)
    
    -- 插入位置 index 1 (通常在科技条下方)
    pTrackerStack:AddChildAtIndex(Controls.HonkaiTrackerGrid, 1)
    
    -- 关键：通知父容器重新计算布局，否则会出现重叠
    pTrackerStack:CalculateSize()
    pTrackerStack:ReprocessAnchoring()
    
    -- 初始刷新
    RefreshHonkaiResources()
end

-- 监听刷新事件
Events.PlayerTurnActivated.Add(function(playerID)
    if playerID == Game.GetLocalPlayer() then
        RefreshHonkaiResources()
    end
end)

LuaEvents.HonkaiTech_DoRefresh.Add(function(playerID)
    if playerID == Game.GetLocalPlayer() then
        RefreshHonkaiResources()
    end
end)

-- 游戏加载完成后初始化
Events.LoadGameViewStateDone.Add(OnInitialize)
