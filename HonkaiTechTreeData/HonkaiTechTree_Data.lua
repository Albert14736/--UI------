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
		}
	}
end