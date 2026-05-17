-- ===========================================================================
-- 崩坏指挥终端 - 科技树节点数据分离库
-- 以后新增、修改科技节点，全部在此文件中进行！不再修改 UI 本体逻辑！
-- ===========================================================================

function GetHonkaiTechTreeData()
	return {
		-- ==============================================
		-- 远古时代 (ERA_ANCIENT)
		-- ==============================================
		-- 第 1 列
		{
			Type = "HONKAI_TECH_PERCEPTION",
			Name = "LOC_HONKAI_TECH_PERCEPTION_NAME",
			Description = "LOC_HONKAI_TECH_PERCEPTION_DESC",
			Cost = 25,
			EraType = "ERA_ANCIENT",
			UITreeRow = 0,
			Prereqs = {},
			Column = 1,
			ShadowCivic = "CIVIC_SHADOW_PERCEPTION"
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
			ShadowCivic = "CIVIC_SHADOW_OMEN"
		},
		-- 第 2 列
		{
			Type = "HONKAI_TECH_PATHOLOGY",
			Name = "LOC_HONKAI_TECH_PATHOLOGY_NAME",
			Description = "LOC_HONKAI_TECH_PATHOLOGY_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_PERCEPTION"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_PATHOLOGY"
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
			ShadowCivic = "CIVIC_SHADOW_BASIC_TACTICS"
		},
		{
			Type = "HONKAI_TECH_ENERGY_CONTAINER",
			Name = "LOC_HONKAI_TECH_ENERGY_CONTAINER_NAME",
			Description = "LOC_HONKAI_TECH_ENERGY_CONTAINER_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_PERCEPTION"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_ENERGY_CONTAINER"
		},
		{
			Type = "HONKAI_TECH_DESTINY_CLERGY",
			Name = "LOC_HONKAI_TECH_DESTINY_CLERGY_NAME",
			Description = "LOC_HONKAI_TECH_DESTINY_CLERGY_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_OMEN"},
			Column = 2,
			ShadowCivic = "CIVIC_SHADOW_DESTINY_CLERGY"
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
			ShadowCivic = "CIVIC_SHADOW_NUN_FORMATION"
		},
		-- 第 3 列
		{
			Type = "HONKAI_TECH_BASIC_ISOLATION",
			Name = "LOC_HONKAI_TECH_BASIC_ISOLATION_NAME",
			Description = "LOC_HONKAI_TECH_BASIC_ISOLATION_DESC",
			Cost = 80,
			EraType = "ERA_ANCIENT",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_PATHOLOGY", "HONKAI_TECH_ENERGY_CONTAINER"},
			Column = 3,
			ShadowCivic = "CIVIC_SHADOW_BASIC_ISOLATION"
		},
		{
			Type = "HONKAI_TECH_ST_FREYA",
			Name = "LOC_HONKAI_TECH_ST_FREYA_NAME",
			Description = "LOC_HONKAI_TECH_ST_FREYA_DESC",
			Cost = 80,
			EraType = "ERA_ANCIENT",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_PERCEPTION", "HONKAI_TECH_OMEN"},
			Column = 3,
			ShadowCivic = "CIVIC_SHADOW_ST_FREYA"
		},
		-- 第 4 列
		{
			Type = "HONKAI_TECH_WEAPON_PROTOTYPE",
			Name = "LOC_HONKAI_TECH_WEAPON_PROTOTYPE_NAME",
			Description = "LOC_HONKAI_TECH_WEAPON_PROTOTYPE_DESC",
			Cost = 80,
			EraType = "ERA_ANCIENT",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_ST_FREYA"},
			Column = 4,
			ShadowCivic = "CIVIC_SHADOW_WEAPON_PROTOTYPE"
		},
		-- ==============================================
		-- 古典时代 (ERA_CLASSICAL)
		-- ==============================================
		-- 第 1 列
		{
			Type = "HONKAI_TECH_STIGMATA_PROTOTYPE",
			Name = "LOC_HONKAI_TECH_STIGMATA_PROTOTYPE_NAME",
			Description = "LOC_HONKAI_TECH_STIGMATA_PROTOTYPE_DESC",
			Cost = 120,
			EraType = "ERA_CLASSICAL",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_BASIC_ISOLATION"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_HONKAI_FURNACE",
			Name = "LOC_HONKAI_TECH_HONKAI_FURNACE_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_FURNACE_DESC",
			Cost = 120,
			EraType = "ERA_CLASSICAL",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_BASIC_ISOLATION"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_SCHICKSAL_DOCTRINE",
			Name = "LOC_HONKAI_TECH_SCHICKSAL_DOCTRINE_NAME",
			Description = "LOC_HONKAI_TECH_SCHICKSAL_DOCTRINE_DESC",
			Cost = 120,
			EraType = "ERA_CLASSICAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_ST_FREYA"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_PRAYER_ROOM",
			Name = "LOC_HONKAI_TECH_PRAYER_ROOM_NAME",
			Description = "LOC_HONKAI_TECH_PRAYER_ROOM_DESC",
			Cost = 120,
			EraType = "ERA_CLASSICAL",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_ST_FREYA"},
			Column = 1
		},
		-- 第 2 列
		{
			Type = "HONKAI_TECH_HONKAI_CONDUCTION",
			Name = "LOC_HONKAI_TECH_HONKAI_CONDUCTION_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_CONDUCTION_DESC",
			Cost = 200,
			EraType = "ERA_CLASSICAL",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_HONKAI_FURNACE"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_ATONEMENT_SYSTEM",
			Name = "LOC_HONKAI_TECH_ATONEMENT_SYSTEM_NAME",
			Description = "LOC_HONKAI_TECH_ATONEMENT_SYSTEM_DESC",
			Cost = 200,
			EraType = "ERA_CLASSICAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_SCHICKSAL_DOCTRINE"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_KNIGHT_LEGACY",
			Name = "LOC_HONKAI_TECH_KNIGHT_LEGACY_NAME",
			Description = "LOC_HONKAI_TECH_KNIGHT_LEGACY_DESC",
			Cost = 200,
			EraType = "ERA_CLASSICAL",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_PRAYER_ROOM"},
			Column = 2
		},
		-- 第 3 列
		{
			Type = "HONKAI_TECH_POWER_ARMOR",
			Name = "LOC_HONKAI_TECH_POWER_ARMOR_NAME",
			Description = "LOC_HONKAI_TECH_POWER_ARMOR_DESC",
			Cost = 200,
			EraType = "ERA_CLASSICAL",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_STIGMATA_PROTOTYPE", "HONKAI_TECH_HONKAI_CONDUCTION"},
			Column = 3
		},
		{
			Type = "HONKAI_TECH_VALKYRIE_ADVANCED",
			Name = "LOC_HONKAI_TECH_VALKYRIE_ADVANCED_NAME",
			Description = "LOC_HONKAI_TECH_VALKYRIE_ADVANCED_DESC",
			Cost = 200,
			EraType = "ERA_CLASSICAL",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_WEAPON_PROTOTYPE", "HONKAI_TECH_ATONEMENT_SYSTEM", "HONKAI_TECH_KNIGHT_LEGACY"},
			Column = 3
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
			Column = 1
		},
		{
			Type = "HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS",
			Name = "LOC_HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS_NAME",
			Description = "LOC_HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS_DESC",
			Cost = 300,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_POWER_ARMOR"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION",
			Name = "LOC_HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION_NAME",
			Description = "LOC_HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION_DESC",
			Cost = 300,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_VALKYRIE_ADVANCED"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_CLERGY_PRIVILEGE",
			Name = "LOC_HONKAI_TECH_CLERGY_PRIVILEGE_NAME",
			Description = "LOC_HONKAI_TECH_CLERGY_PRIVILEGE_DESC",
			Cost = 300,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_VALKYRIE_ADVANCED"},
			Column = 1
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
			Column = 2
		},
		{
			Type = "HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION",
			Name = "LOC_HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION_DESC",
			Cost = 390,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE",
			Name = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE_NAME",
			Description = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE_DESC",
			Cost = 390,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_SCHICKSAL_ARMED_FORMATION",
			Name = "LOC_HONKAI_TECH_SCHICKSAL_ARMED_FORMATION_NAME",
			Description = "LOC_HONKAI_TECH_SCHICKSAL_ARMED_FORMATION_DESC",
			Cost = 390,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION", "HONKAI_TECH_CLERGY_PRIVILEGE"},
			Column = 2
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
			Column = 1
		},
		{
			Type = "HONKAI_TECH_FISSION_REACTOR",
			Name = "LOC_HONKAI_TECH_FISSION_REACTOR_NAME",
			Description = "LOC_HONKAI_TECH_FISSION_REACTOR_DESC",
			Cost = 600,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_SOULLIQUOR_SMELTING"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_GRAY_SERPENT_NETWORK",
			Name = "LOC_HONKAI_TECH_GRAY_SERPENT_NETWORK_NAME",
			Description = "LOC_HONKAI_TECH_GRAY_SERPENT_NETWORK_DESC",
			Cost = 600,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_ABSOLUTE_THEOCRACY",
			Name = "LOC_HONKAI_TECH_ABSOLUTE_THEOCRACY_NAME",
			Description = "LOC_HONKAI_TECH_ABSOLUTE_THEOCRACY_DESC",
			Cost = 600,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_SCHICKSAL_ARMED_FORMATION"},
			Column = 1
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
			Column = 2
		},
		{
			Type = "HONKAI_TECH_HONKAI_ISOLATION_DOME",
			Name = "LOC_HONKAI_TECH_HONKAI_ISOLATION_DOME_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_ISOLATION_DOME_DESC",
			Cost = 730,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_FISSION_REACTOR"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_FANG_IN_THE_SHADOWS",
			Name = "LOC_HONKAI_TECH_FANG_IN_THE_SHADOWS_NAME",
			Description = "LOC_HONKAI_TECH_FANG_IN_THE_SHADOWS_DESC",
			Cost = 730,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_GRAY_SERPENT_NETWORK"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT",
			Name = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT_NAME",
			Description = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT_DESC",
			Cost = 730,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_ABSOLUTE_THEOCRACY"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_FLOATING_ISLAND_TECH",
			Name = "LOC_HONKAI_TECH_FLOATING_ISLAND_TECH_NAME",
			Description = "LOC_HONKAI_TECH_FLOATING_ISLAND_TECH_DESC",
			Cost = 730,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_ABSOLUTE_THEOCRACY"},
			Column = 2
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
			Column = 1
		},
		{
			Type = "HONKAI_TECH_GENE_TOXIN",
			Name = "LOC_HONKAI_TECH_GENE_TOXIN_NAME",
			Description = "LOC_HONKAI_TECH_GENE_TOXIN_DESC",
			Cost = 930,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_STIGMATA_GENE_COMPLETION"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_TACTICAL_TITAN",
			Name = "LOC_HONKAI_TECH_TACTICAL_TITAN_NAME",
			Description = "LOC_HONKAI_TECH_TACTICAL_TITAN_DESC",
			Cost = 930,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_HONKAI_ISOLATION_DOME"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_AE_MANUFACTURING",
			Name = "LOC_HONKAI_TECH_AE_MANUFACTURING_NAME",
			Description = "LOC_HONKAI_TECH_AE_MANUFACTURING_DESC",
			Cost = 930,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_SCHICKSAL_GEN4",
			Name = "LOC_HONKAI_TECH_SCHICKSAL_GEN4_NAME",
			Description = "LOC_HONKAI_TECH_SCHICKSAL_GEN4_DESC",
			Cost = 930,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_FLOATING_ISLAND_TECH"},
			Column = 1
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
			Column = 2
		},
		{
			Type = "HONKAI_TECH_TITAN_PRODUCTION_LINE",
			Name = "LOC_HONKAI_TECH_TITAN_PRODUCTION_LINE_NAME",
			Description = "LOC_HONKAI_TECH_TITAN_PRODUCTION_LINE_DESC",
			Cost = 1070,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_TACTICAL_TITAN"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_HONKAI_REVERSE_ENGINEERING",
			Name = "LOC_HONKAI_TECH_HONKAI_REVERSE_ENGINEERING_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_REVERSE_ENGINEERING_DESC",
			Cost = 1070,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_AE_MANUFACTURING"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_HEAVY_ARTILLERY_MECHA",
			Name = "LOC_HONKAI_TECH_HEAVY_ARTILLERY_MECHA_NAME",
			Description = "LOC_HONKAI_TECH_HEAVY_ARTILLERY_MECHA_DESC",
			Cost = 1070,
			EraType = "ERA_INDUSTRIAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_AE_MANUFACTURING"},
			Column = 2
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
			Cost = 1370,
			EraType = "ERA_MODERN",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_DEEP_SEA_BLUEPRINT"},
			Column = 2
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