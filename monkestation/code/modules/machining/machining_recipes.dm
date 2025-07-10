/proc/init_machining_recipes()
	. = list()
	for(var/type in subtypesof(/datum/machining_recipes))
		. += new type

/datum/machining_recipes
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

/// Additional UI data to be passed to the crafting UI for this recipe
/datum/machining_recipes/proc/crafting_ui_data()
	return list()

/datum/machining_recipes/debug
	name = "Debug Item For Testing"
	desc = "You shouldn't see this"
	reqs = list(
		/obj/item/storage/toolbox = 1
	)
	result = /obj/item/debug/omnitool
