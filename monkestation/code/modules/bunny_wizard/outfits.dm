/datum/outfit/cursed_bunny //for bunny wizards, don't use these for normal outfits
	name = "Cursed Bunny"
	uniform = /obj/item/clothing/under/costume/playbunny
	suit = /obj/item/clothing/suit/jacket/tailcoat
	shoes = /obj/item/clothing/shoes/heels
	head = /obj/item/clothing/head/playbunnyears
	gloves = /obj/item/clothing/gloves/color/white
	neck = /obj/item/clothing/neck/tie/bunnytie/tied
	r_pocket = /obj/item/toy/cards/deck
	l_pocket = 	/obj/item/reagent_containers/cup/rag
	r_hand = /obj/item/storage/bag/tray
	l_hand = /obj/item/reagent_containers/cup/glass/drinkingglass/filled/champagne

/datum/outfit/cursed_bunny/post_equip(mob/living/carbon/human/equipped_on, visualsOnly=FALSE)
	if(visualsOnly)
		return
	var/list/no_drops = list()
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_FEET)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_ICLOTHING)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_HEAD)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_NECK)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_GLOVES)
	for(var/obj/item/trait_needed as anything in no_drops)
		ADD_TRAIT(trait_needed, TRAIT_NODROP, CURSED_ITEM_TRAIT(trait_needed.type))
		trait_needed.name = "cursed " + trait_needed.name

/datum/outfit/cursed_bunny/costume
	name = "Cursed Bunny Costume"
	uniform = null
	suit = /obj/item/clothing/suit/costume/bunnysuit/regular
	head = /obj/item/clothing/head/costume/bunnyhead/regular
	shoes = /obj/item/clothing/shoes/clown_shoes/clown_jester_shoes
	neck = null
	r_hand = /obj/item/food/hotcrossbun
	l_hand = null
	r_pocket = null
	l_pocket = /obj/item/food/chocolatebunny

/datum/outfit/cursed_bunny/costume/post_equip(mob/living/carbon/human/equipped_on, visualsOnly=FALSE)
	if(visualsOnly)
		return
	var/list/no_drops = list()
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_FEET)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_HEAD)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_GLOVES)
	for(var/obj/item/trait_needed as anything in no_drops)
		ADD_TRAIT(trait_needed, TRAIT_NODROP, CURSED_ITEM_TRAIT(trait_needed.type))
		trait_needed.name = "cursed " + trait_needed.name


/datum/outfit/cursed_bunny/color
	name = "Cursed Bunny (Random Color)"

/datum/outfit/cursed_bunny/color/post_equip(mob/living/carbon/human/equipped_on, visualsOnly=FALSE)
	if(visualsOnly)
		return
	var/bunny_color = random_color()
	equipped_on.w_uniform?.greyscale_colors = "#[bunny_color]#[bunny_color]#ffffff#87502e"
	equipped_on.wear_suit?.greyscale_colors = "#[bunny_color]"
	equipped_on.head?.greyscale_colors = "#[bunny_color]"
	equipped_on.shoes?.greyscale_colors = "#[bunny_color]"
	equipped_on.wear_neck?.greyscale_colors = "#ffffff#[bunny_color]"
	equipped_on.w_uniform?.update_greyscale()
	equipped_on.wear_suit?.update_greyscale()
	equipped_on.head?.update_greyscale()
	equipped_on.shoes?.update_greyscale()
	equipped_on.wear_neck?.update_greyscale()
	equipped_on.update_worn_undersuit()
	equipped_on.update_worn_oversuit()
	equipped_on.update_worn_shoes()
	equipped_on.update_worn_head()
	equipped_on.update_worn_neck()

	var/list/no_drops = list()
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_FEET)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_ICLOTHING)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_HEAD)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_NECK)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_GLOVES)
	for(var/obj/item/trait_needed as anything in no_drops)
		ADD_TRAIT(trait_needed, TRAIT_NODROP, CURSED_ITEM_TRAIT(trait_needed.type))
		trait_needed.name = "cursed " + trait_needed.name

/datum/outfit/cursed_bunny/magician
	name = "Cursed Bunny (Magician)"
	uniform = /obj/item/clothing/under/costume/playbunny/magician
	suit = /obj/item/clothing/suit/wizrobe/magician
	head = /obj/item/clothing/head/wizard/magician
	shoes = /obj/item/clothing/shoes/heels/magician
	neck = /obj/item/clothing/neck/tie/bunnytie/magician/tied
	r_hand = null
	l_hand = /obj/item/gun/magic/wand/nothing
	r_pocket = null
	l_pocket = /obj/item/toy/cards/deck/tarot

/datum/outfit/plasmaman/cursed_bunny
	name = "Cursed Bunny (Plasmaman)"
	uniform = /obj/item/clothing/under/plasmaman/plasma_bun
	suit = /obj/item/clothing/suit/jacket/tailcoat/plasmaman
	head = /obj/item/clothing/head/helmet/space/plasmaman/bunny_ears
	shoes = /obj/item/clothing/shoes/heels/enviroheels
	neck = /obj/item/clothing/neck/tie/bunnytie/tied
	belt = /obj/item/tank/internals/plasmaman/belt/full
	r_pocket = /obj/item/toy/cards/deck
	l_pocket = 	/obj/item/reagent_containers/cup/rag
	r_hand = /obj/item/storage/bag/tray
	l_hand = /obj/item/reagent_containers/cup/glass/drinkingglass/filled/champagne
	internals_slot = ITEM_SLOT_BELT

/datum/outfit/plasmaman/cursed_bunny/post_equip(mob/living/carbon/human/equipped_on, visualsOnly=FALSE)
	var/list/no_drops = list()
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_FEET)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_ICLOTHING)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_HEAD)
	no_drops += equipped_on.get_item_by_slot(ITEM_SLOT_NECK)
	for(var/obj/item/trait_needed as anything in no_drops)
		ADD_TRAIT(trait_needed, TRAIT_NODROP, CURSED_ITEM_TRAIT(trait_needed.type))
		trait_needed.name = "cursed " + trait_needed.name


/obj/item/reagent_containers/cup/glass/drinkingglass/filled/champagne
	name = "Champagne"
	list_reagents = list(/datum/reagent/consumable/ethanol/champagne = 50)
