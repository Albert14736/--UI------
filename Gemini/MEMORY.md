# 崩坏指挥终端 - 核心设计与开发备忘录

## 1. 核心架构与资源系统
- **双轨资源设计**:
    - **崩坏能研究点 (Honkai Research Points)**: 专用于独立 UI 面板解锁【崩坏科技】。每回合产出逻辑位于 `HonkaiEnergySystem.lua`，通过 `HONKAI_RESEARCH_POINTS` 属性保存。
    - **战术崩坏能 (Honkai Energy)**: 战术施法资源。产出公式：`(领土总格数 × 0.1) × (1 + 城市人口 × 0.05) × (1 + (改良设施 + 区域 + 建筑) × 0.02)`。每研究一个崩坏科技，产出 +5%。
- **存储上限机制**: 基础 +50 (城市), +100 (军营), +50 (城墙), +1000 (能源容器雏形)。溢出将产生【崩坏污染】 (核辐射效果)。

## 2. 桥接机制 (Bridge Mechanism)
- **影子市政桥接 (Shadow Civic Bridge)**: 
    - **逻辑**: Lua 面板解锁科技 -> `HonkaiEnergySystem.lua` 调用 `pCulture:SetCivic(index, true)` -> 瞬间激活 XML 中绑定的影子市政权限。
    - **映射表**: 见 `HonkaiEnergySystem.lua` 中的 `ShadowCivicMap`。

## 3. 区域与建筑体系
- **三大帝国总部 (Headquarters)**: `DISTRICT_SCHICKSAL_HQ`, `DISTRICT_ANTI_ENTROPY_HQ`, `DISTRICT_WORLD_SERPENT_HQ`。
- **三大常规支部 (Branches)**: `DISTRICT_SCHICKSAL_BRANCH` (替圣地), `DISTRICT_ARMED_INDUSTRY` (替工业区), `DISTRICT_HIDDEN_RESEARCH` (替学院)。
- **区域图标全覆盖**: 三大总部 (HQ) 与三大支部 (Branch) 已完成图标定义（`Icons.xml`），支部强制指向总部图集索引。

## 4. 图标系统稳定准则 (2026/05/17)
- **VFS 路径匹配**: 在 `.modinfo` 的 `ImportFiles` 中导入的 loose DDS 文件，在 `Icons.xml` 和 `.ggxml` 引用时必须包含完整的子文件夹路径（例如 `ResourceAndText_Textures/xxx_22.dds`），否则会导致透明空白或渲染失败。
- **FontIcon 模式**: 采用 `<fontTextureAtlas>` 模式，通过 `<texture>` 显式指向带路径和后缀的 DDS 对象。支持 `ICON_RESOURCE_...` 和 `ICON_...` 双重标签映射。
- **UI 健壮性**: 科技树主 Lua 脚本已增加数据文件 `include` 失败检查，防止因文件缺失导致的入口按钮静默消失。

## 7. 智能体工作流 (Agent Workflow)
- **自动化同步 (2026/05/18)**: 已配置 `GEMINI.md` 强制要求智能体在每轮对话后提取有意义的架构决策、Bug 修复及样式准则，并同步至此 `MEMORY.md` 文件。
- **环境上下文**: 当前工作区包含多个 Steam 创意工坊参考模组及本地日志目录，需优先使用 `grep_search` 进行跨目录检索。
- **Lua 语法检查环境 (2026/05/20)**: 用户目录 `C:\Users\alber\Tools\Lua51` 安装 LuaBinaries 5.1.5，并提供 `lua`/`luac` 命令；可用 `luac -p` 检查本模组普通 Lua 文件。注意 Civ VI 原版部分 UI Lua 使用 Firaxis/HKS 类型标注扩展（如 `name:string`），标准 `luac` 全量扫描会在这些文件上误报。
- **后续 AI 交接文档 (2026/05/20)**: `Gemini/AI_HANDOFF.md` 记录了当前系统进度、关键文件、动态 UnitAbility 踩坑、Lua/XML/概率表检查命令和游戏内测试流程。后续低上下文或弱模型接手时应先读该文档。

## 5. 当前开发进度
- **时代进度**: 远古时代已实装。
- **稳定里程碑**: 局内领袖立绘、六大特色区域图标、全资源字体图标已打通。
- **动态 UI 系统 (2026/05/18)**: 
    - **World Tracker Tooltips**: 实现了资源产出的动态明细显示。
    - **UI 对齐优化**: 宽度锁定为 `296`，实现了像素级对齐。
    - **科技树强化 (Phase 1)**: 实装了“回合阻断”逻辑。如果未选择崩坏研究项目，面板会在回合开始时自动弹出，并拦截 ESC 和关闭指令，直到玩家选定目标。
    - **计算统一化**: 通过 `ExposedMembers.Honkai` 将底层计算逻辑暴露给 UI。
    - **公式实装**: 战术崩坏能产出公式 `(地格×0.1) × (1+人口×0.05) × (1+基建×0.02)` 已从大纲转为 Lua 实现。
    - **产出逻辑修复 (2026/05/20)**: `CityDistricts` 对象不支持 `Members()` 遍历；统计城市区域数时改用 `GetNumDistricts()`，并保留扫描 `GameInfo.Districts()` + `HasDistrict()` 的兜底。
    - **单城明细按钮 (2026/05/20)**: 新增 `UI/HonkaiCityPanel`，挂载到 `/InGame/CityPanel/MainPanel` 左侧，通过 `ExposedMembers.Honkai.CalculateHonkaiCityEnergyBreakdown` 展示本城战术崩坏能公式拆分。
    - **女武神训练等级调试层 (2026/05/20)**: `HonkaiEnergySystem.lua` 新增 `CalculateValkyrieTrainingBreakdown`，以基础 Lv1、训练科技、圣芙蕾雅学园的帝国/本城加成为来源；`UI/HonkaiWorldTracker` 展示帝国训练等级并在 Tooltip 中列出每城最终等级。
    - **女武神随机评级系统 (2026/05/20)**: `HonkaiEnergySystem.lua` 基于城市最终训练等级 Lv1-Lv10 使用权重表随机分配 F/E/D/C/B/A/S 评级，并通过动态 `UnitAbility` 赋予战斗力 +0/+1/+2/+3/+5/+8/+12；`Honkai_Civilization.xml` 定义评级能力、Modifier 与 `CLASS_HOH_VALKYRIE` TypeTags，`UI/HonkaiCityPanel` 新增本城女武神评级概率按钮。动态单位能力必须同时具备 `UnitAbilities`、`UnitAbilityModifiers` 和匹配单位的 `TypeTags`，否则 `ChangeAbilityCount` 不会产生规则效果。
    - **过回合卡死修复 (2026/05/20)**: 科研队列在 `GameEvents.PlayerTurnStarted` 自动结算时不再跨 Gameplay/UI 上下文调用 `ExposedMembers.HonkaiUI.RefreshUI`；`UI/HonkaiTechTree` 的回合结束关闭改为强制关闭，避免“未选择崩坏研究”拦截把模态窗口留到 AI 回合。
- **视觉风格准则 (2026/05/17)**:
    - **加载界面画布**: 统一采用淡紫色（RGBA: 180, 140, 230, 38），约 15% 不透明度，确保极致通透感且不遮挡背景立绘。
    - **路径强引用**: 加载界面（LoadingInfo）散图引用必须补全 `Textures/` 前缀。
- **区域相邻加成准则 (2026/05/17)**:
    - **原版加成继承**: 特色区域不会自动继承原版加成，必须手动在 `District_Adjacencies` 中补全。
    - **全地形山脉兼容**: 由于数据库不支持标签列，已通过手动罗列 5 种山脉地形 ID（`TERRAIN_GRASS_MOUNTAIN` 等）实现全兼容。
    - **总部全局辐射**: 通过在 `District_Adjacencies` 中将总部专属 ID 映射给游戏内所有区域（包括原版和基建区域），实现了大纲要求的“总部向相邻任何区域提供加成”的设定。

## 6. 关键文件索引
- `Honkai_UI_Test.modinfo`: 模组装载配置。
- `HonkaiTechTreeData/HonkaiTechTree_Data.lua`: 科技树节点数据库。
- `HonkaiEnergySystem.lua`: 核心逻辑、资源管理、桥接控制。
- `Honkai_Civilization.xml`: 区域定义。
- `Icons.xml`: 全局图标映射。
- `Honkai_FontIcons.ggxml`: 字体图标映射。
