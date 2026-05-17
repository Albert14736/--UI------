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
            
            -- ★ 触发能力发放
            GrantTechModifiers(playerID, currentResearch)
            
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
        
        -- ★ 注意：此处不调用 GrantTechModifiers，等到钱够了才发
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

Events.LoadGameViewStateDone.Add(function()
    Initialize()
    -- 初次加载时，为本地玩家恢复一次影子科技
    local localPlayer = Game.GetLocalPlayer()
    if localPlayer ~= -1 then
        RestoreUnlockedTechs(localPlayer)
    end
end)
