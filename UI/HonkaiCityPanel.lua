-- ===========================================================================
-- Honkai City Panel - selected city Honkai energy tooltip button
-- ===========================================================================
print(" --- | Honkai City Panel Tooltip Loaded! | ---")

local m_isAttached = false

local function FormatAmount(value)
    return string.format("%.1f", value or 0)
end

local function FormatMultiplier(value)
    return string.format("%.2f", value or 0)
end

local function FormatPercent(value)
    return string.format("%.0f%%", (value or 0) * 100)
end

local function FormatSignedInteger(value)
    value = value or 0
    if value > 0 then
        return "+" .. tostring(value)
    end
    return tostring(value)
end

local function FormatProbability(value)
    value = value or 0
    if math.floor(value) == value then
        return string.format("%.0f%%", value)
    end
    return string.format("%.1f%%", value)
end

local function AppendDetailLines(lines, details)
    if details == nil or #details == 0 then
        table.insert(lines, "    无")
        return
    end

    for _, detail in ipairs(details) do
        local count = detail.Count or 1
        local countText = count > 1 and (" x" .. tostring(count)) or ""
        table.insert(lines, "    [ICON_Bullet] " .. (detail.Name or detail.Type or "未知") .. countText .. ": +" .. FormatAmount(detail.Yield))
    end
end

local function BuildHonkaiCityEnergyTooltip(pCity)
    local playerID = Game.GetLocalPlayer()
    if playerID == -1 or pCity == nil then
        return "战术崩坏能明细"
    end

    if ExposedMembers.Honkai == nil or ExposedMembers.Honkai.CalculateHonkaiCityEnergyBreakdown == nil then
        return "战术崩坏能系统尚未初始化"
    end

    local data = ExposedMembers.Honkai.CalculateHonkaiCityEnergyBreakdown(playerID, pCity:GetID())
    if data == nil then
        return "无法读取本城战术崩坏能明细"
    end

    local lines = {}
    table.insert(lines, "[COLOR:110,30,180,255]" .. data.CityName .. " 战术崩坏能明细[ENDCOLOR]")

    if not data.IsUnlocked then
        table.insert(lines, "[NEWLINE]需要先完成【崩坏能感知】，本城才会开始产出战术崩坏能。")
        return table.concat(lines, "[NEWLINE]")
    end

    table.insert(lines, "[NEWLINE]公式：三环内己方地格 x 0.1 x 人口修正 x 基建修正")
    table.insert(lines, "[ICON_Bullet] 领土基础：" .. tostring(data.PlotCount) .. " 格 x 0.1 = " .. FormatAmount(data.TerritoryBase))
    table.insert(lines, "[ICON_Bullet] 人口修正：人口 " .. tostring(data.Population) .. "，x" .. FormatMultiplier(data.PopulationMultiplier))
    table.insert(lines, "[ICON_Bullet] 城市基础（领土 x 人口）：+" .. FormatAmount(data.BaseYield))

    table.insert(lines, "[NEWLINE][ICON_Bullet] 建筑基建加成：+" .. FormatAmount(data.BuildingYield) .. "（" .. tostring(data.BuildingCount) .. " 座，+" .. FormatPercent(data.BuildingCount * 0.02) .. "）")
    AppendDetailLines(lines, data.BuildingDetails)

    table.insert(lines, "[NEWLINE][ICON_Bullet] 改良设施基建加成：+" .. FormatAmount(data.ImprovementYield) .. "（" .. tostring(data.ImprovementCount) .. " 个，+" .. FormatPercent(data.ImprovementCount * 0.02) .. "）")
    AppendDetailLines(lines, data.ImprovementDetails)

    table.insert(lines, "[NEWLINE][ICON_Bullet] 区域基建加成：+" .. FormatAmount(data.DistrictYield) .. "（" .. tostring(data.DistrictCount) .. " 个，+" .. FormatPercent(data.DistrictCount * 0.02) .. "）")
    AppendDetailLines(lines, data.DistrictDetails)

    table.insert(lines, "[NEWLINE][ICON_Bullet] 基建修正合计：x" .. FormatMultiplier(data.InfrastructureMultiplier))
    table.insert(lines, "[ICON_Bullet] 本城公式产出：+" .. FormatAmount(data.FormulaYield))

    if (data.ActivationBonus or 0) > 0 then
        table.insert(lines, "[ICON_Bullet] 崩坏能感知首都激活：+" .. FormatAmount(data.ActivationBonus))
    end

    if (data.TechModifier or 0) > 0 then
        table.insert(lines, "[ICON_Bullet] 已解锁崩坏科技全局倍率：+" .. FormatPercent(data.TechModifier) .. "（" .. tostring(data.TechCount or 0) .. " 项）")
    end

    table.insert(lines, "[NEWLINE]本城本回合产出：+" .. FormatAmount(data.TotalYield) .. " [ICON_HONKAI_ENERGY]")

    if (data.CoreBonus or 0) > 0 then
        table.insert(lines, "[NEWLINE][COLOR:128,128,128,255]律者核心为帝国全局加成，不计入单城明细。[ENDCOLOR]")
    end

    return table.concat(lines, "[NEWLINE]")
end

local function BuildValkyrieRankTooltip(pCity)
    local playerID = Game.GetLocalPlayer()
    if playerID == -1 or pCity == nil then
        return "女武神评级概率"
    end

    if ExposedMembers.Honkai == nil or ExposedMembers.Honkai.CalculateValkyrieCityRankBreakdown == nil then
        return "女武神训练系统尚未初始化"
    end

    local data = ExposedMembers.Honkai.CalculateValkyrieCityRankBreakdown(playerID, pCity:GetID())
    if data == nil then
        return "无法读取本城女武神评级概率"
    end

    local lines = {}
    table.insert(lines, "[COLOR:220,60,120,255]" .. data.CityName .. " 女武神评级概率[ENDCOLOR]")
    table.insert(lines, "[NEWLINE]训练等级：Lv" .. tostring(data.TrainingLevel) .. " / " .. tostring(data.MaxLevel))
    table.insert(lines, "[ICON_Bullet] 帝国训练等级：Lv" .. tostring(data.EmpireLevel))
    table.insert(lines, "[ICON_Bullet] 本城额外训练等级：" .. FormatSignedInteger(data.CityBonus))

    if data.RawFinalLevel ~= data.TrainingLevel then
        table.insert(lines, "[ICON_Bullet] 等级上限修正：Lv" .. tostring(data.RawFinalLevel) .. " -> Lv" .. tostring(data.TrainingLevel))
    end

    table.insert(lines, "[NEWLINE]生成女武神时随机评级：")
    for _, rankInfo in ipairs(data.RankProbabilities or {}) do
        table.insert(lines, "[ICON_Bullet] " .. rankInfo.Name .. "：" .. FormatProbability(rankInfo.Percent) .. "（战斗力 " .. FormatSignedInteger(rankInfo.CombatBonus) .. "）")
    end

    return table.concat(lines, "[NEWLINE]")
end

local function TryAttachToCityPanel()
    if m_isAttached then return true end

    local pContext = ContextPtr:LookUpControl("/InGame/CityPanel/MainPanel")
    if pContext == nil then
        return false
    end

    Controls.HonkaiCityEnergyButton:ChangeParent(pContext)
    Controls.HonkaiValkyrieRateButton:ChangeParent(pContext)
    m_isAttached = true
    return true
end

function RefreshHonkaiCityPanelButtons()
    if not TryAttachToCityPanel() then
        Controls.HonkaiCityEnergyButton:SetHide(true)
        Controls.HonkaiValkyrieRateButton:SetHide(true)
        return
    end

    local pCity = UI.GetHeadSelectedCity()
    local playerID = Game.GetLocalPlayer()
    if playerID == -1 or pCity == nil or pCity:GetOwner() ~= playerID then
        Controls.HonkaiCityEnergyButton:SetHide(true)
        Controls.HonkaiValkyrieRateButton:SetHide(true)
        return
    end

    Controls.HonkaiCityEnergyButton:SetToolTipString(BuildHonkaiCityEnergyTooltip(pCity))
    Controls.HonkaiValkyrieRateButton:SetToolTipString(BuildValkyrieRankTooltip(pCity))
    Controls.HonkaiCityEnergyButton:SetHide(false)
    Controls.HonkaiValkyrieRateButton:SetHide(false)
end

function RefreshHonkaiCityEnergyButton()
    RefreshHonkaiCityPanelButtons()
end

function Initialize()
    Controls.HonkaiCityEnergyButton:RegisterCallback(Mouse.eMouseEnter, function()
        RefreshHonkaiCityPanelButtons()
        UI.PlaySound("Main_Menu_Mouse_Over")
    end)
    Controls.HonkaiValkyrieRateButton:RegisterCallback(Mouse.eMouseEnter, function()
        RefreshHonkaiCityPanelButtons()
        UI.PlaySound("Main_Menu_Mouse_Over")
    end)
    Controls.HonkaiCityEnergyButton:RegisterCallback(Mouse.eLClick, function()
        UI.PlaySound("UI_Click")
    end)
    Controls.HonkaiValkyrieRateButton:RegisterCallback(Mouse.eLClick, function()
        UI.PlaySound("UI_Click")
    end)

    Events.CitySelectionChanged.Add(function()
        RefreshHonkaiCityPanelButtons()
    end)
    Events.CityWorkerChanged.Add(function()
        RefreshHonkaiCityPanelButtons()
    end)
    Events.CityFocusChanged.Add(function()
        RefreshHonkaiCityPanelButtons()
    end)
    Events.CityProductionChanged.Add(function()
        RefreshHonkaiCityPanelButtons()
    end)
    Events.CityProductionCompleted.Add(function()
        RefreshHonkaiCityPanelButtons()
    end)
    Events.ImprovementChanged.Add(function()
        RefreshHonkaiCityPanelButtons()
    end)
    Events.LocalPlayerTurnBegin.Add(function()
        RefreshHonkaiCityPanelButtons()
    end)
    LuaEvents.HonkaiTech_DoRefresh.Add(function()
        RefreshHonkaiCityPanelButtons()
    end)

    RefreshHonkaiCityPanelButtons()
end

Events.LoadGameViewStateDone.Add(Initialize)
