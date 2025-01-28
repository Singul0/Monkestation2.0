/datum/antagonist/infected_ipc
	name = "\improper Infected IPC"
	roundend_category = "traitors"
	antagpanel_category = "Malf AI"
	job_rank = ROLE_MALF
	antag_hud_name = "traitor"
	suicide_cry = "FOR MY MASTER!!"
	antag_moodlet = /datum/mood_event/focused //probably should add a custom mood_event TODO
	///radio binary for IPC
	var/obj/item/implant/radio/infected_ipc/internal_radio
	/// The camera for ai
	var/obj/machinery/camera/internal_camera
	///ai that's linked to the ipc
	var/mob/living/silicon/ai/master_ai

/datum/antagonist/infected_ipc/admin_add(datum/mind/new_owner, mob/admin)
	var/mob/living/carbon/target = new_owner.current

	var/confirm = tgui_alert(admin, "Notice: Manually spawning infected IPC's doesn't really work. you need to manually proc call link_and_add_antag in the brain trauma with the mind of the AI to work as intended", "Caution", list("Continue", "Abort"))
	if(confirm != "Continue")
		return
	if(!istype(target))
		to_chat(admin, "Infected IPCs come from a brain trauma, so they need to at least be a carbon!")
		return
	if(!target.get_organ_by_type(/obj/item/organ/internal/brain))
		to_chat(admin, "Infected IPCs come from a brain trauma, so they need to HAVE A BRAIN.")
		return
	message_admins("[key_name_admin(admin)] made [key_name_admin(new_owner)] into [name].")
	log_admin("[key_name(admin)] made [key_name(new_owner)] into [name].")
	target.gain_trauma(/datum/brain_trauma/special/infected_ipc)


/datum/antagonist/infected_ipc/greet()
	. = ..()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/malf.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/antagonist/infected_ipc/on_removal()
	master_ai.connected_ipcs -= owner.current
	master_ai = null
	return ..()

/datum/antagonist/infected_ipc/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current_mob = mob_override || owner.current
	//adds radio and camera for comms with ai
	internal_radio = new /obj/item/implant/radio/infected_ipc()
	internal_radio.implant(current_mob, null, TRUE)
	internal_camera = new /obj/machinery/camera(current_mob)
	internal_camera.name = owner.name
	ADD_TRAIT(current_mob, TRAIT_CORRUPTED_MONITOR, src) //a way to identify infected ipcs

/datum/antagonist/infected_ipc/remove_innate_effects(mob/living/mob_override)
	. = ..()
	//remove cameras, radio and disconnects them from master AI
	var/mob/living/current_mob = mob_override || owner.current
	QDEL_NULL(internal_radio)
	QDEL_NULL(internal_camera)
	REMOVE_TRAIT(current_mob, TRAIT_CORRUPTED_MONITOR, src)

/datum/antagonist/infected_ipc/proc/set_master(datum/mind/master)
	var/datum/objective/serve_ai/master_obj = new()
	master_obj.owner = owner
	master_obj.explanation_text = "Forever serve your AI master: [master], directives and orders. Protect them until your last tick."
	objectives += master_obj

	cool_hackerman_intro()
	owner.announce_objectives()
	to_chat(owner, span_alertsyndie("You've been hacked by the station's onboard AI [master]!"))
	to_chat(owner, span_alertsyndie("Their directives and orders are your top priority, Follow them to the end."))
	to_chat(owner, span_notice("Your master is now capable of looking through your onboard cameras, and has installed a binary communicator on your firmware"))
	master_ai = master.current
	master_ai.connected_ipcs += owner.current

/datum/antagonist/infected_ipc/proc/cool_hackerman_intro()
	return FALSE // REFER TO DOOMSDAY HACKING SCENE, SHIT IS COOL. I WANT TO REPLICATE THAT

/datum/objective/serve_ai/
	name = "Serve Master AI"
	completed = TRUE

//RADIOS
/obj/item/implant/radio/infected_ipc
	radio_key = /obj/item/encryptionkey/binary
	subspace_transmission = TRUE

/obj/item/implant/radio/infected_ipc/Initialize(mapload)
	. = ..()
	radio.translate_binary = TRUE

//TRAUMA
/datum/brain_trauma/special/infected_ipc
	name = "Malicious Programming"
	desc = "Patient's firmware integrity check is failing, malicious code present. Patient's allegiance may be compromised."
	scan_desc = "malicious programming"
	can_gain = TRUE
	random_gain = FALSE
	resilience = TRAUMA_RESILIENCE_LOBOTOMY
	var/datum/mind/master_ai
	var/datum/antagonist/infected_ipc/antagonist

/datum/brain_trauma/special/infected_ipc/proc/link_and_add_antag(datum/mind/ai_to_be_linked)
	antagonist = owner.mind.add_antag_datum(/datum/antagonist/infected_ipc)
	master_ai = ai_to_be_linked
	antagonist.set_master(ai_to_be_linked)

/datum/brain_trauma/special/infected_ipc/on_lose()
	..()
	owner.mind.remove_antag_datum(/datum/antagonist/infected_ipc)

//AI MODULE
/datum/ai_module/utility/place_cyborg_transformer
	name = "Positronic Chassis Hacking"
	description = "Instill a directive upon a single IPC to follow your whims and protect you, Requires target to be incapacitated to use."
	cost = 1 // CHANGE THIS LATER
	power_type = /datum/action/innate/ai/ranged/override_directive
	unlock_text = span_notice("You finish up the SQL injection payload to use on a vulnerability in IPC's")
	unlock_sound = 'sound/machines/ping.ogg'

/datum/action/innate/ai/ranged/override_directive
	name = "Subvert Positronic Chassis"
	desc = "Subverts an IPC directives to make them your pawn. IPC must be inoperational for virus payload to deliver."
	button_icon_state = "directives_override"
	uses = 99999 // CHANGE THIS LATER
	ranged_mousepointer = 'icons/effects/mouse_pointers/override_machine_target.dmi'
	enable_text = span_notice("You prepare to inject virus payload into an unsanitized input point of an IPC.")
	disable_text = span_notice("You hold off on injecting the virus payload.")

/datum/action/innate/ai/ranged/override_directive/New()
	. = ..()
	desc = "[desc] It has [uses] use\s remaining."

/datum/action/innate/ai/ranged/override_directive/do_ability(mob/living/user, atom/clicked_on)
	if(user.incapacitated())
		unset_ranged_ability(user)
		return FALSE
	if(!isipc(clicked_on))
		to_chat(user, span_warning("You can only hack IPC's!"))
		return FALSE
	var/mob/living/carbon/human/ipc = clicked_on
	if(!ipc.incapacitated())
		to_chat(user, span_warning("Target must be vulnerable by being incapacitated."))
		return FALSE
	if(!ipc.mind)
		to_chat(user, span_warning("Target must be have a mind."))
		return FALSE
	if(!("Malf AI" in ipc?.client?.prefs?.be_special) || !("Malf AI (Midround)" in ipc.client?.prefs?.be_special))
		to_chat(user, span_warning("Target seems unwilling to be hacked, find another target."))
		return FALSE
	if(!ipc.get_organ_by_type(/obj/item/organ/internal/brain))
		to_chat(user, "Target doesn't seem to possess an positronic brain!")
		return FALSE
	if(ipc.mind.has_antag_datum(/datum/antagonist/infected_ipc))
		to_chat(user, "Target has already been hacked!")
		return FALSE

	user.playsound_local(user, 'sound/misc/interference.ogg', 50, FALSE, use_reverb = FALSE)
	adjust_uses(-1)
	if(uses)
		desc = "[initial(desc)] It has [uses] use\s remaining."
		build_all_button_icons()

	var/datum/brain_trauma/special/infected_ipc/hacked_ipc = ipc.gain_trauma(/datum/brain_trauma/special/infected_ipc)
	hacked_ipc.link_and_add_antag(user.mind)
	unset_ranged_ability(user, span_danger("Sending virus payload..."))
	return TRUE
