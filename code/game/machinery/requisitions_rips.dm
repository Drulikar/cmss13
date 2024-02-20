GLOBAL_LIST_EMPTY(req_vendors)

#define PRINT_COOLDOWN_AMOUNT 20 SECONDS

/**
 * Wall-mounted requester and printer for the RIPS system
 */
/obj/structure/machinery/computer/rips_requester
	name = "\improper RIPS request console"
	desc = "A request console for the \"Requisition Issuing & Procurement System\". Enter your requested items and print a slip."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "request_wall"
	density = FALSE
	deconstructible = FALSE
	indestructible = TRUE // Goes with the tent instead
	/// list("req_vendor_name" = amount)
	var/currently_requested_materials = list()
	var/supplied
	var/print_cooldown

/obj/structure/machinery/computer/rips_requester/attack_remote(mob/living/user)
	attack_hand(user)

/obj/structure/machinery/computer/rips_requester/attack_hand(mob/living/user)
	if(..())  //Checks for power outages
		return
	tgui_interact(user)

/obj/structure/machinery/computer/rips_requester/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RIPSRequest")
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/structure/machinery/computer/rips_requester/ui_data(mob/user)
	var/list/data = list()
	data["currently_requested"] = list()
	for(var/name in currently_requested_materials)
		data["currently_requested"] += list(list("name" = name, "amount" = currently_requested_materials[name]))
	return data

/obj/structure/machinery/computer/rips_requester/ui_static_data(mob/user)
	var/list/data = list()
	data["all_products"] = list()
	for(var/obj/structure/machinery/cm_vending/sorted/vendor in GLOB.req_vendors)
		for(var/product_list in vendor.listed_products)
			if(!isnull(product_list[3])) // check to make sure it has a typepath to spawn
				data["all_products"] += list(list("name" = product_list[1], "amount" = product_list[2]))
	return data


/obj/structure/machinery/computer/rips_requester/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	// does this need user.set_interaction(src) here?

	switch(action)
		if("alter_request")
			var/requested_name = params["req_name"]
			if(GLOB.rips_manager.valid_type(requested_name))
				currently_requested_materials[requested_name] = round(clamp(text2num(params["amount"]), 0, 100))
				if(!currently_requested_materials[requested_name])
					currently_requested_materials -= requested_name
				return TRUE
			return FALSE

		if("complete")
			if(print_cooldown >= world.time)
				to_chat(ui.user, SPAN_WARNING("The printer isn't ready yet"))
				return
			if(!length(currently_requested_materials))
				to_chat(ui.user, SPAN_WARNING("There is no currently requested armaments."))
				return
			new /obj/item/paper/req_paperwork(src, null, currently_requested_materials, ui.user) // null is photo_list
			print_cooldown = world.time + PRINT_COOLDOWN_AMOUNT





/obj/structure/machinery/computer/rips_supply
	name = "\improper RIPS supply console"
	desc = "A supply console for the \"Requisition Issuing & Procurement System\". Enter a slip and alter, before approving."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "request_wall"

/obj/structure/machinery/computer/rips_supply/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RIPSSupply")
		ui.set_autoupdate(FALSE)
		ui.open()





/obj/item/paper/req_paperwork
	name = "requistions form"
	// /type/path/to/gun = amount
	var/list/requested_armaments = list()

/obj/item/paper/req_paperwork/Initialize(mapload, photo_list, list/currently_requested_materials, mob/user)
	. = ..()
	if(!length(currently_requested_materials))
		return
	requested_armaments = currently_requested_materials
	var/filled_form = "\[center\]\[uscm\]\[/center\]\[br\] \
		\[center\]\[b\]\[i\]Form R-104 - Requested Armaments\[/b\]\[/i\]\[br\] \
		Date: \[date\]: \[time\]\[/center\]\[hr\] \
		REQUESTED MATERIALS:"

	for(var/name in requested_armaments)
		filled_form += "\[*\][requested_armaments[type]]x [name]"

	if(user)
		filled_form += "REQUESTED BY: [user.get_paygrade()][user]"
	filled_form += "\[hr\]\[small\]RIPS BARCODE\[br\]\[barcode\]\[br\][rand(1001-4023)]-[rand(33-901)]-[rand(550-1000)]\[/small\]"

	info = parsepencode(filled_form, null, null, FALSE)
	update_icon()
