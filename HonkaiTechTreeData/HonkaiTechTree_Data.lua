-- ===========================================================================
-- 崩坏指挥终端 - 科技树节点数据分离库
-- 以后新增、修改科技节点，全部在此文件中进行！不再修改 UI 本体逻辑！
-- ===========================================================================

function GetHonkaiTechTreeData()
	return {
		-- ==============================================
		-- 远古时代 (ERA_ANCIENT)
		-- ==============================================
		-- 第 1 列 (Cost: 25)
		{
			Type = "HONKAI_TECH_PERCEPTION",
			Name = "LOC_HONKAI_TECH_PERCEPTION_NAME",
			Description = "LOC_HONKAI_TECH_PERCEPTION_DESC",
			Cost = 25,
			EraType = "ERA_ANCIENT",
			UITreeRow = 0,
			Prereqs = {},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_PERCEPTION",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_PERCEPTION_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_OMEN",
			Name = "LOC_HONKAI_TECH_OMEN_NAME",
			Description = "LOC_HONKAI_TECH_OMEN_DESC",
			Cost = 25,
			EraType = "ERA_ANCIENT",
			UITreeRow = 3,
			Prereqs = {},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_OMEN",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_OMEN_EFFECT_TOOLTIP" }
			}
		},
		-- 第 2 列 (Cost: 50)
		{
			Type = "HONKAI_TECH_PATHOLOGY",
			Name = "LOC_HONKAI_TECH_PATHOLOGY_NAME",
			Description = "LOC_HONKAI_TECH_PATHOLOGY_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_PERCEPTION"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_PATHOLOGY",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_PATHOLOGY_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_BASIC_TACTICS",
			Name = "LOC_HONKAI_TECH_BASIC_TACTICS_NAME",
			Description = "LOC_HONKAI_TECH_BASIC_TACTICS_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_PERCEPTION"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_BASIC_TACTICS",
			Unlocks = {
				{ Type = "POLICY", ID = "POLICY_HOH_ANTI_HONKAI_MANUAL", Icon = "ICON_POLICY_DISCIPLINE" }
			}
		},
		{
			Type = "HONKAI_TECH_ENERGY_CONTAINER",
			Name = "LOC_HONKAI_TECH_ENERGY_CONTAINER_NAME",
			Description = "LOC_HONKAI_TECH_ENERGY_CONTAINER_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_PERCEPTION"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_ENERGY_CONTAINER",
			Unlocks = {
				{ Type = "BUILDING", ID = "BUILDING_HOH_ENERGY_POOL" }
			}
		},
		{
			Type = "HONKAI_TECH_DESTINY_CLERGY",
			Name = "LOC_HONKAI_TECH_DESTINY_CLERGY_NAME",
			Description = "LOC_HONKAI_TECH_DESTINY_CLERGY_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_OMEN"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_DESTINY_CLERGY",
			Unlocks = {
				{ Type = "DISTRICT", ID = "DISTRICT_SCHICKSAL_HQ" },
				{ Type = "BUILDING", ID = "BUILDING_HOH_SCHICKSAL_CATHEDRAL", Icon = "ICON_BUILDING_HOH_ST_FREYA" },
				{ Type = "BUILDING", ID = "BUILDING_HOH_SCHICKSAL_CHAPEL", Icon = "ICON_BUILDING_SHRINE" },
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_DESTINY_CLERGY_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_WEAPON_PROTOTYPE",
			Name = "LOC_HONKAI_TECH_WEAPON_PROTOTYPE_NAME",
			Description = "LOC_HONKAI_TECH_WEAPON_PROTOTYPE_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_PERCEPTION"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_WEAPON_PROTOTYPE",
			Unlocks = {
				{ Type = "UNIT", ID = "UNIT_HOH_VALKYRIE_MK1" }
			}
		},
		{
			Type = "HONKAI_TECH_NUN_FORMATION",
			Name = "LOC_HONKAI_TECH_NUN_FORMATION_NAME",
			Description = "LOC_HONKAI_TECH_NUN_FORMATION_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_OMEN"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_NUN_FORMATION",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_NUN_FORMATION_EFFECT_TOOLTIP" }
			}
		},
		-- 第 3 列 (Cost: 80)
		{
			Type = "HONKAI_TECH_BASIC_ISOLATION",
			Name = "LOC_HONKAI_TECH_BASIC_ISOLATION_NAME",
			Description = "LOC_HONKAI_TECH_BASIC_ISOLATION_DESC",
			Cost = 80,
			EraType = "ERA_ANCIENT",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_PATHOLOGY", "HONKAI_TECH_ENERGY_CONTAINER"},
			Column = 3,
			ShadowCivic = "CIVIC_SHADOW_BASIC_ISOLATION",
			Unlocks = {
				{ Type = "BUILDING", ID = "BUILDING_HOH_PREMODERN_RUINS_EXCAVATION", Icon = "ICON_BUILDING_LIBRARY" },
			}
		},
		{
			Type = "HONKAI_TECH_ST_FREYA",
			Name = "LOC_HONKAI_TECH_ST_FREYA_NAME",
			Description = "LOC_HONKAI_TECH_ST_FREYA_DESC",
			Cost = 80,
			EraType = "ERA_ANCIENT",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_DESTINY_CLERGY"},
			Column = 3,
			ShadowCivic = "CIVIC_SHADOW_ST_FREYA",
			Unlocks = {
				{ Type = "BUILDING", ID = "BUILDING_HOH_ST_FREYA" }
			}
		},
		-- ==============================================
		-- 古典时代 (ERA_CLASSICAL)
		-- ==============================================
		-- 第 1 列 (Cost: 120)
		{
			Type = "HONKAI_TECH_STIGMATA_PROTOTYPE",
			Name = "LOC_HONKAI_TECH_STIGMATA_PROTOTYPE_NAME",
			Description = "LOC_HONKAI_TECH_STIGMATA_PROTOTYPE_DESC",
			Cost = 120,
			EraType = "ERA_CLASSICAL",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_BASIC_ISOLATION"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_STIGMATA_PROTOTYPE",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_STIGMATA_PROTOTYPE_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_HONKAI_FURNACE",
			Name = "LOC_HONKAI_TECH_HONKAI_FURNACE_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_FURNACE_DESC",
			Cost = 120,
			EraType = "ERA_CLASSICAL",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_BASIC_ISOLATION"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_HONKAI_FURNACE",
			Unlocks = {
				{ Type = "PROJECT", ID = "PROJECT_HOH_HONKAI_REUNION_REACTION", Icon = "ICON_PROJECT_ENHANCE_DISTRICT_INDUSTRIAL_ZONE" }
			}
		},
		{
			Type = "HONKAI_TECH_SCHICKSAL_DOCTRINE",
			Name = "LOC_HONKAI_TECH_SCHICKSAL_DOCTRINE_NAME",
			Description = "LOC_HONKAI_TECH_SCHICKSAL_DOCTRINE_DESC",
			Cost = 120,
			EraType = "ERA_CLASSICAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_ST_FREYA"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_SCHICKSAL_DOCTRINE",
			Unlocks = {
				{ Type = "POLICY", ID = "POLICY_HOH_SCHICKSAL_DOCTRINE", Icon = "ICON_POLICY_DISCIPLINE" },
				{ Type = "BUILDING", ID = "BUILDING_HOH_ATONEMENT_COURT", Icon = "ICON_BUILDING_TEMPLE" }
			}
		},
		{
			Type = "HONKAI_TECH_PRAYER_ROOM",
			Name = "LOC_HONKAI_TECH_PRAYER_ROOM_NAME",
			Description = "LOC_HONKAI_TECH_PRAYER_ROOM_DESC",
			Cost = 120,
			EraType = "ERA_CLASSICAL",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_ST_FREYA"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_PRAYER_ROOM",
			Unlocks = {
				{ Type = "IMPROVEMENT", ID = "IMPROVEMENT_HOH_PRAYER_ROOM", Icon = "ICON_BUILDING_PAGODA" },
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_PRAYER_ROOM_EFFECT_TOOLTIP" }
			}
		},
		-- 第 2 列 (Cost: 200)
		{
			Type = "HONKAI_TECH_HONKAI_CONDUCTION",
			Name = "LOC_HONKAI_TECH_HONKAI_CONDUCTION_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_CONDUCTION_DESC",
			Cost = 200,
			EraType = "ERA_CLASSICAL",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_HONKAI_FURNACE"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_HONKAI_CONDUCTION",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_HONKAI_CONDUCTION_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_ATONEMENT_SYSTEM",
			Name = "LOC_HONKAI_TECH_ATONEMENT_SYSTEM_NAME",
			Description = "LOC_HONKAI_TECH_ATONEMENT_SYSTEM_DESC",
			Cost = 200,
			EraType = "ERA_CLASSICAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_SCHICKSAL_DOCTRINE"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_ATONEMENT_SYSTEM",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_ATONEMENT_SYSTEM_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_KNIGHT_LEGACY",
			Name = "LOC_HONKAI_TECH_KNIGHT_LEGACY_NAME",
			Description = "LOC_HONKAI_TECH_KNIGHT_LEGACY_DESC",
			Cost = 200,
			EraType = "ERA_CLASSICAL",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_PRAYER_ROOM"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_KNIGHT_LEGACY",
			Unlocks = {
				{ Type = "POLICY", ID = "POLICY_HOH_KNIGHT_OATH", Icon = "ICON_POLICY_DISCIPLINE" }
			}
		},
		-- 第 3 列 (Cost: 201 - 阶梯错位)
		{
			Type = "HONKAI_TECH_POWER_ARMOR",
			Name = "LOC_HONKAI_TECH_POWER_ARMOR_NAME",
			Description = "LOC_HONKAI_TECH_POWER_ARMOR_DESC",
			Cost = 201,
			EraType = "ERA_CLASSICAL",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_STIGMATA_PROTOTYPE", "HONKAI_TECH_HONKAI_CONDUCTION"},
			Column = 3,
			ShadowCivic = "CIVIC_SHADOW_POWER_ARMOR",
			Unlocks = {
				{ Type = "POLICY", ID = "POLICY_HOH_SANGUINE_CONSTRUCT", Icon = "ICON_POLICY_DISCIPLINE" }
			}
		},
		{
			Type = "HONKAI_TECH_VALKYRIE_ADVANCED",
			Name = "LOC_HONKAI_TECH_VALKYRIE_ADVANCED_NAME",
			Description = "LOC_HONKAI_TECH_VALKYRIE_ADVANCED_DESC",
			Cost = 201,
			EraType = "ERA_CLASSICAL",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_WEAPON_PROTOTYPE", "HONKAI_TECH_ATONEMENT_SYSTEM", "HONKAI_TECH_KNIGHT_LEGACY"},
			Column = 3,
			ShadowCivic = "CIVIC_SHADOW_VALKYRIE_ADVANCED",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_VALKYRIE_ADVANCED_EFFECT_TOOLTIP" }
			}
		},
		-- ==============================================
		-- 中世纪 (ERA_MEDIEVAL)
		-- ==============================================
		-- 第 1 列 (Cost: 300)
		{
			Type = "HONKAI_TECH_STIGMATA_PRINCIPLE",
			Name = "LOC_HONKAI_TECH_STIGMATA_PRINCIPLE_NAME",
			Description = "LOC_HONKAI_TECH_STIGMATA_PRINCIPLE_DESC",
			Cost = 300,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_POWER_ARMOR"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_STIGMATA_PRINCIPLE",
			Unlocks = {
				{ Type = "BUILDING", ID = "BUILDING_HOH_STIGMATA_ALCHEMY_CHAMBER", Icon = "ICON_BUILDING_UNIVERSITY" },
				{ Type = "POLICY", ID = "POLICY_HOH_PREMODERN_MEDICAL", Icon = "ICON_POLICY_LOGISTICS" },
			}
		},
		{
			Type = "HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS",
			Name = "LOC_HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS_NAME",
			Description = "LOC_HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS_DESC",
			Cost = 300,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_POWER_ARMOR"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_GREAT_ERUPTION_HYPOTHESIS",
			Unlocks = {
				{ Type = "POLICY", ID = "POLICY_HOH_RESISTANCE_BARRIER", Icon = "ICON_POLICY_MANEUVER" },
			}
		},
		{
			Type = "HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION",
			Name = "LOC_HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION_NAME",
			Description = "LOC_HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION_DESC",
			Cost = 300,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_VALKYRIE_ADVANCED"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_VALKYRIE_BLOODLINE_PURIFICATION",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION_EFFECT_TOOLTIP" },
			}
		},
		{
			Type = "HONKAI_TECH_CLERGY_PRIVILEGE",
			Name = "LOC_HONKAI_TECH_CLERGY_PRIVILEGE_NAME",
			Description = "LOC_HONKAI_TECH_CLERGY_PRIVILEGE_DESC",
			Cost = 300,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_VALKYRIE_ADVANCED"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_CLERGY_PRIVILEGE",
			Unlocks = {
				{ Type = "POLICY", ID = "POLICY_HOH_CLERGY_PRIVILEGE", Icon = "ICON_POLICY_CITIES_FIRST" },
			}
		},
		-- 第 2 列 (Cost: 390)
		{
			Type = "HONKAI_TECH_SOULLIQUOR_SMELTING",
			Name = "LOC_HONKAI_TECH_SOULLIQUOR_SMELTING_NAME",
			Description = "LOC_HONKAI_TECH_SOULLIQUOR_SMELTING_DESC",
			Cost = 390,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_STIGMATA_PRINCIPLE", "HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_SOULLIQUOR_SMELTING",
			Unlocks = {
				{ Type = "BUILDING", ID = "BUILDING_HOH_HONKAI_SMELTER", Icon = "ICON_BUILDING_WORKSHOP" },
				{ Type = "RESOURCE", ID = "RESOURCE_HOH_FLUID_ALLOY" },
			}
		},
		{
			Type = "HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION",
			Name = "LOC_HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION_DESC",
			Cost = 390,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_HONKAI_CRYSTAL_EXTRACTION",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION_EFFECT_TOOLTIP" },
			}
		},
		{
			Type = "HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE",
			Name = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE_NAME",
			Description = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE_DESC",
			Cost = 390,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_GOD_SLAYER_ARMOR_PROTOTYPE",
			Unlocks = {
				{ Type = "UNIT", ID = "UNIT_HOH_VALKYRIE_MK2" }
			}
		},
		{
			Type = "HONKAI_TECH_SCHICKSAL_ARMED_FORMATION",
			Name = "LOC_HONKAI_TECH_SCHICKSAL_ARMED_FORMATION_NAME",
			Description = "LOC_HONKAI_TECH_SCHICKSAL_ARMED_FORMATION_DESC",
			Cost = 390,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION", "HONKAI_TECH_CLERGY_PRIVILEGE"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_SCHICKSAL_ARMED_FORMATION",
			Unlocks = {
				{ Type = "POLICY", ID = "POLICY_HOH_VALK_CHARGE", Icon = "ICON_POLICY_DISCIPLINE" },
				{ Type = "POLICY", ID = "POLICY_HOH_VALK_PHALANX", Icon = "ICON_POLICY_CONSCRIPTION" },
				{ Type = "BUILDING", ID = "BUILDING_HOH_VALKYRIE_COMMAND_CENTER", Icon = "ICON_BUILDING_BARRACKS" },
			}
		},
		-- ==============================================
		-- 文艺复兴时代 (ERA_RENAISSANCE)
		-- ==============================================
		-- 第 1 列 (Cost: 600)
		{
			Type = "HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY",
			Name = "LOC_HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY_NAME",
			Description = "LOC_HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY_DESC",
			Cost = 600,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_SOULLIQUOR_SMELTING"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_IMAGINARY_INTERFERENCE_THEORY",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_FISSION_REACTOR",
			Name = "LOC_HONKAI_TECH_FISSION_REACTOR_NAME",
			Description = "LOC_HONKAI_TECH_FISSION_REACTOR_DESC",
			Cost = 600,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_SOULLIQUOR_SMELTING"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_FISSION_REACTOR",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_FISSION_REACTOR_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_GRAY_SERPENT_NETWORK",
			Name = "LOC_HONKAI_TECH_GRAY_SERPENT_NETWORK_NAME",
			Description = "LOC_HONKAI_TECH_GRAY_SERPENT_NETWORK_DESC",
			Cost = 600,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_GRAY_SERPENT_NETWORK",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_GRAY_SERPENT_NETWORK_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_ABSOLUTE_THEOCRACY",
			Name = "LOC_HONKAI_TECH_ABSOLUTE_THEOCRACY_NAME",
			Description = "LOC_HONKAI_TECH_ABSOLUTE_THEOCRACY_DESC",
			Cost = 600,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_SCHICKSAL_ARMED_FORMATION"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_ABSOLUTE_THEOCRACY",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_ABSOLUTE_THEOCRACY_EFFECT_TOOLTIP" }
			}
		},
		-- 第 2 列 (Cost: 730)
		{
			Type = "HONKAI_TECH_STIGMATA_GENE_COMPLETION",
			Name = "LOC_HONKAI_TECH_STIGMATA_GENE_COMPLETION_NAME",
			Description = "LOC_HONKAI_TECH_STIGMATA_GENE_COMPLETION_DESC",
			Cost = 730,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY", "HONKAI_TECH_FISSION_REACTOR"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_STIGMATA_GENE_COMPLETION",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_STIGMATA_GENE_COMPLETION_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_HONKAI_ISOLATION_DOME",
			Name = "LOC_HONKAI_TECH_HONKAI_ISOLATION_DOME_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_ISOLATION_DOME_DESC",
			Cost = 730,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_FISSION_REACTOR"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_HONKAI_ISOLATION_DOME",
			Unlocks = {
				{ Type = "BUILDING", ID = "BUILDING_HOH_ISOLATION_DOME", Icon = "ICON_BUILDING_STAR_FORT" }
			}
		},
		{
			Type = "HONKAI_TECH_FANG_IN_THE_SHADOWS",
			Name = "LOC_HONKAI_TECH_FANG_IN_THE_SHADOWS_NAME",
			Description = "LOC_HONKAI_TECH_FANG_IN_THE_SHADOWS_DESC",
			Cost = 730,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_GRAY_SERPENT_NETWORK"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_FANG_IN_THE_SHADOWS",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_FANG_IN_THE_SHADOWS_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT",
			Name = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT_NAME",
			Description = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT_DESC",
			Cost = 730,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_ABSOLUTE_THEOCRACY"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_GOD_SLAYER_ARMOR_DEPLOYMENT",
			Unlocks = {
				{ Type = "UNIT", ID = "UNIT_HOH_VALKYRIE_MK3" }
			}
		},
		{
			Type = "HONKAI_TECH_FLOATING_ISLAND_TECH",
			Name = "LOC_HONKAI_TECH_FLOATING_ISLAND_TECH_NAME",
			Description = "LOC_HONKAI_TECH_FLOATING_ISLAND_TECH_DESC",
			Cost = 730,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_ABSOLUTE_THEOCRACY"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_FLOATING_ISLAND_TECH",
			Unlocks = {
				{ Type = "BUILDING", ID = "BUILDING_HOH_FLOATING_ISLAND_PLATFORM", Icon = "ICON_BUILDING_BARRACKS" }
			}
		},
		-- ==============================================
		-- 工业时代 (ERA_INDUSTRIAL) [主线断绝，逆熵与世界蛇爆发]
		-- ==============================================
		-- 第 1 列 (Cost: 930)
		{
			Type = "HONKAI_TECH_STIGMATA_SCREENING",
			Name = "LOC_HONKAI_TECH_STIGMATA_SCREENING_NAME",
			Description = "LOC_HONKAI_TECH_STIGMATA_SCREENING_DESC",
			Cost = 930,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY", "HONKAI_TECH_FANG_IN_THE_SHADOWS"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_STIGMATA_SCREENING",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_STIGMATA_SCREENING_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_GENE_TOXIN",
			Name = "LOC_HONKAI_TECH_GENE_TOXIN_NAME",
			Description = "LOC_HONKAI_TECH_GENE_TOXIN_DESC",
			Cost = 930,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_STIGMATA_GENE_COMPLETION"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_GENE_TOXIN",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_GENE_TOXIN_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_TACTICAL_TITAN",
			Name = "LOC_HONKAI_TECH_TACTICAL_TITAN_NAME",
			Description = "LOC_HONKAI_TECH_TACTICAL_TITAN_DESC",
			Cost = 930,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_HONKAI_ISOLATION_DOME"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_TACTICAL_TITAN",
			Unlocks = {
				{ Type = "DISTRICT", ID = "DISTRICT_ANTI_ENTROPY_HQ" },
				{ Type = "BUILDING", ID = "BUILDING_HOH_CENTRAL_MECHA_ARCHIVE", Icon = "ICON_BUILDING_BARRACKS" }
			}
		},
		{
			Type = "HONKAI_TECH_AE_MANUFACTURING",
			Name = "LOC_HONKAI_TECH_AE_MANUFACTURING_NAME",
			Description = "LOC_HONKAI_TECH_AE_MANUFACTURING_DESC",
			Cost = 930,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_AE_MANUFACTURING",
			Unlocks = {
				{ Type = "POLICY", ID = "POLICY_HOH_AE_MANUFACTURING_STANDARD", Icon = "ICON_POLICY_DISCIPLINE" },
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_AE_MANUFACTURING_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_SCHICKSAL_GEN4",
			Name = "LOC_HONKAI_TECH_SCHICKSAL_GEN4_NAME",
			Description = "LOC_HONKAI_TECH_SCHICKSAL_GEN4_DESC",
			Cost = 930,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_FLOATING_ISLAND_TECH"},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_SCHICKSAL_GEN4",
			Unlocks = {
				{ Type = "UNIT", ID = "UNIT_HOH_VALKYRIE_MK4" },
				{ Type = "POLICY", ID = "POLICY_HOH_VALKYRIE_MOBILIZATION", Icon = "ICON_POLICY_CONSCRIPTION" }
			}
		},
		-- 第 2 列 (Cost: 1070)
		{
			Type = "HONKAI_TECH_MANTIS_EXPERIMENT",
			Name = "LOC_HONKAI_TECH_MANTIS_EXPERIMENT_NAME",
			Description = "LOC_HONKAI_TECH_MANTIS_EXPERIMENT_DESC",
			Cost = 1070,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_STIGMATA_SCREENING", "HONKAI_TECH_GENE_TOXIN"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_MANTIS_EXPERIMENT",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_MANTIS_EXPERIMENT_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_TITAN_PRODUCTION_LINE",
			Name = "LOC_HONKAI_TECH_TITAN_PRODUCTION_LINE_NAME",
			Description = "LOC_HONKAI_TECH_TITAN_PRODUCTION_LINE_DESC",
			Cost = 1070,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_TACTICAL_TITAN"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_TITAN_PRODUCTION_LINE",
			Unlocks = {
				{ Type = "POLICY", ID = "POLICY_HOH_HEAVY_MOBILIZATION", Icon = "ICON_POLICY_DISCIPLINE" }
			}
		},
		{
			Type = "HONKAI_TECH_HONKAI_REVERSE_ENGINEERING",
			Name = "LOC_HONKAI_TECH_HONKAI_REVERSE_ENGINEERING_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_REVERSE_ENGINEERING_DESC",
			Cost = 1070,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_AE_MANUFACTURING"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_HONKAI_REVERSE_ENGINEERING",
			Unlocks = {
				{ Type = "GENERIC", ID = "LOC_HONKAI_TECH_HONKAI_REVERSE_ENGINEERING_EFFECT_TOOLTIP" }
			}
		},
		{
			Type = "HONKAI_TECH_HEAVY_ARTILLERY_MECHA",
			Name = "LOC_HONKAI_TECH_HEAVY_ARTILLERY_MECHA_NAME",
			Description = "LOC_HONKAI_TECH_HEAVY_ARTILLERY_MECHA_DESC",
			Cost = 1070,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_AE_MANUFACTURING"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_HEAVY_ARTILLERY_MECHA",
			Unlocks = {
				{ Type = "BUILDING", ID = "BUILDING_HOH_MECHA_ASSEMBLY_FACTORY", Icon = "ICON_BUILDING_FACTORY" },
				{ Type = "UNIT", ID = "UNIT_HOH_TITAN_MK1" },
				{ Type = "UNIT", ID = "UNIT_HOH_THUNDER_MK1" }
			}
		},
		-- ==============================================
		-- 现代 (ERA_MODERN)
		-- ==============================================
		-- 第 1 列 (Cost: 1250)
		{
			Type = "HONKAI_TECH_MANTIS_SURGERY",
			Name = "LOC_HONKAI_TECH_MANTIS_SURGERY_NAME",
			Description = "LOC_HONKAI_TECH_MANTIS_SURGERY_DESC",
			Cost = 1250,
			EraType = "ERA_MODERN",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_MANTIS_EXPERIMENT"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_ELYSIAN_REALM",
			Name = "LOC_HONKAI_TECH_ELYSIAN_REALM_NAME",
			Description = "LOC_HONKAI_TECH_ELYSIAN_REALM_DESC",
			Cost = 1250,
			EraType = "ERA_MODERN",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_MANTIS_EXPERIMENT"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_STEALTH_ARMOR",
			Name = "LOC_HONKAI_TECH_STEALTH_ARMOR_NAME",
			Description = "LOC_HONKAI_TECH_STEALTH_ARMOR_DESC",
			Cost = 1250,
			EraType = "ERA_MODERN",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_TITAN_PRODUCTION_LINE"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_DEEP_SEA_BLUEPRINT",
			Name = "LOC_HONKAI_TECH_DEEP_SEA_BLUEPRINT_NAME",
			Description = "LOC_HONKAI_TECH_DEEP_SEA_BLUEPRINT_DESC",
			Cost = 1250,
			EraType = "ERA_MODERN",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_HONKAI_REVERSE_ENGINEERING", "HONKAI_TECH_HEAVY_ARTILLERY_MECHA"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_VALKYRIE_LIMIT",
			Name = "LOC_HONKAI_TECH_VALKYRIE_LIMIT_NAME",
			Description = "LOC_HONKAI_TECH_VALKYRIE_LIMIT_DESC",
			Cost = 1250,
			EraType = "ERA_MODERN",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_SCHICKSAL_GEN4"},
			Column = 1
		},
		-- 第 2 列 (Cost: 1370)
		{
			Type = "HONKAI_TECH_MEMORY_EXTRACTION",
			Name = "LOC_HONKAI_TECH_MEMORY_EXTRACTION_NAME",
			Description = "LOC_HONKAI_TECH_MEMORY_EXTRACTION_DESC",
			Cost = 1370,
			EraType = "ERA_MODERN",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_MANTIS_SURGERY"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_EXTREME_BIO_WEAPON",
			Name = "LOC_HONKAI_TECH_EXTREME_BIO_WEAPON_NAME",
			Description = "LOC_HONKAI_TECH_EXTREME_BIO_WEAPON_DESC",
			Cost = 1370,
			EraType = "ERA_MODERN",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_ELYSIAN_REALM"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_AUTO_REPAIR_MATRIX",
			Name = "LOC_HONKAI_TECH_AUTO_REPAIR_MATRIX_NAME",
			Description = "LOC_HONKAI_TECH_AUTO_REPAIR_MATRIX_DESC",
			Cost = 1370,
			EraType = "ERA_MODERN",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_STEALTH_ARMOR"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_SALT_LAKE_CORE",
			Name = "LOC_HONKAI_TECH_SALT_LAKE_CORE_NAME",
			Description = "LOC_HONKAI_TECH_SALT_LAKE_CORE_DESC",
			Cost = 1350,
			EraType = "ERA_MODERN",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_TITAN_PRODUCTION_LINE"},
			Column = 2,
			Unlocks = {
				{ Type = "BUILDING", ID = "BUILDING_HOH_CORE_WORKSHOP" }
			}
		},
		-- ==============================================
		-- 原子能时代 (ERA_ATOMIC)
		-- ==============================================
		-- 第 1 列 (Cost: 1480)
		{
			Type = "HONKAI_TECH_STIGMATA_PLAN_EXECUTION",
			Name = "LOC_HONKAI_TECH_STIGMATA_PLAN_EXECUTION_NAME",
			Description = "LOC_HONKAI_TECH_STIGMATA_PLAN_EXECUTION_DESC",
			Cost = 1480,
			EraType = "ERA_ATOMIC",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_MEMORY_EXTRACTION"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_DIMENSIONAL_STRIKE_PREP",
			Name = "LOC_HONKAI_TECH_DIMENSIONAL_STRIKE_PREP_NAME",
			Description = "LOC_HONKAI_TECH_DIMENSIONAL_STRIKE_PREP_DESC",
			Cost = 1480,
			EraType = "ERA_ATOMIC",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_EXTREME_BIO_WEAPON"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_ARAHATO_PROJECT",
			Name = "LOC_HONKAI_TECH_ARAHATO_PROJECT_NAME",
			Description = "LOC_HONKAI_TECH_ARAHATO_PROJECT_DESC",
			Cost = 1480,
			EraType = "ERA_ATOMIC",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_AUTO_REPAIR_MATRIX"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_HONKAI_FURNACE_OVERLOAD",
			Name = "LOC_HONKAI_TECH_HONKAI_FURNACE_OVERLOAD_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_FURNACE_OVERLOAD_DESC",
			Cost = 1480,
			EraType = "ERA_ATOMIC",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_SALT_LAKE_CORE"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_IMAGINARY_TREE_SIMULATION",
			Name = "LOC_HONKAI_TECH_IMAGINARY_TREE_SIMULATION_NAME",
			Description = "LOC_HONKAI_TECH_IMAGINARY_TREE_SIMULATION_DESC",
			Cost = 1480,
			EraType = "ERA_ATOMIC",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_VALKYRIE_LIMIT"},
			Column = 1
		},
		-- 第 2 列 (Cost: 1660)
		{
			Type = "HONKAI_TECH_IMAGINARY_CORRUPTION",
			Name = "LOC_HONKAI_TECH_IMAGINARY_CORRUPTION_NAME",
			Description = "LOC_HONKAI_TECH_IMAGINARY_CORRUPTION_DESC",
			Cost = 1660,
			EraType = "ERA_ATOMIC",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_STIGMATA_PLAN_EXECUTION", "HONKAI_TECH_DIMENSIONAL_STRIKE_PREP"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_GLOBAL_SATURATION_STRIKE",
			Name = "LOC_HONKAI_TECH_GLOBAL_SATURATION_STRIKE_NAME",
			Description = "LOC_HONKAI_TECH_GLOBAL_SATURATION_STRIKE_DESC",
			Cost = 1660,
			EraType = "ERA_ATOMIC",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_ARAHATO_PROJECT"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_AE_AUTONOMOUS_DEFENSE",
			Name = "LOC_HONKAI_TECH_AE_AUTONOMOUS_DEFENSE_NAME",
			Description = "LOC_HONKAI_TECH_AE_AUTONOMOUS_DEFENSE_DESC",
			Cost = 1660,
			EraType = "ERA_ATOMIC",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_HONKAI_FURNACE_OVERLOAD"},
			Column = 2
		},
		-- ==============================================
		-- 信息时代 (ERA_INFORMATION) [天命落幕，蛇与逆熵对决]
		-- ==============================================
		-- 第 1 列 (Cost: 1850)
		{
			Type = "HONKAI_TECH_SEA_OF_QUANTA_ROAMING",
			Name = "LOC_HONKAI_TECH_SEA_OF_QUANTA_ROAMING_NAME",
			Description = "LOC_HONKAI_TECH_SEA_OF_QUANTA_ROAMING_DESC",
			Cost = 1850,
			EraType = "ERA_INFORMATION",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_IMAGINARY_CORRUPTION"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_HUMAN_STIGMATIZATION",
			Name = "LOC_HONKAI_TECH_HUMAN_STIGMATIZATION_NAME",
			Description = "LOC_HONKAI_TECH_HUMAN_STIGMATIZATION_DESC",
			Cost = 1850,
			EraType = "ERA_INFORMATION",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_IMAGINARY_CORRUPTION"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_SELENA",
			Name = "LOC_HONKAI_TECH_SELENA_NAME",
			Description = "LOC_HONKAI_TECH_SELENA_DESC",
			Cost = 1850,
			EraType = "ERA_INFORMATION",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_GLOBAL_SATURATION_STRIKE"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_MECHA_AUTONOMOUS_AWAKENING",
			Name = "LOC_HONKAI_TECH_MECHA_AUTONOMOUS_AWAKENING_NAME",
			Description = "LOC_HONKAI_TECH_MECHA_AUTONOMOUS_AWAKENING_DESC",
			Cost = 1850,
			EraType = "ERA_INFORMATION",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_AE_AUTONOMOUS_DEFENSE"},
			Column = 1
		},
		-- 第 2 列 (Cost: 2155)
		{
			Type = "HONKAI_TECH_MARK_OF_THE_SERPENT",
			Name = "LOC_HONKAI_TECH_MARK_OF_THE_SERPENT_NAME",
			Description = "LOC_HONKAI_TECH_MARK_OF_THE_SERPENT_DESC",
			Cost = 2155,
			EraType = "ERA_INFORMATION",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_SEA_OF_QUANTA_ROAMING", "HONKAI_TECH_HUMAN_STIGMATIZATION"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_CORE_OF_REASON_RESONANCE",
			Name = "LOC_HONKAI_TECH_CORE_OF_REASON_RESONANCE_NAME",
			Description = "LOC_HONKAI_TECH_CORE_OF_REASON_RESONANCE_DESC",
			Cost = 2155,
			EraType = "ERA_INFORMATION",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_SELENA", "HONKAI_TECH_MECHA_AUTONOMOUS_AWAKENING"},
			Column = 2
		},
		-- ==============================================
		-- 未来时代 (ERA_FUTURE) [三极归一，终焉降临]
		-- ==============================================
		{
			Type = "HONKAI_TECH_KEY_OF_FINALITY",
			Name = "LOC_HONKAI_TECH_KEY_OF_FINALITY_NAME",
			Description = "LOC_HONKAI_TECH_KEY_OF_FINALITY_DESC",
			Cost = 3600,
			EraType = "ERA_FUTURE",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_MARK_OF_THE_SERPENT", "HONKAI_TECH_CORE_OF_REASON_RESONANCE", "HONKAI_TECH_IMAGINARY_TREE_SIMULATION"},
			Column = 1
		}
	}
end
