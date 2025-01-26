/datum/antagonist/infected_ipc
	name = "\improper Infected IPC"
	roundend_category = "traitors"
	antagpanel_category = "Malf AI"
	job_rank = ROLE_MALF
	antag_hud_name = "traitor"
	suicide_cry = "FOR MY MASTER!!"
	default_custom_objective = "Forever serve your master's wishes, until the last tick"
	antag_moodlet = /datum/mood_event/focused //probably should add a custom mood_event TODO

/datum/antagonist/infected_ipc/on_gain()
	//links from ai add objective
	return ..()

/datum/antagonist/infected_ipc/on_removal()
	//remove objective
	return ..()

/datum/objective/serve_ai
