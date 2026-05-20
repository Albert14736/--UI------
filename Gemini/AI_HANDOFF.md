# 后续 AI 交接文档

更新时间：2026-05-20

本文档给后续接手本模组的 AI 使用。请先读完再改代码，尤其是“测试命令”和“踩坑记录”。

## 当前代码进度

工作目录：

```powershell
C:\Users\alber\Documents\My Games\Sid Meier's Civilization VI\Mods\自制UI版本崩坏文明
```

当前已经跑通的主要系统：

1. 崩坏研究点
   - 核心逻辑在 `HonkaiEnergySystem.lua`。
   - 通过 `HONKAI_RESEARCH_POINTS` 玩家属性保存。
   - 科技树 UI 通过 `ExposedMembers.Honkai` 读取和写入研究状态。

2. 战术崩坏能
   - 核心公式：

```text
(三环内己方地格 x 0.1) x (1 + 人口 x 0.05) x (1 + (改良设施 + 区域 + 建筑) x 0.02)
```

   - 每个已解锁崩坏科技提供 +5% 全局倍率。
   - 城市详情页左侧已有按钮，Tooltip 能展示本城公式拆分。

3. World Tracker UI
   - `UI/HonkaiWorldTracker.lua/xml` 显示崩坏研究点、战术崩坏能、女武神训练课程等级。
   - 女武神训练课程等级显示的是帝国训练等级。
   - Tooltip 会列出每个城市的最终训练等级。

4. 城市详情页按钮
   - `UI/HonkaiCityPanel.lua/xml` 挂载到 `/InGame/CityPanel/MainPanel`。
   - 当前有两个按钮：
     - `HonkaiCityEnergyButton`：战术崩坏能明细。
     - `HonkaiValkyrieRateButton`：本城女武神评级概率。
   - 城市按钮文件目前在 git 状态里可能是 untracked，但 `.modinfo` 已经引用它们。

5. 女武神训练等级
   - 入口函数：`CalculateValkyrieTrainingBreakdown(playerID)`。
   - 基础等级 Lv1，上限 Lv10。
   - 帝国来源：
     - `HONKAI_TECH_VALKYRIE_ADVANCED`：+1
     - `HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION`：+1
     - `BUILDING_HOH_ST_FREYA` 首次存在时帝国 +2
   - 城市来源：
     - 拥有 `BUILDING_HOH_ST_FREYA` 的城市额外 +2

6. 女武神随机评级
   - 入口函数：
     - `CalculateValkyrieCityRankBreakdown(playerID, cityID)` 给 UI 查概率。
     - `AssignValkyrieRank(playerID, unitID)` 给单位实际分配评级。
   - 监听事件：
     - `GameEvents.UnitInitialized`
     - `GameEvents.UnitCreated`
   - 加载旧存档时执行 `AssignExistingValkyrieRanks()`，给未评级或已记录评级但能力未挂上的女武神补挂能力。
   - 评级与战斗力：

```text
F +0
E +1
D +2
C +3
B +5
A +8
S +12
```

   - 当前 Lv1-Lv10 概率表在 `ValkyrieRankProbabilityByTrainingLevel`，每级总权重都是 1000。

## 关键文件

```text
HonkaiEnergySystem.lua
Honkai_Civilization.xml
Honkai_Text.xml
Honkai_UI_Test.modinfo
UI/HonkaiWorldTracker.lua
UI/HonkaiWorldTracker.xml
UI/HonkaiCityPanel.lua
UI/HonkaiCityPanel.xml
```

不要随便回退用户已有改动。当前工作树本来就是脏的，里面有一部分是已经测试成功的开发成果。

## 动态 UnitAbility 必须这样写

女武神评级战力加成用的是动态 `UnitAbility`，不是晋升。

完整链条必须同时存在：

```text
Types: KIND_ABILITY
UnitAbilities: Inactive=true
UnitAbilityModifiers: Ability -> Modifier
Modifiers: MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH
ModifierArguments: Amount
TypeTags: Ability -> CLASS_HOH_VALKYRIE
TypeTags: UNIT_HOH_VALKYRIE_MK1 -> CLASS_HOH_VALKYRIE
Lua: pUnit:GetAbility():ChangeAbilityCount(abilityType, 1)
```

最重要的坑：只写 `UnitAbilities` 和 `ChangeAbilityCount` 不够。评级能力也必须通过 `TypeTags` 绑定到 `CLASS_HOH_VALKYRIE`。之前漏了这一步，表现是单位面板不显示评级能力，战斗力也不增加。

当前正确位置：

```text
Honkai_Civilization.xml: ABILITY_HOH_VALKYRIE_RANK_F/E/D/C/B/A/S
Honkai_Civilization.xml: TypeTags 中七个评级能力都绑定 CLASS_HOH_VALKYRIE
HonkaiEnergySystem.lua: ApplyValkyrieRankToUnit()
```

## 测试命令

已安装 Lua 5.1 工具：

```powershell
C:\Users\alber\Tools\Lua51
```

每次改普通 Lua 文件后先跑：

```powershell
$env:Path = $env:Path + ';' + (Join-Path $env:USERPROFILE 'Tools\Lua51')
luac -p .\HonkaiEnergySystem.lua .\UI\HonkaiWorldTracker.lua .\UI\HonkaiCityPanel.lua
```

注意：不要无脑对所有 Civ VI Lua 文件跑标准 `luac`。Firaxis/HKS 风格 Lua 可能包含 `name:string` 这类类型标注，标准 Lua 5.1 会误报。`UI/HonkaiTechTree/HonkaiTechTree.lua` 这类文件如果出现此问题，不代表游戏内一定不能跑。

XML 基础解析检查：

```powershell
[xml](Get-Content -Path .\Honkai_Civilization.xml -Encoding UTF8 -Raw) > $null
[xml](Get-Content -Path .\Honkai_Text.xml -Encoding UTF8 -Raw) > $null
[xml](Get-Content -Path .\UI\HonkaiCityPanel.xml -Encoding UTF8 -Raw) > $null
[xml](Get-Content -Path .\UI\HonkaiWorldTracker.xml -Encoding UTF8 -Raw) > $null
'XML parse OK'
```

检查女武神评级能力是否有 TypeTags：

```powershell
rg -n "ABILITY_HOH_VALKYRIE_RANK_.*CLASS_HOH_VALKYRIE" .\Honkai_Civilization.xml
```

检查关键函数和 UI 按钮是否存在：

```powershell
rg -n "CalculateValkyrieTrainingBreakdown|CalculateValkyrieCityRankBreakdown|ValkyrieRankProbabilityByTrainingLevel|AssignExistingValkyrieRanks|HonkaiValkyrieRateButton" .\HonkaiEnergySystem.lua .\UI\HonkaiCityPanel.lua .\UI\HonkaiCityPanel.xml .\Honkai_Civilization.xml
```

检查概率表每级是否总和 1000：

```powershell
$content = Get-Content -Path .\HonkaiEnergySystem.lua -Encoding UTF8 -Raw
$bad = @()
$matches = [regex]::Matches($content, '\[(\d+)\]\s*=\s*\{([^}]*)\}')
foreach ($m in $matches) {
    if ($m.Groups[2].Value -match 'F\s*=') {
        $sum = 0
        foreach ($n in [regex]::Matches($m.Groups[2].Value, '=\s*(\d+)')) {
            $sum += [int]$n.Groups[1].Value
        }
        if ($sum -ne 1000) {
            $bad += "Lv$($m.Groups[1].Value)=$sum"
        }
    }
}
if ($bad.Count -eq 0) { 'Probability table OK' } else { $bad -join ', ' }
```

## 游戏内测试步骤

代码层检查通过不等于游戏内必定通过。涉及 XML 数据库时，建议完全退出游戏后重启再测。

推荐测试流程：

1. 启动游戏并启用本模组。
2. 载入或新开使用崩坏文明的对局。
3. 检查 World Tracker：
   - 崩坏研究点显示正常。
   - 战术崩坏能显示正常。
   - 女武神训练课程等级显示正常。
   - Tooltip 能列出各城市最终训练等级。
4. 选择自己城市，检查城市详情页左侧两个按钮：
   - 战术崩坏能明细按钮存在。
   - 女武神评级概率按钮存在。
   - 评级概率 Tooltip 中 F/E/D/C/B/A/S 概率与本城训练等级匹配。
5. 生成女武神：
   - 建造、购买、或由建筑赠送均应触发。
   - 单位面板应显示某个评级能力，例如 B级女武神。
   - 战斗预览应显示对应战斗力加成。
6. 旧存档测试：
   - 如果旧存档里已有女武神，重新载入后应补挂已有评级能力。
   - 已有 `HOH_VALKYRIE_RANK` 的单位不会重新随机抽评级，只会重新应用能力。

## 读日志

本环境默认日志路径这次没有在以下位置找到：

```powershell
C:\Users\alber\Documents\My Games\Sid Meier's Civilization VI\Logs
```

如果用户机器上日志存在，优先看：

```text
Lua.log
Database.log
Modding.log
```

本模组 Lua 里有这些关键打印：

```text
--- | Honkai Energy System (Gameplay) Loaded! | ---
【崩坏女武神】玩家 ... 生成女武神，训练等级 Lv...，评级 ...，战斗力 +...
【崩坏女武神】警告：评级能力未成功启用：...
```

如果出现“评级能力未成功启用”，优先检查：

1. `Honkai_Civilization.xml` 是否加载进数据库。
2. 七个 `ABILITY_HOH_VALKYRIE_RANK_*` 是否有 `Types`。
3. 七个能力是否有 `UnitAbilities`。
4. 七个能力是否有 `UnitAbilityModifiers`。
5. 七个能力是否有 `TypeTags` 绑定到 `CLASS_HOH_VALKYRIE`。
6. `UNIT_HOH_VALKYRIE_MK1` 是否也有 `CLASS_HOH_VALKYRIE`。

## 已知注意事项

1. 科技前置目前用户已确认城市和 World Tracker 显示正常，但之前提过部分产出不严格依赖科技前置。不要在没要求时大改前置系统。
2. 城市详情页 UI 已与“记录时代分”类 UI 做过兼容测试，按钮挂载方式不要轻易重构。
3. `GameEvents.UnitInitialized` 和 `GameEvents.UnitCreated` 注册时已做 nil 保护，避免某个事件不存在导致整个初始化短路。
4. 修改 XML 后需要重启游戏或至少重建数据库环境再测，单纯热载存档可能看不到 XML 变更。
5. 标准 XML 解析只能检查格式合法，不能检查 Civ VI 数据库外键是否全部正确。数据库错误仍要看 `Database.log` 或进游戏验证。

