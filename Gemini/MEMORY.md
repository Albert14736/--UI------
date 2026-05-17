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

## 5. 当前开发进度
- **时代进度**: 远古时代已实装。
- **稳定里程碑**: 局内领袖立绘、六大特色区域图标、全资源字体图标已打通。

## 6. 关键文件索引
- `Honkai_UI_Test.modinfo`: 模组装载配置。
- `HonkaiTechTreeData/HonkaiTechTree_Data.lua`: 科技树节点数据库。
- `HonkaiEnergySystem.lua`: 核心逻辑、资源管理、桥接控制。
- `Honkai_Civilization.xml`: 区域定义。
- `Icons.xml`: 全局图标映射。
- `Honkai_FontIcons.ggxml`: 字体图标映射。
