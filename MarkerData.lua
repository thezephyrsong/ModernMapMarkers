-- ModernMapMarkers - MarkerData.lua  (WoW: Forever 1.60+, interface 16001)
-- ============================================================
-- Entry format
-- ============================================================
--
--   { zoneID, x, y, name, type, info, atlasID [, slot8] }
--
--   zoneID   : EITHER the old 3.3.5a zone index within the continent (1-53;
--              translated to a uiMapID by MMM_ZoneToUiMap below), OR a raw
--              uiMapID (any value >= 1000). Use raw uiMapIDs for anything
--              new to Forever -- /mmm here prints a ready-to-paste line.
--   x, y     : zone-map coordinates, 0-1 (same as the 3.3.5a data)
--   name     : marker name shown on hover and in the Find Marker panel
--              may contain an embedded comment after \n
--              example: "Gnomeregan\n|cFF808080(Workshop Entrance)|r"
--              the comment is shown as a second line in the Find Marker panel
--   type     : "dungeon", "raid", "worldboss", "boat", "zepp", "tram", "skyship" & "portal"
--   info     : level range, examples: "52-60" or "60"
--              faction string: "Alliance", "Horde" & "Neutral"
--   atlasID  : kept for compatibility with the 3.3.5a data; unused on Forever
--              (there is no Atlas/AtlasLoot there). Use nil for new entries.
--   slot8    : optional, one of:
--
--              - Transport destination(s) -- boat / zepp / tram / portal only:
--                  single - {continent, zone}
--                  dual   - {{continent, zone}, {continent, zone}}
--                           left-click navigates to dest[1]
--                           right-click navigates to dest[2]
--                  multi  - {{continent, zone, "Label"}, ...}  (3 or more)
--                           opens a popup menu listing all destinations
--                  Destinations that do not resolve to a Forever map are
--                  dropped at load; a marker left with none is skipped.
--
--              - "nopulse"  -- used inside a dest table as the third element:
--                              {continent, zone, "nopulse"}
--                              navigates normally but suppresses the return
--                              highlight pulse on the destination marker
--
--              - "nolist"   -- excludes the entry from the Find Marker panel
--                              while still showing it on the world map
--
--              - "dropdown" -- the marker comment is shown only in the
--                              Find Marker panel, not on the world map
--                              hover tooltip
--
-- ============================================================
-- Continent IDs
-- ============================================================
--
--   [1] Kalimdor        [2] Eastern Kingdoms
--
-- Forever is original Azeroth only: no Outland, no Northrend, no WDM dataset.
-- Content from TBC/WotLK (Old Hillsbrad, Karazhan, Sunwell, Blasted Lands mage
-- portals, Northrend transports, ...) was removed from the 3.3.5a data.

-- 3.3.5a zone index -> uiMapID (Classic-era/Forever map IDs).
-- nil = the zone does not exist in Forever (Exodar, Azuremyst, Silvermoon...).
MMM_ZoneToUiMap = {
	[1] = { -- Kalimdor
		[1]  = 1440, -- Ashenvale
		[2]  = 1447, -- Azshara
		[5]  = 1439, -- Darkshore
		[6]  = 1457, -- Darnassus
		[7]  = 1443, -- Desolace
		[8]  = 1411, -- Durotar
		[9]  = 1445, -- Dustwallow Marsh
		[10] = 1448, -- Felwood
		[11] = 1444, -- Feralas
		[12] = 1450, -- Moonglade
		[13] = 1412, -- Mulgore
		[14] = 1454, -- Orgrimmar
		[15] = 1451, -- Silithus
		[16] = 1442, -- Stonetalon Mountains
		[17] = 1446, -- Tanaris
		[18] = 1438, -- Teldrassil
		[19] = 1413, -- The Barrens
		[21] = 1441, -- Thousand Needles
		[22] = 1456, -- Thunder Bluff
		[23] = 1449, -- Un'Goro Crater
		[24] = 1452, -- Winterspring
		[25] = 2482, -- Mt. Hyjal
		[26] = 2521, -- Zephras Isle
		[27] = 2652, -- Shen'dralas
	},
	[2] = { -- Eastern Kingdoms
		[1]  = 1416, -- Alterac Mountains
		[2]  = 1417, -- Arathi Highlands
		[3]  = 1418, -- Badlands
		[4]  = 1419, -- Blasted Lands
		[5]  = 1428, -- Burning Steppes
		[6]  = 1430, -- Deadwind Pass
		[7]  = 1426, -- Dun Morogh
		[8]  = 1431, -- Duskwood
		[9]  = 1423, -- Eastern Plaguelands
		[10] = 1429, -- Elwynn Forest
		[13] = 1424, -- Hillsbrad Foothills
		[14] = 1455, -- Ironforge
		[16] = 1432, -- Loch Modan
		[17] = 1433, -- Redridge Mountains
		[18] = 1427, -- Searing Gorge
		[20] = 1421, -- Silverpine Forest
		[21] = 1453, -- Stormwind City
		[22] = 1434, -- Stranglethorn Vale
		[23] = 1435, -- Swamp of Sorrows
		[24] = 1425, -- The Hinterlands
		[25] = 1420, -- Tirisfal Glades
		[26] = 1458, -- Undercity
		[27] = 1422, -- Western Plaguelands
		[28] = 1436, -- Westfall
		[29] = 1437, -- Wetlands
		[30] = 2548, -- Riverglades
	},
}

-- Continent map IDs (used to work out which continent a map belongs to).
MMM_ContinentMaps = { [1414] = 1, [1415] = 2 }

MMM_DefaultPoints = {
	-- -------------------------------------------------------------------------
	[1] = { -- Kalimdor
		-- Dungeons
		{9, 0.758, 0.166, "Alcaz Prison", "dungeon", "48-53", 3},
		{1, 0.123, 0.128, "Blackfathom Deeps", "dungeon", "24-32", 3},
		{2, 0.380, 0.324, "Blackmaw Hold", "dungeon", "55-60", 3},
		{11, 0.648, 0.303, "Dire Maul - East", "dungeon", "55-58", 10},
		{11, 0.771, 0.369, "Dire Maul - East\n|cFF808080(The Hidden Reach)|r", "dungeon", "55-58", 10},
		{11, 0.671, 0.34, "Dire Maul - East\n|cFF808080(Side Entrance)|r", "dungeon", "55-58", 10},
		{11, 0.624, 0.249, "Dire Maul - North", "dungeon", "57-60", 12},
		{11, 0.604, 0.311, "Dire Maul - West", "dungeon", "57-60", 13},
		{7, 0.29, 0.629, "Maraudon", "dungeon", "46-55", 14},
		{14, 0.53, 0.486, "Ragefire Chasm", "dungeon", "13-18", 17},
		{19, 0.508, 0.94, "Razorfen Downs", "dungeon", "37-46", 18},
		{19, 0.423, 0.9, "Razorfen Kraul", "dungeon", "29-38", 19},
		{23, 0.426, 0.061, "Shaper’s Terrace", "dungeon", "58-60", 3},
		{19, 0.462, 0.357, "Wailing Caverns", "dungeon", "17-24", 20},
		{17, 0.389, 0.184, "Zul'Farrak", "dungeon", "44-54", 22},
		-- Raids
		{25, 0.890, 0.324, "Hyjal Summit", "raid", "60", 16},
		{9, 0.529, 0.777, "Onyxia's Lair", "raid", "60", 16},
		{15, 0.305, 0.987, "Ruins of Ahn'Qiraj", "raid", "60", 1},
		{15, 0.269, 0.987, "Temple of Ahn'Qiraj", "raid", "60", 2},
		{25, 0.233, 0.625, "The Barrow Deeps", "raid", "60", 16},
		{2, 0.303, 0.281, "The Barrow Deeps", "raid", "60", 16},
		{10, 0.692, 0.050, "The Barrow Deeps", "raid", "60", 16},
		-- World Bosses
		{2, 0.535, 0.816, "Azuregos", "worldboss", "60", nil},
		{1, 0.937, 0.355, "Emerald Dragon\n|cFF808080(Bough Shadow)|r", "worldboss", "60", nil},
		{11, 0.512, 0.108, "Emerald Dragon\n|cFF808080(Dream Bough)|r", "worldboss", "60", nil},
		-- Transport
		{8, 0.512, 0.135, "Zeppelins to Tirisfal Glades & Grom'Gol", "zepp", "Horde", nil, {{2, 25, "Tirisfal Glades"}, {2, 22, "Grom'Gol"}}},
		{13, 0.346, 0.244, "Skyship to Zephras Isle", "skyship", "Horde", nil, {1, 26}},
		{26, 0.620, 0.964, "Skyship to Mulgore", "skyship", "Horde", nil, {1, 13}},
		{26, 0.680, 0.921, "Skyship to Dalaran", "skyship", "Alliance", nil, {2, 1}},
		{19, 0.636, 0.389, "Boat to Booty Bay", "boat", "Neutral", nil, {2, 22}},
		{5, 0.333, 0.399, "Boat to Rut'Theran Village", "boat", "Alliance", nil, {1, 18}},
		{5, 0.313, 0.406, "Boat to Stormwind Harbor", "boat", "Alliance", nil, {2, 21}},
		{5, 0.325, 0.436, "Boat to Menethil Harbor", "boat", "Alliance", nil, {2, 29}},
		{9, 0.718, 0.566, "Boat to Menethil Harbor", "boat", "Alliance", nil, {2, 29}},
		{11, 0.311, 0.395, "Boat to Forgotten Coast", "boat", "Alliance", nil, {1, 11}},
		{11, 0.431, 0.428, "Boat to Sardor Isle", "boat", "Alliance", nil, {1, 11}},
		{18, 0.552, 0.949, "Boat to Auberdine", "boat", "Alliance", nil, {1, 5}},
		{17, 0.681, 0.226, "Boat to Powderfuse Port", "boat", "Neutral", nil, {2, 30}},
	},
	-- -------------------------------------------------------------------------
	[2] = { -- Eastern Kingdoms
		-- Dungeons
		{18, 0.387, 0.833, "Blackrock Depths\n|cFF808080(Searing Gorge)|r", "dungeon", "52-60", 2, "dropdown"},
		{5, 0.328, 0.365, "Blackrock Depths\n|cFF808080(Burning Steppes)|r", "dungeon", "52-60", 2, "dropdown"},
		{1, 0.115, 0.508, "City of Dalaran", "dungeon", "28-33", 16},
		{28, 0.423, 0.726, "The Deadmines", "dungeon", "17-26", 7},
		{29, 0.545, 0.645, "Excavation Site: Wetlands", "dungeon", "24-29", 16},
		{7, 0.178, 0.392, "Gnomeregan", "dungeon", "29-38", 9},
		{7, 0.216, 0.30, "Gnomeregan\n|cFF808080(Workshop Entrance)|r", "dungeon", "29-38", 9},
		{14, 0.448, 0.523, "Hall of Thanes", "dungeon", "13-18", 16},
		{30, 0.528, 0.198, "Krol'dok Stronghold", "dungeon", "40-45", 16},
		{5, 0.32, 0.39, "Lower Blackrock Spire\n|cFF808080(Burning Steppes)|r", "dungeon", "55-60", 3, "dropdown"},
		{18, 0.379, 0.858, "Lower Blackrock Spire\n|cFF808080(Searing Gorge)|r", "dungeon", "55-60", 3, "dropdown"},
		{25, 0.646, 0.688, "Ruins of Lordaeron", "dungeon", "15-20", 16},
		{25, 0.87, 0.325, "Scarlet Monastery\n|cFF808080(Armory)|r", "dungeon", "32-42", 16},
		{25, 0.862, 0.295, "Scarlet Monastery\n|cFF808080(Cathedral)|r", "dungeon", "35-45", 17},
		{25, 0.839, 0.283, "Scarlet Monastery\n|cFF808080(Graveyard)|r", "dungeon", "26-36", 18},
		{25, 0.85, 0.335, "Scarlet Monastery\n|cFF808080(Library)|r", "dungeon", "29-39", 19},
		{27, 0.69, 0.729, "Scholomance", "dungeon", "58-60", 20},
		{20, 0.448, 0.678, "Shadowfang Keep", "dungeon", "22-30", 21},
		{21, 0.508, 0.67, "The Stockade", "dungeon", "24-32", 22},
		{9, 0.273, 0.122, "Stratholme", "dungeon", "58-60", 23},
		{9, 0.437, 0.175, "Stratholme\n|cFF808080(Back Gate)|r", "dungeon", "58-60", 23},
		{23, 0.703, 0.55, "The Temple of Atal'Hakkar", "dungeon", "50-60", 24},
		{22, 0.233, 0.522, "The Drowned City", "dungeon", "35-45", 16},
		{3, 0.429, 0.13, "Uldaman", "dungeon", "41-51", 27},
		{3, 0.657, 0.438, "Uldaman\n|cFF808080(Back Entrance)|r", "dungeon", "41-51", 27},
		{5, 0.312, 0.365, "Upper Blackrock Spire\n|cFF808080(Burning Steppes)|r", "dungeon", "55-60", 4, "dropdown"},
		{18, 0.371, 0.833, "Upper Blackrock Spire\n|cFF808080(Searing Gorge)|r", "dungeon", "55-60", 4, "dropdown"},
		-- Raids
		{18, 0.332, 0.833, "Blackwing Lair\n|cFF808080(Searing Gorge)|r", "raid", "60", 5, "dropdown"},
		{5, 0.273, 0.363, "Blackwing Lair\n|cFF808080(Burning Steppes)|r", "raid", "60", 5, "dropdown"},
		{18, 0.332, 0.86, "Molten Core\n|cFF808080(Searing Gorge)|r", "raid", "60", 6, "dropdown"},
		{5, 0.273, 0.39, "Molten Core\n|cFF808080(Burning Steppes)|r", "raid", "60", 6, "dropdown"},
		{22, 0.53, 0.172, "Zul'Gurub", "raid", "60", 30},
		-- World Bosses
		{8, 0.465, 0.357, "Emerald Dragon\n|cFF808080(The Twilight Grove)|r", "worldboss", "60", nil},
		{24, 0.632, 0.217, "Emerald Dragon\n|cFF808080(Seradane)|r", "worldboss", "60", nil},
		-- Transport
		{1, 0.126, 0.520, "Skyship to Zephras Isle", "skyship", "Alliance", nil, {1, 26}},
		{21, 0.677, 0.325, "Tram to Ironforge", "tram", "Alliance", nil, {2, 14}},
		{14, 0.762, 0.511, "Tram to Stormwind", "tram", "Alliance", nil, {2, 21}},
		{29, 0.051, 0.634, "Boat to Auberdine via Southshore", "boat", "Alliance", nil, {2, 13}},
		{13, 0.506, 0.697, "Boat to Auberdine", "boat", "Alliance", nil, {1, 5}},
		{29, 0.082, 0.635, "Boat to Theramore Isle", "boat", "Alliance", nil, {1, 9}},
		{22, 0.257, 0.73, "Boat to Ratchet", "boat", "Neutral", nil, {1, 19}},
		{25, 0.606, 0.583, "Zeppelins to Durotar & Grom'Gol", "zepp", "Horde", nil, {{1, 8, "Durotar"}, {2, 22, "Grom'Gol"}}},
		{22, 0.312, 0.298, "Zeppelins to Tirisfal Glades & Durotar", "zepp", "Horde", nil, {{2, 25, "Tirisfal Glades"}, {1, 8, "Durotar"}}},
		{21, 0.216, 0.562, "Boat to Auberdine", "boat", "Alliance", nil, {1, 5}},
		{30, 0.798, 0.512, "Boat to Steamwheedle Port", "boat", "Neutral", nil, {1, 17}},

	},
	-- -------------------------------------------------------------------------
}

-- ============================================================
-- Forever additions -- NOT filled in yet (coordinates unknown).
-- Stand on the entrance in game and run /mmm here, then paste the
-- printed line into the matching continent above. Zones are from
-- Wowhead's Forever dungeon guide; level bands from its table.
-- ============================================================
--
--  Kalimdor
--    Blackmaw Hold        Azshara (1447), north, behind the Furbolg Gates   dungeon 55-60
--    Alcaz Prison         Dustwallow Marsh (1445), Alcaz Island             dungeon 48-53
--    Shaper's Terrace     Un'Goro Crater (1449)                             dungeon 58-60
--    Hyjal Summit         Mount Hyjal (2482)                                raid    (20-player)
--  Eastern Kingdoms
--    The Hall of Thanes   Ironforge (1455), under the city (Alliance)       dungeon 13-18
--    Ruins of Lordaeron   Undercity/Tirisfal area (Horde)                   dungeon 15-20
--    Excavation Site      Wetlands (1437), above Whelgar's Excavation Site  dungeon 24-29
--    City of Dalaran      location not confirmed                            dungeon 28-33
--    The Drowned City     off the coast of Stranglethorn Vale (1434)        dungeon 35-40
--    Krol'dok Stronghold  Riverglades (2548)                                dungeon 40-45
--  Unknown: Barrow Deeps (10-player raid)
--  New regions: Zephras Isle 2521, Darkspear Islands 2524, Riverglades 2548,
--               Shen'dralas 2652, Mount Hyjal 2482
