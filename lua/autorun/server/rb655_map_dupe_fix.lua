
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

		if ( !ent.rb655_dupe_data ) then ent.rb655_dupe_data = { ismapcreated = ent:CreatedByMap() } end

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
		--if ( key == "slavename" ) then print( "slavename", key, val ) ent.rb655_dupe_data.targetname = val end

		function ent:PreEntityCopy()
			self.rb655_door_opened = self:GetInternalVariable( "m_eDoorState" ) != 0
			self.rb655_door_locked = self:GetInternalVariable( "m_bLocked" )
		end

	elseif ( ent:GetClass() == "item_ammo_crate" ) then

		if ( key == "AmmoType" ) then ent.type = val end

	elseif ( ent:GetClass() == "item_item_crate" ) then

		if ( key == "ItemCount" ) then ent.amount = val end
		if ( key == "ItemClass" ) then ent.class = val end
		if ( key == "CrateAppearance" ) then ent.appearance = val end
		if ( key == "targetname" ) then ent.targetname = val end

	end

end )

-- Ehhh... We gotta copy over wire_base_entity stuff for dupes
function rb655_hl2_CopyWireModMethods( targetEnt )

	local oldPreFunc = targetEnt.PreEntityCopy
	function targetEnt:PreEntityCopy()
		if ( oldPreFunc ) then oldPreFunc( self ) end

		duplicator.ClearEntityModifier( self, "WireDupeInfo" )

		-- build the DupeInfo table and save it as an entity mod
		local DupeInfo = WireLib.BuildDupeInfo( self )
		if ( DupeInfo ) then
			duplicator.StoreEntityModifier( self, "WireDupeInfo", DupeInfo )
		end
	end

	local function EntityLookup( createdEntities )
		return function( id, default )
			if ( id == nil ) then return default end
			if ( id == 0 ) then return game.GetWorld() end
			local ent = createdEntities[ id ]
			if ( IsValid( ent ) ) then return ent else return default end
		end
	end

	local oldPostFunc = targetEnt.PostEntityPaste
	function targetEnt:PostEntityPaste( player, ent, createdEntities )
		-- We manually apply the entity mod here rather than using a
		-- duplicator.RegisterEntityModifier because we need access to the
		-- CreatedEntities table.
		if ( ent.EntityMods and ent.EntityMods.WireDupeInfo ) then
			WireLib.ApplyDupeInfo( player, ent, ent.EntityMods.WireDupeInfo, EntityLookup( createdEntities ) )
		end

		if ( oldPostFunc ) then oldPostFunc( self, player, ent, createdEntities ) end
	end

end
