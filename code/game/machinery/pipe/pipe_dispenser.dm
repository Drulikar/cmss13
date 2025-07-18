/obj/structure/machinery/pipedispenser
	name = "Pipe Dispenser"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	desc = "A large machine used for dispensing pipes. Bolts anchor it to the ground, but you can move it around if you unwrench them."
	icon_state = "pipe_d"
	density = TRUE
	anchored = TRUE
	var/unwrenched = 0
	var/wait = 0

/obj/structure/machinery/pipedispenser/attack_hand(user as mob)
	if(..())
		return
///// Z-Level stuff
	var/dat = {"
<b>Regular pipes:</b><BR>
<A href='byond://?src=\ref[src];make=0;dir=1'>Pipe</A><BR>
<A href='byond://?src=\ref[src];make=1;dir=5'>Bent Pipe</A><BR>
<A href='byond://?src=\ref[src];make=5;dir=1'>Manifold</A><BR>
<A href='byond://?src=\ref[src];make=8;dir=1'>Manual Valve</A><BR>
<A href='byond://?src=\ref[src];make=20;dir=1'>Pipe Cap</A><BR>
<A href='byond://?src=\ref[src];make=19;dir=1'>4-Way Manifold</A><BR>
<A href='byond://?src=\ref[src];make=18;dir=1'>Manual T-Valve</A><BR>
<A href='byond://?src=\ref[src];make=21;dir=1'>Upward Pipe</A><BR>
<A href='byond://?src=\ref[src];make=22;dir=1'>Downward Pipe</A><BR>
<b>Supply pipes:</b><BR>
<A href='byond://?src=\ref[src];make=29;dir=1'>Pipe</A><BR>
<A href='byond://?src=\ref[src];make=30;dir=5'>Bent Pipe</A><BR>
<A href='byond://?src=\ref[src];make=33;dir=1'>Manifold</A><BR>
<A href='byond://?src=\ref[src];make=41;dir=1'>Pipe Cap</A><BR>
<A href='byond://?src=\ref[src];make=35;dir=1'>4-Way Manifold</A><BR>
<A href='byond://?src=\ref[src];make=37;dir=1'>Upward Pipe</A><BR>
<A href='byond://?src=\ref[src];make=39;dir=1'>Downward Pipe</A><BR>
<b>Scrubbers pipes:</b><BR>
<A href='byond://?src=\ref[src];make=31;dir=1'>Pipe</A><BR>
<A href='byond://?src=\ref[src];make=32;dir=5'>Bent Pipe</A><BR>
<A href='byond://?src=\ref[src];make=34;dir=1'>Manifold</A><BR>
<A href='byond://?src=\ref[src];make=42;dir=1'>Pipe Cap</A><BR>
<A href='byond://?src=\ref[src];make=36;dir=1'>4-Way Manifold</A><BR>
<A href='byond://?src=\ref[src];make=38;dir=1'>Upward Pipe</A><BR>
<A href='byond://?src=\ref[src];make=40;dir=1'>Downward Pipe</A><BR>
<b>Devices:</b><BR>
<A href='byond://?src=\ref[src];make=28;dir=1'>Universal pipe adapter</A><BR>
<A href='byond://?src=\ref[src];make=4;dir=1'>Connector</A><BR>
<A href='byond://?src=\ref[src];make=7;dir=1'>Unary Vent</A><BR>
<A href='byond://?src=\ref[src];make=9;dir=1'>Gas Pump</A><BR>
<A href='byond://?src=\ref[src];make=15;dir=1'>Pressure Regulator</A><BR>
<A href='byond://?src=\ref[src];make=16;dir=1'>High Power Gas Pump</A><BR>
<A href='byond://?src=\ref[src];make=10;dir=1'>Scrubber</A><BR>
<A href='byond://?src=\ref[src];makemeter=1'>Meter</A><BR>
<A href='byond://?src=\ref[src];make=13;dir=1'>Gas Filter</A><BR>
<A href='byond://?src=\ref[src];make=23;dir=1'>Gas Filter-Mirrored</A><BR>
<A href='byond://?src=\ref[src];make=14;dir=1'>Gas Mixer</A><BR>
<A href='byond://?src=\ref[src];make=25;dir=1'>Gas Mixer-Mirrored</A><BR>
<A href='byond://?src=\ref[src];make=24;dir=1'>Gas Mixer-T</A><BR>
<A href='byond://?src=\ref[src];make=26;dir=1'>Omni Gas Mixer</A><BR>
<A href='byond://?src=\ref[src];make=27;dir=1'>Omni Gas Filter</A><BR>
<b>Heat exchange:</b><BR>
<A href='byond://?src=\ref[src];make=2;dir=1'>Pipe</A><BR>
<A href='byond://?src=\ref[src];make=3;dir=5'>Bent Pipe</A><BR>
<A href='byond://?src=\ref[src];make=6;dir=1'>Junction</A><BR>
<A href='byond://?src=\ref[src];make=17;dir=1'>Heat Exchanger</A><BR>
<b>Insulated pipes:</b><BR>
<A href='byond://?src=\ref[src];make=11;dir=1'>Pipe</A><BR>
<A href='byond://?src=\ref[src];make=12;dir=5'>Bent Pipe</A><BR>

"}
///// Z-Level stuff
//What number the make points to is in the define # at the top of construction.dm in same folder

	show_browser(user, dat, name, "pipedispenser")
	onclose(user, "pipedispenser")
	return

/obj/structure/machinery/pipedispenser/Topic(href, href_list)
	if(..())
		return
	if(unwrenched || usr.is_mob_incapacitated() || !in_range(loc, usr))
		close_browser(usr, "pipedispenser")
		return
	usr.set_interaction(src)
	src.add_fingerprint(usr)
	if(href_list["make"])
		if(!wait)
			var/p_type = text2num(href_list["make"])
			var/p_dir = text2num(href_list["dir"])
			var/obj/item/pipe/P = new (/*usr.loc*/ src.loc, p_type, p_dir)
			P.update()
			P.add_fingerprint(usr)
			wait = 1
			addtimer(VARSET_CALLBACK(src, wait, FALSE), 1 SECONDS)
	if(href_list["makemeter"])
		if(!wait)
			new /obj/item/pipe_meter(/*usr.loc*/ src.loc)
			wait = 1
			addtimer(VARSET_CALLBACK(src, wait, FALSE), 1.5 SECONDS)
	return

/obj/structure/machinery/pipedispenser/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(usr)
	if (istype(W, /obj/item/pipe) || istype(W, /obj/item/pipe_meter))
		to_chat(usr, SPAN_NOTICE(" You put [W] back to [src]."))
		user.drop_held_item()
		qdel(W)
		return
	else if (HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		if (unwrenched==0)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE(" You begin to unfasten \the [src] from the floor..."))
			if (do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(
					"[user] unfastens \the [src].",
					SPAN_NOTICE("You have unfastened \the [src]. Now it can be pulled somewhere else."),
					"You hear ratchet.")
				src.anchored = FALSE
				src.stat |= MAINT
				src.unwrenched = 1
				if (usr.interactee==src)
					close_browser(usr, "pipedispenser")
		else /*if (unwrenched==1)*/
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE(" You begin to fasten \the [src] to the floor..."))
			if (do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(
					"[user] fastens \the [src].",
					SPAN_NOTICE("You have fastened \the [src]. Now it can dispense pipes."),
					"You hear ratchet.")
				src.anchored = TRUE
				src.stat &= ~MAINT
				src.unwrenched = 0
				power_change()
	else
		return ..()

/obj/structure/machinery/pipedispenser/disposal
	name = "Disposal Pipe Dispenser"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	anchored = TRUE

/*
//Allow you to push disposal pipes into it (for those with density 1)
/obj/structure/machinery/pipedispenser/disposal/Crossed(obj/structure/disposalconstruct/pipe as obj)
	if(istype(pipe) && !pipe.anchored)
		qdel(pipe)

Nah
*/

//Allow you to drag-drop disposal pipes into it
/obj/structure/machinery/pipedispenser/disposal/MouseDrop_T(obj/structure/disposalconstruct/pipe as obj, mob/user as mob)
	if(user.is_mob_incapacitated())
		return

	if (!istype(pipe) || get_dist(user, src) > 1 || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	qdel(pipe)

/obj/structure/machinery/pipedispenser/disposal/attack_hand(user as mob)
	if(..())
		return

///// Z-Level stuff
	var/dat = {"<b>Disposal Pipes</b><br><br>
<A href='byond://?src=\ref[src];dmake=0'>Pipe</A><BR>
<A href='byond://?src=\ref[src];dmake=1'>Bent Pipe</A><BR>
<A href='byond://?src=\ref[src];dmake=2'>Junction</A><BR>
<A href='byond://?src=\ref[src];dmake=3'>Y-Junction</A><BR>
<A href='byond://?src=\ref[src];dmake=4'>Trunk</A><BR>
<A href='byond://?src=\ref[src];dmake=5'>Bin</A><BR>
<A href='byond://?src=\ref[src];dmake=6'>Outlet</A><BR>
<A href='byond://?src=\ref[src];dmake=7'>Chute</A><BR>
<A href='byond://?src=\ref[src];dmake=21'>Upwards</A><BR>
<A href='byond://?src=\ref[src];dmake=22'>Downwards</A><BR>
"}
///// Z-Level stuff

	show_browser(user, dat, name, "pipedispenser")
	return

// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/structure/machinery/pipedispenser/disposal/Topic(href, href_list)
	if(..())
		return
	usr.set_interaction(src)
	src.add_fingerprint(usr)
	if(href_list["dmake"])
		if(unwrenched || usr.is_mob_incapacitated() || !in_range(loc, usr))
			close_browser(usr, "pipedispenser")
			return
		if(!wait)
			var/p_type = text2num(href_list["dmake"])
			var/obj/structure/disposalconstruct/C = new (src.loc)
			switch(p_type)
				if(0)
					C.ptype = 0
				if(1)
					C.ptype = 1
				if(2)
					C.ptype = 2
				if(3)
					C.ptype = 4
				if(4)
					C.ptype = 5
				if(5)
					C.ptype = 6
					C.density = TRUE
				if(6)
					C.ptype = 7
					C.density = TRUE
				if(7)
					C.ptype = 8
					C.density = TRUE
///// Z-Level stuff
				if(21)
					C.ptype = 11
				if(22)
					C.ptype = 12
///// Z-Level stuff
			C.add_fingerprint(usr)
			C.update()
			wait = 1
			addtimer(VARSET_CALLBACK(src, wait, FALSE), 1.5 SECONDS)
	return

// adding a pipe dispensers that spawn unhooked from the ground
/obj/structure/machinery/pipedispenser/orderable
	anchored = FALSE
	unwrenched = 1

/obj/structure/machinery/pipedispenser/disposal/orderable
	anchored = FALSE
	unwrenched = 1
