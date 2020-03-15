



local weirding = {
	just_placed = {},
}


local function clear() 
	weirding.just_placed = {}
	minetest.after(1, clear)
end

minetest.after(1, clear)




minetest.register_node("weirding:mover", {
	description = "mover",
	tiles = {
		"default_dirt.png^weirding_yellow_arrow.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_stone_footstep", gain = 0.25},
	}),
})


minetest.register_abm({
	nodenames = {"weirding:mover"},
-- 	neighbors = {"group:soil"},
	interval = 1,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		
		local back_dir = minetest.facedir_to_dir(node.param2)
		
		local top_dir = ({[0]={x=0, y=1, z=0},
			{x=0, y=0, z=1},
			{x=0, y=0, z=-1},
			{x=1, y=0, z=0},
			{x=-1, y=0, z=0},
			{x=0, y=-1, z=0}})[math.floor(node.param2/4)]
		
		local right_dir = vector.cross(top_dir, back_dir)
		
-- 		local front_dir = vector.multiply(back_dir, -1)
		local backpos = vector.add(pos, top_dir)
		local frontpos = vector.add(backpos, back_dir)
		
		local bnode = minetest.get_node(backpos)
		if bnode == nil or bnode.name == "air" then
			return
		end
		
		local bhash = minetest.hash_node_position(backpos)
		if weirding.just_placed[bhash] == true then
			return
		end
		
		local fnode = minetest.get_node(frontpos)
		if fnode ~= nil and fnode.name ~= "air" then
			return
		end
		
		local fhash = minetest.hash_node_position(frontpos)
		weirding.just_placed[fhash] = true
		
		
		minetest.swap_node(frontpos, bnode)
		minetest.set_node(backpos, {name="air"})
		
		minetest.check_for_falling(frontpos)
	end,
})


minetest.register_node("weirding:dropper", {
	description = "mover",
	tiles = {
		"default_dirt.png^weirding_yellow_arrow_circle.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_stone_footstep", gain = 0.25},
	}),
})


minetest.register_abm({
	nodenames = {"weirding:dropper"},
-- 	neighbors = {"group:soil"},
	interval = 1,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		
		local back_dir = minetest.facedir_to_dir(node.param2)
		
		local top_dir = ({[0]={x=0, y=1, z=0},
			{x=0, y=0, z=1},
			{x=0, y=0, z=-1},
			{x=1, y=0, z=0},
			{x=-1, y=0, z=0},
			{x=0, y=-1, z=0}})[math.floor(node.param2/4)]
		
		
		local front_dir = vector.multiply(back_dir, -1)
		local toppos = vector.add(pos, top_dir)
		local backpos = vector.add(pos, back_dir)
		local frontpos = vector.add(pos, back_dir)
		
		local tnode = minetest.get_node(toppos)
		if tnode == nil or tnode.name == "air" then
			return
		end
		
		local thash = minetest.hash_node_position(toppos)
		if weirding.just_placed[thash] == true then
			return
		end
		
		-- try the front
		local fnode = minetest.get_node(frontpos)
		if fnode ~= nil and fnode.name == "air" then
			
			local fhash = minetest.hash_node_position(frontpos)
			weirding.just_placed[fhash] = true
			
			minetest.swap_node(frontpos, tnode)
			minetest.set_node(toppos, {name="air"})
			
			minetest.check_for_falling(frontpos)
			return
		end
		
		-- try moving on
		local frontpos = vector.add(toppos, back_dir)
		local fnode = minetest.get_node(frontpos)
		if fnode ~= nil and fnode.name == "air" then
			
			local fhash = minetest.hash_node_position(frontpos)
			weirding.just_placed[fhash] = true
			
			minetest.swap_node(frontpos, tnode)
			minetest.set_node(toppos, {name="air"})
			
			minetest.check_for_falling(frontpos)
			return
		end
	end,
})


--[[
minetest.register_node("weirding:rotator", {
	description = "rotator",
	tiles = {
		"default_dirt.png^weirding_green_circle_arrow.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_stone_footstep", gain = 0.25},
	}),
})


minetest.register_abm({
	nodenames = {"weirding:rotator"},
-- 	neighbors = {"group:soil"},
	interval = 10000000,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		
		local back_dir = minetest.facedir_to_dir(node.param2)
		
		local top_dir = ({[0]={x=0, y=1, z=0},
			{x=0, y=0, z=1},
			{x=0, y=0, z=-1},
			{x=1, y=0, z=0},
			{x=-1, y=0, z=0},
			{x=0, y=-1, z=0}})[math.floor(node.param2/4)]
		
		local right_dir = vector.cross(top_dir, back_dir)
		
-- 		local front_dir = vector.multiply(back_dir, -1)
		local backpos = vector.add(pos, back_dir)
		
		local i = 0
		while true do
			
			local frontpos = vector.add(pos, right_dir)
			
			
			local bnode = minetest.get_node(backpos)
			if bnode == nil or bnode.name == "air" then
				return
			end
			
			local bhash = minetest.hash_node_position(backpos)
			if weirding.just_placed[bhash] == true then
				return
			end
			
			
			local fnode = minetest.get_node(frontpos)
			if fnode ~= nil and fnode.name ~= "air" then
				return
			end
			
			local fhash = minetest.hash_node_position(frontpos)
			weirding.just_placed[fhash] = true
			
			minetest.swap_node(frontpos, bnode)
			minetest.set_node(backpos, {name="air"})
			
			break
		end
	end,
})
]]

minetest.register_abm({
	nodenames = {"weirding:rotator"},
-- 	neighbors = {"group:soil"},
	interval = 1,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		
		local back_dir = minetest.facedir_to_dir(node.param2)
		local backpos = vector.add(pos, back_dir) 
		
		
		
		local front_dir = vector.cross(back_dir, -1)
		local frontpos = vector.add(pos, front_dir)
		
		local bnode = minetest.get_node(backpos)
		if bnode == nil or bnode.name == "air" then
			return
		end
		
		local bhash = minetest.hash_node_position(backpos)
		if weirding.just_placed[bhash] == true then
			return
		end
		
		local fnode = minetest.get_node(frontpos)
		if fnode ~= nil and fnode.name ~= "air" then
			return
		end
		
		local fhash = minetest.hash_node_position(frontpos)
		weirding.just_placed[fhash] = true
		
		minetest.swap_node(frontpos, bnode)
		minetest.set_node(backpos, {name="air"})
		
	end,
})





minetest.register_node("weirding:eater", {
	description = "eater",
	tiles = {
		"default_dirt.png^weirding_red_arrow.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		"default_dirt.png",
		},
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	is_ground_content = false,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_stone_footstep", gain = 0.25},
	}),
})


minetest.register_abm({
	nodenames = {"weirding:eater"},
-- 	neighbors = {"group:soil"},
	interval = 1,
	chance = 1,
--	catch_up = true,
	action = function(pos)
		local node   = minetest.get_node(pos)
		
		local front_dir = minetest.facedir_to_dir(node.param2)
		local frontpos = vector.add(pos, front_dir)
		
		local back_dir = vector.multiply(front_dir, -1)
		local backpos = vector.add(pos, back_dir)
		
		local bnode = minetest.get_node(backpos)
		if bnode == nil or bnode.name == "air" then
			return
		end
	
		local bhash = minetest.hash_node_position(backpos)
		if weirding.just_placed[bhash] == true then
			return
		end
		
		local meta = minetest.get_meta(frontpos)
		if meta == nil then return end
		local inv = meta:get_inventory()
		if inv == nil then return end
		if inv:get_size("main") == 0 then return end
		
		local drops = minetest.get_node_drops(bnode.name, nil)
		for _,v in ipairs(drops) do
			inv:add_item("main", v)
		end
		
		minetest.set_node(backpos, {name="air"})
		
	end,
})

