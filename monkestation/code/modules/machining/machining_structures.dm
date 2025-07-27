/obj/machinery/lathe
	name = "industrial lathe"
	desc = "An industrial lathe, a machinery that is rendered semi-obselete with the advent of autolathes. It is however still commonly seen across the spinward sector for small-scale prototyping use."
	icon_state = "autolathe"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/industrial_lathe
	layer = BELOW_OBJ_LAYER
	var/machinery_type = MACHINING_LATHE

	///Recipe that the stuff is currently set to make
	var/datum/machining_recipe/to_make
	///is the lathe currently busy crafting something?
	var/busy = FALSE
	///is recipe craftable? (ie. does it have all the required materials?)
	var/craftable = FALSE
	///path of materials needed to craft the item (and it's quantity)
	var/list/req_materials = null
	//names of the component
	var/list/req_materials_name = null
	///materials inputted to craft the item
	var/list/materials = list()

/obj/machinery/lathe/Initialize(mapload)
	. = ..()

/obj/machinery/lathe/examine(mob/user)
	. = ..()

	if(to_make)
		. += span_notice("The lathe is currently set to produce a [to_make.name]")

		var/list/nice_list = list()
		for(var/materials in req_materials)
			if(!ispath(materials))
				stack_trace("An item in [src]'s req_materials list is not a path!")
				continue
			if(!req_materials[materials])
				continue

			nice_list += list("[req_materials[materials]] [req_materials_name[materials]]\s")
		. += span_info(span_notice("It requires [english_list(nice_list, "no more components")]."))

/**
 * Collates the displayed names of the machine's needed materials
 *	This is done to extract the names off the path list.
 * Arguments:
 * * specific_parts - If true, the stock parts in the recipe should not use base name, but a specific tier
 */
/obj/machinery/lathe/proc/update_namelist(specific_parts)
	if(!req_materials)
		return

	req_materials_name = list()
	for(var/material_path in req_materials)
		if(!ispath(material_path))
			continue

		if(ispath(material_path, /obj/item/stack))
			var/obj/item/stack/stack_path = material_path
			if(initial(stack_path.singular_name))
				req_materials_name[material_path] = initial(stack_path.singular_name)
			else
				req_materials_name[material_path] = initial(stack_path.name)
		else if(ispath(material_path, /datum/stock_part))
			var/datum/stock_part/stock_part = material_path
			var/obj/item/physical_object_type = initial(stock_part.physical_object_type)

			req_materials_name[material_path] = initial(physical_object_type.name)
		else if(ispath(material_path, /obj/item/stock_parts))
			var/obj/item/stock_parts/stock_part = material_path

			if(!specific_parts && initial(stock_part.base_name))
				req_materials_name[material_path] = initial(stock_part.base_name)
			else
				req_materials_name[material_path] = initial(stock_part.name)
		else if(ispath(material_path, /obj/item))
			var/obj/item/part = material_path

			req_materials_name[material_path] = initial(part.name)
		else
			stack_trace("Invalid component part [material_path] in [type], couldn't get its name")
			req_materials_name[material_path] = "[material_path] (this is a bug)"

/obj/machinery/lathe/attackby(obj/item/interacted_item, mob/user, params)
	. = ..()
	for(var/stock_part_base in req_materials)
		if (req_materials[stock_part_base] == 0)
			continue

		var/stock_part_path

		if (ispath(stock_part_base, /obj/item))
			stock_part_path = stock_part_base
		else if (ispath(stock_part_base, /datum/stock_part))
			var/datum/stock_part/stock_part_datum_type = stock_part_base
			stock_part_path = initial(stock_part_datum_type.physical_object_type)
		else
			stack_trace("Bad stock part in req_materials: [stock_part_base]")
			continue

		if (!istype(interacted_item, stock_part_path))
			continue

		if(isstack(interacted_item))
			var/obj/item/stack/stack_mat = interacted_item
			var/used_amt = min(round(stack_mat.get_amount()), req_materials[stock_part_path])
			if(used_amt && stack_mat.use(used_amt))
				req_materials[stock_part_path] -= used_amt
				to_chat(user, span_notice("You add [interacted_item] to [src]."))
			return

		// We might end up qdel'ing the part if it's a stock part datum.
		// In practice, this doesn't have side effects to the name,
		// but academically we should not be using an object after it's deleted.
		var/part_name = "[interacted_item]"

		if(ispath(stock_part_base, /datum/stock_part))
			// We can't just reuse stock_part_path here or its singleton,
			// or else putting in a tier 2 part will deconstruct to a tier 1 part.
			var/stock_part_datum = GLOB.stock_part_datums_per_object[interacted_item.type]
			if (isnull(stock_part_datum))
				stack_trace("[interacted_item.type] does not have an associated stock part datum!")
				continue

			materials += stock_part_datum

			// We regenerate the stock parts on deconstruct.
			// This technically means we lose unique qualities of the stock part, but
			// it's worth it for how dramatically this simplifies the code.
			// The only place I can see it affecting anything is like...RPG qualities. :P
			qdel(interacted_item)
		else if(user.transferItemToLoc(interacted_item, src))
			materials += interacted_item
		else
			break

		to_chat(user, span_notice("You add [part_name] to [src]."))
		req_materials[stock_part_base]--
		var/is_not_enough = FALSE
		for(var/req in req_materials)
			if(req_materials[req] > 0)
				is_not_enough = TRUE
		if(!is_not_enough)
			craftable = TRUE
			to_chat(user, span_notice("You have added all the required materials to [src]."))

		return TRUE
	to_chat(user, span_warning("You cannot add that to the machine!"))
	return FALSE

/obj/machinery/lathe/ui_interact(mob/user, datum/tgui/ui)
  ui = SStgui.try_update_ui(user, src, ui)
  if(!ui)
    ui = new(user, src, "Machining")
    ui.open()

/obj/machinery/lathe/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/crafting/machining),
	)

/obj/machinery/lathe/ui_data(mob/user)
	var/list/data = list()

	data["recipes"] = list()
	data["categories"] = list()
	data["busy"] = busy
	data["craftable"] = craftable

	// Recipes
	for(var/datum/machining_recipe/recipe as anything in GLOB.machining_recipes)
		if(machinery_type != recipe.machinery_type)
			continue

		if(recipe.category)
			data["categories"] |= recipe.category

		data["recipes"] += list(build_crafting_data(recipe))

	// Atoms in said Recipes
	for(var/atom/atom as anything in GLOB.machining_recipes_atoms)
		data["atom_data"] += list(list(
			"name" = initial(atom.name),
		))

	return data

/obj/machinery/lathe/proc/build_crafting_data(datum/machining_recipe/recipe)
	var/list/data = list()
	var/list/atoms = GLOB.machining_recipes_atoms

	data["ref"] = "[REF(recipe)]"
	var/atom/atom = recipe.result
	data["result"] = atoms.Find(atom)

	var/recipe_data = recipe.crafting_ui_data()
	for(var/new_data in recipe_data)
		data[new_data] = recipe_data[new_data]

	// Category
	data["category"] = recipe.category

	// Name, Description
	data["name"] = recipe.name

	if(ispath(recipe.result, /datum/reagent))
		var/datum/reagent/reagent = recipe.result
		if(recipe.result_amount > 1)
			data["name"] = "[data["name"]] [recipe.result_amount]u"
		data["desc"] = recipe.desc || initial(reagent.description)

	else if(ispath(recipe.result, /obj/item/pipe))
		var/obj/item/pipe/pipe_obj = recipe.result
		var/obj/pipe_real = initial(pipe_obj.pipe_type)
		data["desc"] = recipe.desc || initial(pipe_real.desc)

	else
		if(ispath(recipe.result, /obj/item/stack) && recipe.result_amount > 1)
			data["name"] = "[data["name"]] [recipe.result_amount]x"
		data["desc"] = recipe.desc || initial(atom.desc)

	// Machinery Type
	data["machinery_type"] = recipe.machinery_type

	// Ingredients / Materials
	if(recipe.reqs.len)
		data["reqs"] = list()
		for(var/req_atom in recipe.reqs)
			var/id = atoms.Find(req_atom)
			data["reqs"]["[id]"] = recipe.reqs[req_atom]

	return data

/obj/machinery/lathe/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	switch(action)
		if("make")
			to_chat(usr, span_notice("[key_name(usr)] is making [params["recipe"]] on [src] ([src.loc])"))
			var/datum/machining_recipe/recipe_path = (locate(params["recipe"]) in (GLOB.machining_recipes))
			to_make = new recipe_path.type

			if(!to_make)
				return
			if(!to_make.machinery_type == machinery_type)
				return
			if(busy)
				to_chat(usr, span_warning("[src] workspace is preoccupied with another recipe!"))
				return

			busy = TRUE
			req_materials = to_make.reqs
			update_namelist(to_make)

		if("produce")
			for(var/amount in 1 to to_make.result_amount)
				new to_make.result(src.loc)
			to_chat(usr, span_notice("You produce [to_make.name] on [src]."))
			reset_machine()
			for(var/obj/item in materials)
				materials -= item
				qdel(item)

		if("abort")
			reset_machine()
			for(var/obj/item in materials)
				item.forceMove(src.loc)
				materials -= item


	update_icon() // Not applicable to all objects. TODO: revise this(?)

/*
* Resets the lathe to a clean state
*/
/obj/machinery/lathe/proc/reset_machine()
	busy = FALSE
	qdel(to_make)
	to_make = null
	req_materials = null
	req_materials_name = null
	craftable = FALSE

/obj/item/circuitboard/machine/industrial_lathe
	name = "Manual lathe"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/lathe
	req_components = list(
		/datum/stock_part/matter_bin = 3,
		/datum/stock_part/manipulator = 1,
		/obj/item/stack/sheet/glass = 1)
