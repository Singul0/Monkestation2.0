/datum/ai_project/security_hud
	name = "Advanced Security HUD"
	description = "Using experimental long range passive sensors should allow you to detect various implants such as loyalty implants and tracking implants."
	research_cost = 1250
	ram_required = 2
	category = AI_PROJECT_HUDS

/datum/ai_project/security_hud/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	if(ai.sensors_on)
		ai.toggle_sensors(TRUE)
	ai.sec_hud = DATA_HUD_SECURITY_ADVANCED
	ai.toggle_sensors(TRUE)


/datum/ai_project/security_hud/stop()
	if(ai.sensors_on) //HUDs are weird. This has to be first so we're removed from the "advanced" HUD. It checks the sec_hud variable to see which one we remove from first.
		ai.toggle_sensors(TRUE)
	ai.sec_hud = DATA_HUD_SECURITY_BASIC

	ai.toggle_sensors(TRUE)
	..()

/datum/ai_project/diag_med_hud
	name = "Advanced Medical & Diagnostic HUD"
	description = "Various data processing optimizations should allow you to gain extra knowledge about users when your medical and diagnostic hud is active."
	research_cost = 1000
	ram_required = 1
	category = AI_PROJECT_HUDS

/datum/ai_project/diag_med_hud/run_project(force_run = FALSE)
	. = ..(force_run)
	if(!.)
		return .
	if(ai.sensors_on)
		ai.toggle_sensors(TRUE)
	ai.d_hud = DATA_HUD_DIAGNOSTIC_ADVANCED
	ai.med_hud = DATA_HUD_MEDICAL_ADVANCED

	ai.toggle_sensors(TRUE)


/datum/ai_project/diag_med_hud/stop()
	if(ai.sensors_on) //HUDs are weird. This has to be first so we're removed from the "advanced" HUD. It checks the d_hud and med_hud variable to see which one we remove from first.
		ai.toggle_sensors(TRUE)

	ai.d_hud = DATA_HUD_DIAGNOSTIC_BASIC
	ai.med_hud = DATA_HUD_MEDICAL_BASIC

	ai.toggle_sensors(TRUE)
	..()

/datum/ai_project/tray_sensors
	name = "T-Ray Sensors"
	description = "With improved processing of pre-existing optical data and some jury-rigging of components, you'd be able to transmit and process terahertz rays. This allows your pre-existing cameras to have the same functionally as handheld T-ray scanners used in the hands of crewmembers."
	research_cost = 500 //minimal practical usage
	ram_required = 1
	category = AI_PROJECT_HUDS

/datum/ai_project/tray_sensors/process()
	t_ray_scan(ai, 0.5 SECONDS, 9, ai.eyeobj)

/datum/ai_project/tray_sensors/run_project(force_run)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/datum/ai_project/tray_sensors/stop()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

#define MAXIMUM_TARGET_TRACKING 2

/datum/ai_project/advanced_tracking
	name = "Advanced Tracking"
	description = "Sets aside processing power to asychronously track multiple targets at once off the central view. Requires Camera Memory Tracker to research."
	research_cost = 1000 //very strong, but the research requirements is already a mountainload. 9k of total research to get, total zenith of upgrade.
	ram_required = 4
	category = AI_PROJECT_SURVEILLANCE
	research_requirements = list(/datum/ai_project/camera_tracker)
	var/list/mobs_to_track = list()

/datum/ai_project/advanced_tracking/process()
	//check if any of the targets are in camera net observable view.
	var/list/trackable_mobs = ai.ai_tracking_tool.find_trackable_mobs()
	var/list/hit_mobs = list()

	for(var/weakref_mob in trackable_mobs)
		var/mob/living/trackable_mob = trackable_mobs[weakref_mob].resolve()
		if(trackable_mob.can_track())
			if(trackable_mob in mobs_to_track)
				hit_mobs += trackable_mob

	if(!hit_mobs)
		return

	//send bingo hit mobs to AI, and spawns arrows to them
	ai.target_list = hit_mobs

	for(var/mob/tracked_mob in hit_mobs)
		var/area/their_turf = get_turf(tracked_mob)
		var/area/our_turf =  get_turf(ai)

		//skip if not on same z-level
		if(their_turf?.z != our_turf?.z)
			continue

		//try to get dept colors
		var/arrow_color = COLOR_WHITE

		if(ishuman(tracked_mob))
			var/mob/living/carbon/human/tracked_human = tracked_mob
			var/obj/item/card/id/used_id = tracked_human.get_idcard()
			arrow_color = used_id?.trim.department_color

		if(ai.hud_used)
			new /atom/movable/screen/navigate_arrow(null, ai.hud_used, their_turf, arrow_color, ai.eyeobj)

/datum/ai_project/advanced_tracking/run_project(force_run)
	. = ..()
	mobs_to_track = list()
	var/datum/action/innate/ai/advanced_tracking/tracking = add_ability(/datum/action/innate/ai/advanced_tracking)
	tracking.tracker = src

	START_PROCESSING(SSprocessing, src)

//button to activate these
/datum/action/innate/ai/advanced_tracking
	name = "Advanced Tracking Button"
	desc = "Controls the tracking subsystem."
	button_icon_state = "reactivate_cameras"
	var/datum/ai_project/advanced_tracking/tracker
	max_uses = 999
	auto_use_uses = FALSE

/datum/action/innate/ai/advanced_tracking/Activate()
	if(!tracker)
		to_chat(owner, span_warning("No datum connected! Something's fucked up! Call the coders!"))
		return

	tracker.add_target()

//actual thing that procs to add and remove tracking
/datum/ai_project/advanced_tracking/proc/add_target()
	if(mobs_to_track.len >= 2)
		to_chat(ai, span_warning("Maximum target to track reached! Removing stored targets!"))
		mobs_to_track = list()
		return

	var/trackable_list = ai.ai_tracking_tool.find_trackable_mobs()
	var/target_name = tgui_input_list(ai, "Select a target", "Tracking", trackable_list)
	if(!target_name || isnull(target_name))
		return
	var/datum/weakref/mob_ref = trackable_list[target_name]

	if(isnull(mob_ref))
		to_chat(ai, span_notice("Target is not on or near any active cameras. Tracking failed."))
		return

	mobs_to_track += mob_ref.resolve()

/datum/ai_project/advanced_tracking/stop()
	. = ..()
	remove_ability(/datum/action/innate/ai/advanced_tracking)
	ai.target_list = null
	mobs_to_track = list()
	STOP_PROCESSING(SSprocessing, src)

#undef MAXIMUM_TARGET_TRACKING

/datum/ai_project/lights_control
	name = "Lights Control"
	description = "Subvert an obselete IoT endpoint to control light modes in a room."
	research_cost = 1
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

/datum/ai_project/engineeringscan
	name = "Advanced Engineering Scan"
	description = "Devote processing time into analyzing powernet harmonics and accurate atmospherics scans derived from tertiary sensors in order to allow scanning of power surging through cables and atmospherics data of a tile."
	research_cost = 1
	ram_required = 0
	category = AI_PROJECT_HUDS

/datum/ai_project/engineeringscan/run_project(force_run)
	. = ..()
	ai.canEngineeringScan = TRUE

/datum/ai_project/engineeringscan/stop()
	. = ..()
	ai.canEngineeringScan = FALSE

/turf/open/attack_ai(mob/user)
	. = ..()
	if(isAI(user))
		var/mob/living/silicon/ai/ai_scanning = user

		if(ai_scanning.canEngineeringScan)
			atmos_scan(user=user, target=src, silent=TRUE)

			for(var/obj/structure/cable/power_cable in contents)
				to_chat(user, power_cable.get_power_info())

