-- ===========================================================================
-- Honkai World Tracker UI - 资源显示注入 (修正版)
-- ===========================================================================

function RefreshHonkaiResources()
    local localPlayerID = Game.GetLocalPlayer()
    if localPlayerID == -1 then return end
    
    local pPlayer = Players[localPlayerID]
    if pPlayer == nil then return end

    -- 读取研究点
    local researchPoints = pPlayer:GetProperty("HONKAI_RESEARCH_POINTS") or 0
    local researchYield = 10 -- 当前测试阶段代码中固定给10

    -- 读取战术崩坏能 (蓝条)
    local honkaiEnergy = pPlayer:GetProperty("HONKAI_ENERGY") or 0
    local honkaiEnergyCap = pPlayer:GetProperty("HONKAI_ENERGY_CAPACITY") or 1000 -- 默认给个1000上限
    local honkaiEnergyYield = pPlayer:GetProperty("HONKAI_ENERGY_YIELD") or 0

    -- 更新 UI (通过本地化字符串注入图标和数值)
    Controls.HonkaiResearchLabel:SetText(Locale.Lookup("LOC_WORLD_TRACKER_HONKAI_RESEARCH", math.floor(researchPoints), researchYield))
    Controls.HonkaiEnergyLabel:SetText(Locale.Lookup("LOC_WORLD_TRACKER_HONKAI_ENERGY", math.floor(honkaiEnergy), math.floor(honkaiEnergyCap), math.floor(honkaiEnergyYield)))

    
    -- 强制刷新容器尺寸，确保 PanelStack 重新排版
    Controls.HonkaiTrackerGrid:CalculateSize()
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

Events.GamePropertyChanged.Add(function(key, value)
    if key == "HONKAI_RESEARCH_POINTS" or key == "HONKAI_ENERGY" then
        RefreshHonkaiResources()
    end
end)

-- 游戏加载完成后初始化
Events.LoadGameViewStateDone.Add(OnInitialize)
