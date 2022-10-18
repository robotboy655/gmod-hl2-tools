
resource.AddWorkshop( "104619813" )

hook.Add( "EntityKeyValue", "rb655_keyval_fix", function( ent, key, val )

	if ( ent:GetClass() == "env_headcrabcanister" ) then

		if ( key == "HeadcrabType" ) then ent.headcrab = val end
		if ( key == "HeadcrabCount" ) then ent.count = val end
		if ( key == "FlightSpeed" ) then ent.speed = val end
		if ( key == "FlightTime" ) then ent.time = val end
		if ( key == "StartingHeight" ) then ent.height = val end
		if ( key == "Damage" ) then ent.damage = val end
		if ( key == "DamageRadius" ) then ent.radius = val end
		if ( key == "SmokeLifetime" ) then ent.duration = val end
		if ( key == "spawnflags" ) then ent.spawnflags = val end
		if ( key == "targetname" ) then ent.targetname = val end

	elseif ( ent:GetClass() == "prop_thumper" ) then

		if ( key == "dustscale" ) then ent.dustscale = val end
		if ( key == "targetname" ) then ent.targetname = val end

	elseif ( ent:GetClass() == "prop_door_rotating" ) then

		if ( !ent.rb655_dupe_data ) then ent.rb655_dupe_data = {} end

		if ( key == "speed" ) then ent.rb655_dupe_data.speed = val end
		if ( key == "distance" ) then ent.rb655_dupe_data.distance = val end
		if ( key == "hardware" ) then ent.rb655_dupe_data.hardware = val end
		if ( key == "returndelay" ) then ent.rb655_dupe_data.returndelay = val end
		if ( key == "skin" ) then ent.rb655_dupe_data.skin = val end
		if ( key == "angles" ) then ent.rb655_dupe_data.initialAngles = Angle( val ) end
		if ( key == "ajarangles" ) then ent.rb655_dupe_data.ajarangles = val end
		if ( key == "spawnflags" ) then ent.rb655_dupe_data.spawnflags = val end
		if ( key == "spawnpos" ) then ent.rb655_dupe_data.spawnpos = val end
		if ( key == "targetname" ) then ent.rb655_dupe_data.targetname = val end

	elseif ( ent:GetClass() == "item_ammo_crate" ) then

		if ( key == "AmmoType" ) then ent.type = val end

	elseif ( ent:GetClass() == "item_item_crate" ) then

		if ( key == "ItemCount" ) then ent.amount = val end
		if ( key == "ItemClass" ) then ent.class = val end
		if ( key == "CrateAppearance" ) then ent.appearance = val end
		if ( key == "targetname" ) then ent.targetname = val end

	end

end )
