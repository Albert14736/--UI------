-- ===========================================================================
-- 崩坏能系统 - 核心逻辑控制 (Gameplay Context)
-- 负责：存储崩坏能、处理扣除请求、保存已解锁的科技节点
-- ===========================================================================
print(" --- | Honkai Energy System (Gameplay) Loaded! | ---")

-- 【测试用】每回合自动发放崩坏能，方便咱们买科技测试
function OnPlayerTurnStarted(playerID)
    local pPlayer = Players[playerID]
    if not pPlayer then return end
    
    -- 获取当前的崩坏能，没有则默认为0
    local currentPoints = pPlayer:GetProperty("HONKAI_RESEARCH_POINTS") or 0
    
    local yield = 10 -- 每回合给玩家发 10 点！
    currentPoints = currentPoints + yield
    pPlayer:SetProperty("HONKAI_RESEARCH_POINTS", currentPoints)

    -- 自动扣除逻辑：检查当前是否正在排队研究科技
    local currentResearch = pPlayer:GetProperty("HONKAI_CURRENT_RESEARCH")
    if currentResearch then
        local techCost = pPlayer:GetProperty("HONKAI_CURRENT_RESEARCH_COST") or 99999
        if currentPoints >= techCost then
            -- 钱存够了，回合开始时自动解锁！
            pPlayer:SetProperty("HONKAI_RESEARCH_POINTS", currentPoints - techCost)
            pPlayer:SetProperty("UNLOCKED_" .. currentResearch, 1)
            
            -- 清空当前研究目标
            pPlayer:SetProperty("HONKAI_CURRENT_RESEARCH", nil)
            pPlayer:SetProperty("HONKAI_CURRENT_RESEARCH_COST", nil)
            
            print("【崩坏底层】回合结算自动解锁：" .. currentResearch)
            if ExposedMembers.HonkaiUI and ExposedMembers.HonkaiUI.RefreshUI then
                ExposedMembers.HonkaiUI.RefreshUI(playerID)
            end
        end
    end
end

ExposedMembers.Honkai = ExposedMembers.Honkai or {}

ExposedMembers.Honkai.GetPoints = function(playerID)
    local pPlayer = Players[playerID]
    return pPlayer and pPlayer:GetProperty("HONKAI_RESEARCH_POINTS") or 0
end

ExposedMembers.Honkai.GetCurrentResearch = function(playerID)
    local pPlayer = Players[playerID]
    return pPlayer and pPlayer:GetProperty("HONKAI_CURRENT_RESEARCH")
end

ExposedMembers.Honkai.IsUnlocked = function(playerID, techType)
    local pPlayer = Players[playerID]
    return pPlayer and (pPlayer:GetProperty("UNLOCKED_" .. techType) == 1)
end

-- ===========================================================================
-- 【核心逻辑】处理 UI 传来的 EXECUTE_SCRIPT “设置研究目标”请求
-- ===========================================================================
function OnHonkaiSetResearchTarget(playerID, params)
    local pPlayer = Players[playerID]
    if not pPlayer then return end
    
    local techType = params.TechType
    local techCost = params.TechCost
    local currentPoints = pPlayer:GetProperty("HONKAI_RESEARCH_POINTS") or 0
    
    if currentPoints >= techCost then
        -- 钱够，大款直接秒解锁！
        pPlayer:SetProperty("HONKAI_RESEARCH_POINTS", currentPoints - techCost)
        pPlayer:SetProperty("UNLOCKED_" .. techType, 1)
        pPlayer:SetProperty("HONKAI_CURRENT_RESEARCH", nil)
        pPlayer:SetProperty("HONKAI_CURRENT_RESEARCH_COST", nil)
        
        -- ★ 触发科技解锁
        GrantTechModifiers(playerID, techType)
        print("【崩坏底层】玩家 " .. playerID .. " 秒解了：" .. techType)
    else
        -- 钱不够，挂入排队队列
        pPlayer:SetProperty("HONKAI_CURRENT_RESEARCH", techType)
        pPlayer:SetProperty("HONKAI_CURRENT_RESEARCH_COST", techCost)
        print("【崩坏底层】玩家 " .. playerID .. " 将研究目标设为：" .. techType)
    end
    
    -- 底层改完账本后，瞬间去摇醒 UI 进行实时刷新
    if ExposedMembers.HonkaiUI and ExposedMembers.HonkaiUI.RefreshUI then
        ExposedMembers.HonkaiUI.RefreshUI(playerID)
    end
end

function Initialize()
    GameEvents.PlayerTurnStarted.Add(OnPlayerTurnStarted)
    GameEvents.HonkaiSetResearchTarget.Add(OnHonkaiSetResearchTarget)
end
Events.LoadGameViewStateDone.Add(Initialize)
