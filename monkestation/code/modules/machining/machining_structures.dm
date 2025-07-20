/obj/machinery/lathe
	name = "industrial lathe"
	desc = "an industrial lathe, a machinery that is rendered semi-obselete with the advent of autolathes. It is however still common to be seen across the spinward sector"
	icon_state = "autolathe"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/industrial_lathe
	layer = BELOW_OBJ_LAYER
	var/machinery_type = MACHINING_LATHE
	var/debugv

/obj/machinery/lathe/Initialize(mapload)
	. = ..()

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

	for(var/datum/machining_recipe/recipe as anything in GLOB.machining_recipes)
		if(machinery_type != recipe.machinery_type)
			continue

		if(recipe.category)
			data["categories"] |= recipe.category

		data["recipes"] += list(build_crafting_data(recipe))
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

	// Machinery
	if(recipe.machinery_type)
		data["machinery_type"] = list()
		for(var/req_atom in recipe.machinery_type)
			data["machinery_type"] += atoms.Find(req_atom)

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
    if("Machining")
      var/newvar = params["debugv"]
      // A demo of proper input sanitation.
      debugv = clamp(newvar, 0, 100)
      . = TRUE
  update_icon() // Not applicable to all objects.

/obj/item/circuitboard/machine/industrial_lathe
	name = "Manual lathe"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/lathe
	req_components = list(
		/datum/stock_part/matter_bin = 3,
		/datum/stock_part/manipulator = 1,
		/obj/item/stack/sheet/glass = 1)
