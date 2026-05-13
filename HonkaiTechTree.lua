include("InstanceManager");

local m_TechNodeManager = InstanceManager:new("HonkaiTechNodeInstance", "NodeButton", Controls.TechCanvas)
local m_LaunchItemManager = InstanceManager:new("LaunchBarItemHonkai", "LaunchItemHonkaiButton")

local EntryButtonInstance = nil  -- 悬浮按钮实例

-- ===========================================================================
-- 统一的界面开关逻辑
function ToggleHonkaiWindow()
    if ContextPtr:IsHidden() then 
        ShowHonkaiWindow() 
    else 
        HideHonkaiWindow() 
    end
end

-- ===========================================================================
-- 【崩坏科技树 数据配置中心】
-- 在这里定义你的专属科技/技能。X和Y是你自己画板上的绝对坐标。
-- ===========================================================================
local HonkaiTechTreeData = {
    -- 竖向瀑布流布局：Y值不断变大（往下走），X值用来做左右分支 (中间值大约是 450)
    ["HK_TECH_1"] = { X=450, Y=50,  Cost=50,  Name="崩坏启示", Desc="解锁基础崩坏能应用。", Modifier="MOD_HK_TECH_1", Prereqs={} },
    ["HK_TECH_2"] = { X=250, Y=250, Cost=120, Name="虚数科技", Desc="所有城市+10%科技值。", Modifier="MOD_HK_TECH_2", Prereqs={"HK_TECH_1"} },
    ["HK_TECH_3"] = { X=650, Y=250, Cost=120, Name="量子装甲", Desc="所有单位+5战斗力。", Modifier="MOD_HK_TECH_3", Prereqs={"HK_TECH_1"} },
    ["HK_TECH_4"] = { X=450, Y=450, Cost=300, Name="羽化登仙", Desc="姬子绝境爆发解锁。", Modifier="MOD_HK_TECH_4", Prereqs={"HK_TECH_2", "HK_TECH_3"} }
}

local m_UnlockedTechs = {} -- 记录当前玩家已解锁的科技

-- ===========================================================================
-- 检查是否已解锁
function IsTechUnlocked(techID)
    local pPlayer = Players[Game.GetLocalPlayer()]
    if pPlayer then
        return pPlayer:GetProperty("UNLOCKED_" .. techID) == 1
    end
    return false
end

-- 检查前置科技是否都已解锁
function HasPrereqs(techID)
    local techInfo = HonkaiTechTreeData[techID]
    if not techInfo.Prereqs or #techInfo.Prereqs == 0 then return true end
    for _, prereq in ipairs(techInfo.Prereqs) do
        if not IsTechUnlocked(prereq) then
            return false
        end
    end
    return true
end

-- ===========================================================================
-- 绘制整棵树
function DrawTechTree()
    m_TechNodeManager:ResetInstances()
    local pPlayer = Players[Game.GetLocalPlayer()]
    if not pPlayer then return end

    -- 遍历数据表，生成节点
    for techID, techInfo in pairs(HonkaiTechTreeData) do
        local nodeInst = m_TechNodeManager:GetInstance()
        
        -- 设置坐标
        nodeInst.NodeButton:SetOffsetVal(techInfo.X, techInfo.Y)
        nodeInst.NodeName:SetText(techInfo.Name)
        nodeInst.NodeCost:SetText(techInfo.Cost .. " 崩坏能")
        nodeInst.NodeButton:SetToolTipString(techInfo.Desc)

        -- 判断状态
        local isUnlocked = IsTechUnlocked(techID)
        local canUnlock = HasPrereqs(techID)

        if isUnlocked then
            nodeInst.UnlockedFrame:SetHide(false)
            nodeInst.NodeButton:SetDisabled(true) -- 已解锁不能再点
        elseif canUnlock then
            nodeInst.UnlockedFrame:SetHide(true)
            nodeInst.NodeButton:SetDisabled(false)
        else
            -- 前置未解锁，变灰
            nodeInst.UnlockedFrame:SetHide(true)
            nodeInst.NodeButton:SetDisabled(true)
        end

        -- 绑定点击事件：解锁科技
        nodeInst.NodeButton:RegisterCallback(Mouse.eLClick, function()
            UnlockHonkaiTech(techID, techInfo)
        end)
    end
end

-- ===========================================================================
-- 解锁科技逻辑
function UnlockHonkaiTech(techID, techInfo)
    local playerID = Game.GetLocalPlayer()
    
    -- 向游戏内核发送指令：设置当前研究项（联机绝对安全）
    local params = {}
    params.OnStart = "SetHonkaiResearch" 
    params.TechID = techID
    UI.RequestPlayerOperation(playerID, PlayerOperations.EXECUTE_SCRIPT, params)
    
    UI.PlaySound("UI_Tech_Choose") -- 播放原版选科技音效
    
    -- 稍微延迟一点点刷新UI，等后台数据传回来
    DrawTechTree()
    RefreshEnergyDisplay()
end

-- ===========================================================================
-- 窗口打开与关闭控制
-- ===========================================================================
function RefreshEnergyDisplay()
    local pPlayer = Players[Game.GetLocalPlayer()]
    if not pPlayer then return end
    
    local energy = math.floor(pPlayer:GetProperty("PROPERTY_HONKAI_ENERGY") or 0)
    local yield = math.floor(pPlayer:GetProperty("PROPERTY_HONKAI_LAST_YIELD") or 0)
    local currentTech = pPlayer:GetProperty("HONKAI_CURRENT_RESEARCH")
    
    Controls.EnergyAmountLabel:SetText(tostring(energy))
    Controls.YieldAmountLabel:SetText("+" .. tostring(yield))
    
    if currentTech and currentTech ~= "" and HonkaiTechTreeData[currentTech] then
        local techInfo = HonkaiTechTreeData[currentTech]
        local progress = pPlayer:GetProperty("HONKAI_TECH_PROGRESS_" .. currentTech) or 0
        local needed = techInfo.Cost - progress
        local turns = math.ceil(needed / (yield > 0 and yield or 1))
        if yield <= 0 then turns = "999+" end
        Controls.CurrentResearchLabel:SetText(techInfo.Name .. " (" .. turns .. "回合)")
    else
        Controls.CurrentResearchLabel:SetText("无")
    end
end

function ShowHonkaiWindow()
    ContextPtr:SetHide(false)
    DrawTechTree()
    RefreshEnergyDisplay()
    UI.PlaySound("UI_Screen_Open")
end

function HideHonkaiWindow()
    if not ContextPtr:IsHidden() then
        ContextPtr:SetHide(true)
        UI.PlaySound("UI_Screen_Close")
    end
end

function HonkaiInputHandler(uiMsg, wParam, lParam)
    if (uiMsg == KeyEvents.KeyUp) then
        if (wParam == Keys.VK_ESCAPE) then
            if Controls.TechTreeContainer:IsVisible() then
                HideHonkaiWindow()
                return true
            end
        end
    end
    return false
end

function HonkaiInitHandler(isReload)
    SetupLaunchBarButton()
    ContextPtr:SetHide(true)
end

function HonkaiShutdownHandler()
    if EntryButtonInstance ~= nil then
        m_LaunchItemManager:ReleaseInstance(EntryButtonInstance)
    end
end

-- ===========================================================================
-- ===========================================================================
function SetupLaunchBarButton()
    local ctrl = ContextPtr:LookUpControl("/InGame/LaunchBar/ButtonStack")
    if ctrl == nil then return end
    
    if EntryButtonInstance == nil then
        EntryButtonInstance = m_LaunchItemManager:GetInstance(ctrl)
        EntryButtonInstance.LaunchItemHonkaiButton:RegisterCallback(Mouse.eLClick, function()
            ToggleHonkaiWindow()
        end)
    else
        print("ERROR: ButtonStack not found!")
    end
end

-- ===========================================================================
-- ===========================================================================
function Initialize()
    SetupLaunchBarButton()
    ContextPtr:SetInputHandler(HonkaiInputHandler)
    ContextPtr:SetInitHandler(HonkaiInitHandler)
    ContextPtr:SetShutdown(HonkaiShutdownHandler)
    
    Controls.CloseTreeButton:RegisterCallback(Mouse.eLClick, HideHonkaiWindow)
    
    LuaEvents.DiplomacyActionView_HideIngameUI.Add(HideHonkaiWindow)
    LuaEvents.FullscreenMap_Shown.Add(HideHonkaiWindow)
    
    Events.LocalPlayerTurnBegin.Add(function() if not ContextPtr:IsHidden() then RefreshEnergyDisplay() end end)
end
Events.LoadGameViewStateDone.Add(Initialize)