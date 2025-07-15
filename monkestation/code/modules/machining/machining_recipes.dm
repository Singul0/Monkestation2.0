//init functions
/proc/init_machining_recipes()
	. = list()
	for(var/type in subtypesof(/datum/machining_recipe))
		. += new type

/proc/init_machining_recipes_atoms()
	. = list()
	//TURN THIS INTO HOW THE FUNCTION RETURNS
	for(var/datum/machining_recipe/recipe as anything in GLOB.machining_recipes)
		// Result
		. |= recipe.result
		// Ingredients
		for(var/atom/req_atom as anything in recipe.reqs)
			. |= req_atom
		// Tools
		for(var/atom/req_atom as anything in recipe.tool_paths)
			. |= req_atom

///Representative icons for the contents of each crafting recipe
/datum/asset/spritesheet/crafting/machining
	name = "machining"

/datum/asset/spritesheet/crafting/machining/create_spritesheets()
	var/id = 1
	for(var/atom in GLOB.machining_recipes_atoms)
		add_atom_icon(atom, id++)
	add_tool_icons()

/datum/machining_recipe
	/// in-game display 1name
	/// Optional, if not set uses result name
	var/name
	/// description displayed in game
	/// Optional, if not set uses result desc
	var/desc
	///type paths of items consumed associated with how many are needed
	var/list/reqs = list()
	///type paths of items explicitly not allowed as an ingredient
	var/list/blacklist = list()
	///type path of item resulting from this craft
	var/result
	/// String defines of items needed but not consumed. Lazy list.
	var/list/tool_behaviors
	/// Type paths of items needed but not consumed. Lazy list.
	var/list/tool_paths
	///where it shows up in the crafting UI
	var/category
	///What machining machine it belongs to
	var/machinery_type = MACHINING_LATHE
	///how much item to pop out
	var/result_amount = 1

///Representative icons for the contents of each crafting recipe
/datum/asset/spritesheet/crafting/machining
	name = "machining"

/datum/asset/spritesheet/crafting/create_spritesheets()
	var/id = 1
	for(var/atom in GLOB.machining_recipes_atoms)
		add_atom_icon(atom, id++)
	add_tool_icons()


/// Additional UI data to be passed to the crafting UI for this recipe
/datum/machining_recipe/proc/crafting_ui_data()
	return list()

/datum/machining_recipe/debug
	name = "Debug Item For Testing"
	desc = "You shouldn't see this"
	reqs = list(
		/obj/item/storage/toolbox = 1,
		/obj/item/pen = 5,
		/obj/item/aicard = 2,
	)
	result = /obj/item/debug/omnitool

/datum/machining_recipe/debug2
	name = "Debug Item For Testing"
	desc = "You shouldn't see this"
	reqs = list(
		/obj/item/paper=1
	)
	result = /obj/item/pen
