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
			Column = 1
		},
		{
			Type = "HONKAI_TECH_OMEN",
			Name = "LOC_HONKAI_TECH_OMEN_NAME",
			Description = "LOC_HONKAI_TECH_OMEN_DESC",
			Cost = 25,
			EraType = "ERA_ANCIENT",
			UITreeRow = 3,
			Prereqs = {},
			Column = 1
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
			Column = 2
		},
		{
			Type = "HONKAI_TECH_BASIC_TACTICS",
			Name = "LOC_HONKAI_TECH_BASIC_TACTICS_NAME",
			Description = "LOC_HONKAI_TECH_BASIC_TACTICS_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_PERCEPTION"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_ENERGY_CONTAINER",
			Name = "LOC_HONKAI_TECH_ENERGY_CONTAINER_NAME",
			Description = "LOC_HONKAI_TECH_ENERGY_CONTAINER_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_PERCEPTION"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_DESTINY_CLERGY",
			Name = "LOC_HONKAI_TECH_DESTINY_CLERGY_NAME",
			Description = "LOC_HONKAI_TECH_DESTINY_CLERGY_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_OMEN"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_NUN_FORMATION",
			Name = "LOC_HONKAI_TECH_NUN_FORMATION_NAME",
			Description = "LOC_HONKAI_TECH_NUN_FORMATION_DESC",
			Cost = 50,
			EraType = "ERA_ANCIENT",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_OMEN"},
			Column = 2
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
			Column = 3
		},
		{
			Type = "HONKAI_TECH_ST_FREYA",
			Name = "LOC_HONKAI_TECH_ST_FREYA_NAME",
			Description = "LOC_HONKAI_TECH_ST_FREYA_DESC",
			Cost = 80,
			EraType = "ERA_ANCIENT",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_PERCEPTION", "HONKAI_TECH_OMEN"},
			Column = 3
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
			Column = 4
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
		-- 第 1 列 (Cost: 275)
		{
			Type = "HONKAI_TECH_STIGMATA_PRINCIPLE",
			Name = "LOC_HONKAI_TECH_STIGMATA_PRINCIPLE_NAME",
			Description = "LOC_HONKAI_TECH_STIGMATA_PRINCIPLE_DESC",
			Cost = 275,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_POWER_ARMOR"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS",
			Name = "LOC_HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS_NAME",
			Description = "LOC_HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS_DESC",
			Cost = 275,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_POWER_ARMOR"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION",
			Name = "LOC_HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION_NAME",
			Description = "LOC_HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION_DESC",
			Cost = 275,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_VALKYRIE_ADVANCED"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_CLERGY_PRIVILEGE",
			Name = "LOC_HONKAI_TECH_CLERGY_PRIVILEGE_NAME",
			Description = "LOC_HONKAI_TECH_CLERGY_PRIVILEGE_DESC",
			Cost = 275,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 4,
			Prereqs = {"HONKAI_TECH_VALKYRIE_ADVANCED"},
			Column = 1
		},
		-- 第 2 列 (Cost: 300)
		{
			Type = "HONKAI_TECH_SOULLIQUOR_SMELTING",
			Name = "LOC_HONKAI_TECH_SOULLIQUOR_SMELTING_NAME",
			Description = "LOC_HONKAI_TECH_SOULLIQUOR_SMELTING_DESC",
			Cost = 300,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_STIGMATA_PRINCIPLE", "HONKAI_TECH_GREAT_ERUPTION_HYPOTHESIS"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_SCHICKSAL_ARMED_FORMATION",
			Name = "LOC_HONKAI_TECH_SCHICKSAL_ARMED_FORMATION_NAME",
			Description = "LOC_HONKAI_TECH_SCHICKSAL_ARMED_FORMATION_DESC",
			Cost = 300,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_VALKYRIE_BLOODLINE_PURIFICATION", "HONKAI_TECH_CLERGY_PRIVILEGE"},
			Column = 2
		},
		-- 第 3 列 (Cost: 390)
		{
			Type = "HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION",
			Name = "LOC_HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION_DESC",
			Cost = 390,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_SOULLIQUOR_SMELTING"},
			Column = 3
		},
		{
			Type = "HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE",
			Name = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE_NAME",
			Description = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE_DESC",
			Cost = 390,
			EraType = "ERA_MEDIEVAL",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_SCHICKSAL_ARMED_FORMATION"},
			Column = 3
		},
		-- ==============================================
		-- 文艺复兴时代 (ERA_RENAISSANCE)
		-- ==============================================
		-- 第 1 列 (Cost: 490)
		{
			Type = "HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY",
			Name = "LOC_HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY_NAME",
			Description = "LOC_HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY_DESC",
			Cost = 490,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = -3,
			Prereqs = {"HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_FISSION_REACTOR",
			Name = "LOC_HONKAI_TECH_FISSION_REACTOR_NAME",
			Description = "LOC_HONKAI_TECH_FISSION_REACTOR_DESC",
			Cost = 490,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_GRAY_SERPENT_NETWORK",
			Name = "LOC_HONKAI_TECH_GRAY_SERPENT_NETWORK_NAME",
			Description = "LOC_HONKAI_TECH_GRAY_SERPENT_NETWORK_DESC",
			Cost = 490,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 0,
			Prereqs = {"HONKAI_TECH_HONKAI_CRYSTAL_EXTRACTION"},
			Column = 1
		},
		{
			Type = "HONKAI_TECH_ABSOLUTE_THEOCRACY",
			Name = "LOC_HONKAI_TECH_ABSOLUTE_THEOCRACY_NAME",
			Description = "LOC_HONKAI_TECH_ABSOLUTE_THEOCRACY_DESC",
			Cost = 490,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_GOD_SLAYER_ARMOR_PROTOTYPE"},
			Column = 1
		},
		-- 第 2 列 (Cost: 540)
		{
			Type = "HONKAI_TECH_STIGMATA_GENE_COMPLETION",
			Name = "LOC_HONKAI_TECH_STIGMATA_GENE_COMPLETION_NAME",
			Description = "LOC_HONKAI_TECH_STIGMATA_GENE_COMPLETION_DESC",
			Cost = 540,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = -2,
			Prereqs = {"HONKAI_TECH_IMAGINARY_INTERFERENCE_THEORY", "HONKAI_TECH_FISSION_REACTOR"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_FANG_IN_THE_SHADOWS",
			Name = "LOC_HONKAI_TECH_FANG_IN_THE_SHADOWS_NAME",
			Description = "LOC_HONKAI_TECH_FANG_IN_THE_SHADOWS_DESC",
			Cost = 540,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 1,
			Prereqs = {"HONKAI_TECH_GRAY_SERPENT_NETWORK"},
			Column = 2
		},
		{
			Type = "HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT",
			Name = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT_NAME",
			Description = "LOC_HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT_DESC",
			Cost = 540,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 2,
			Prereqs = {"HONKAI_TECH_ABSOLUTE_THEOCRACY"},
			Column = 2
		},
		-- 第 3 列 (Cost: 600)
		{
			Type = "HONKAI_TECH_HONKAI_ISOLATION_DOME",
			Name = "LOC_HONKAI_TECH_HONKAI_ISOLATION_DOME_NAME",
			Description = "LOC_HONKAI_TECH_HONKAI_ISOLATION_DOME_DESC",
			Cost = 600,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = -1,
			Prereqs = {"HONKAI_TECH_STIGMATA_GENE_COMPLETION"},
			Column = 3
		},
		{
			Type = "HONKAI_TECH_FLOATING_ISLAND_TECH",
			Name = "LOC_HONKAI_TECH_FLOATING_ISLAND_TECH_NAME",
			Description = "LOC_HONKAI_TECH_FLOATING_ISLAND_TECH_DESC",
			Cost = 600,
			EraType = "ERA_RENAISSANCE",
			UITreeRow = 3,
			Prereqs = {"HONKAI_TECH_GOD_SLAYER_ARMOR_DEPLOYMENT"},
			Column = 3
		}
	}
end