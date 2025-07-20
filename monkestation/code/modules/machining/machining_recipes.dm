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

/datum/machining_recipe/New()
	if(!result)
		return
	var/atom/atom_result = result
	if(!name && result)
		name = initial(atom_result.name)
	if(!desc && result)
		desc = initial(atom_result.desc)


/// Additional UI data to be passed to the crafting UI for this recipe
/datum/machining_recipe/proc/crafting_ui_data()
	return list()

/datum/machining_recipe/debug
	name = "Debug Item For Testing"
	desc = "You shouldn't see this"
	category = TAB_GENERAL_PARTS
	reqs = list(
		/obj/item/storage/toolbox = 1,
		/obj/item/pen = 5,
		/obj/item/aicard = 2,
	)
	result = /obj/item/debug/omnitool

/datum/machining_recipe/debug2
	name = "Debug Item For Testing"
	desc = "You shouldn't see this"
	category = TAB_TYPE_PARTS
	reqs = list(
		/obj/item/paper = 1
	)
	result = /obj/item/pen

/datum/machining_recipe/debug3
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/storage/briefcase = 1
	)
	category = TAB_SPECIFIC_PARTS
	result = /obj/item/storage/briefcase/launchpad

/datum/machining_recipe/debug4
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/storage/briefcase = 1
	)
	result = /obj/item/storage/briefcase/launchpad

/datum/machining_recipe/debug5
	category = TAB_ASSEMBLY_PARTS
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/storage/briefcase = 1
	)
	result = /obj/item/storage/briefcase/launchpad

/datum/machining_recipe/debug6
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/storage/briefcase = 1
	)
	result = /obj/item/storage/briefcase/launchpad

/datum/machining_recipe/debug7
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/storage/briefcase = 1
	)
	result = /obj/item/storage/briefcase/launchpad

/datum/machining_recipe/debug8
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/storage/briefcase = 1
	)
	result = /obj/item/storage/briefcase/launchpad

/datum/machining_recipe/debug9
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/storage/briefcase = 1
	)
	result = /obj/item/storage/briefcase/launchpad

/datum/machining_recipe/debug10
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/storage/briefcase = 1
	)
	result = /obj/item/storage/briefcase/launchpad
