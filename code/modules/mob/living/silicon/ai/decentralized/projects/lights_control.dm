/datum/ai_project/lights_control
	name = "Lights Control"
	description = "Subvert an obselete IoT endpoint to control light modes in a room."
	research_cost = 1000 //I mean, AI can just overload lights for free?
	ram_required = 0
	category = AI_PROJECT_MISC

/datum/ai_project/lights_control/run_project(force_run)
	. = ..()
	add_ability(/datum/action/innate/ai/lights_control)

/datum/ai_project/lights_control/stop()
	. = ..()
	remove_ability(/datum/action/innate/ai/lights_control)

/datum/action/innate/ai/lights_control
	name = "Lights Controls"
	desc = "Controls light systems in a set area."
	button_icon_state = "emergency_lights"
	var/datum/ai_project/advanced_tracking/tracker
	max_uses = 999
	auto_use_uses = FALSE

/datum/action/innate/ai/lights_control/Activate()
	var/area/area_to_control = get_area(owner_AI.eyeobj)
	if(!is_station_area_or_adjacent(area_to_control))
		return

	var/mode = tgui_input_list(owner_AI, "What Operating Mode Should It Be Set?", "Light Controls", list("Default", "Blacklight", "Dim", "Red", "Warm"))
	for(var/list/zlevel_turfs as anything in area_to_control.get_zlevel_turf_lists())
		for(var/turf/area_turf as anything in zlevel_turfs)
			for(var/obj/machinery/light/controlled_light in area_turf)
				switch(mode)
					if("Default")
						controlled_light.bulb_colour = initial(controlled_light.bulb_colour)
					if("Blacklight")
						controlled_light.bulb_colour = "#A700FF"
					if("Red")
						controlled_light.bulb_colour = "#FF3232"
					if("Warm")
						controlled_light.bulb_colour = "#fae5c1"

				if(mode == "Dim")
					controlled_light.bulb_power = 0.6
				else
					controlled_light.bulb_power = initial(controlled_light.bulb_power)

				controlled_light.update()
