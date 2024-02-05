
TOOL.Category = "Half-Life 2"
TOOL.Name = "#tool.item_charger_spawner"

TOOL.ClientConVar[ "type" ] = "0"
--TOOL.ClientConVar[ "citadel" ] = "0"

list.Set( "ChargerTypes", "#item_suitcharger", { item_charger_spawner_type = 0, model = "models/props_combine/suit_charger001.mdl", classname = "item_suitcharger" } )
list.Set( "ChargerTypes", "#item_healthcharger", { item_charger_spawner_type = 1, model = "models/props_combine/health_charger001.mdl", classname = "item_healthcharger" } )

if ( SERVER ) then

	--[[duplicator.RegisterEntityModifier( "rb655_citadel_charger", function( ply, ent, data )
		ent:SetKeyValue( "spawnflags", 8192 )
	end )]]

	function MakeHalfLifeCharger( ply, entry, pos, ang --[[, isCitadel]] )

		-- Ask the gamemode if it's ok to spawn this
		if ( !gamemode.Call( "PlayerSpawnSENT", ply, entry.classname ) ) then return end

		-- Spawn it!
		local item_charger = ents.Create( entry.classname )
		if ( !IsValid( item_charger ) ) then return nil end
		item_charger:SetPos( pos )
		item_charger:SetAngles( ang )
		--[[if ( isCitadel ) then
			duplicator.StoreEntityModifier( item_charger, "rb655_citadel_charger", {} )
			duplicator.ApplyEntityModifiers( ply, item_charger )
		end]]
		item_charger:Spawn()
		item_charger:Activate()

		DoPropSpawnedEffect( item_charger )

		-- Pretend we are a SENT
		if ( IsValid( ply ) ) then
			gamemode.Call( "PlayerSpawnedSENT", ply, item_charger )
		end

		undo.Create( "SENT" )
			undo.SetPlayer( ply )
			undo.AddEntity( item_charger )
			undo.SetCustomUndoText( "Undone " .. entry.classname )
		undo.Finish( "Scripted Entity (" .. tostring( entry.classname ) .. ")" )

		ply:AddCleanup( "sents", item_charger )
		item_charger:SetVar( "Player", ply )

		return item_charger
	end

end


function TOOL:LeftClick( trace )

	if ( trace.HitSky or !trace.HitPos ) then return false end
	if ( IsValid( trace.Entity ) and ( trace.Entity:IsPlayer() or trace.Entity:IsNPC() ) ) then return false end

	local entry = self:GetSelectedEntry()
	if ( !entry ) then return false end

	if ( IsValid( trace.Entity ) and trace.Entity:GetClass() == entry.classname ) then return false end
	if ( CLIENT ) then return true end

	--local isCitadel = self:GetClientNumber( "citadel" ) != 0

	local ply = self:GetOwner()
	local ang = trace.HitNormal:Angle()
	MakeHalfLifeCharger( ply, entry, trace.HitPos, ang --[[, isCitadel]] )

	return true

end

function TOOL:GetSelectedEntry()

	local t = self:GetClientNumber( "type" )

	local options = list.Get( "ChargerTypes" )
	for label, tab in pairs( options ) do
		if ( tab.item_charger_spawner_type == t ) then return tab end
	end

end

function TOOL:Think()

	local entry = self:GetSelectedEntry()
	if ( !entry ) then
		if ( IsValid( self.GhostEntity ) ) then self.GhostEntity:SetNoDraw( true ) end
		return
	end

	if ( !IsValid( self.GhostEntity ) or self.GhostEntity:GetModel() != entry.model ) then
		self:MakeGhostEntity( entry.model, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostEntity( self.GhostEntity, self:GetOwner(), entry )

end

function TOOL:UpdateGhostEntity( ent, ply, entry )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()

	if ( !trace.Hit or !entry ) then ent:SetNoDraw( true ) return end
	if ( IsValid( trace.Entity ) and ( trace.Entity:GetClass() == entry.classname or trace.Entity:IsPlayer() or trace.Entity:IsNPC() ) ) then ent:SetNoDraw( true ) return end

	ent:SetPos( trace.HitPos )

	local ang = trace.HitNormal:Angle()
	ent:SetAngles( ang )

	ent:SetNoDraw( false )

end


if ( SERVER ) then return end

TOOL.Information = { { name = "left" } }

language.Add( "tool.item_charger_spawner", "Charger Spawner" )
language.Add( "tool.item_charger_spawner.name", "Charger Spawner" )
language.Add( "tool.item_charger_spawner.desc", "Allows precision spawning of the suit & health chargers." )
language.Add( "tool.item_charger_spawner.left", "Spawn a charger" )

language.Add( "tool.item_charger_spawner.type", "Charger Spawner Type" )
--language.Add( "tool.item_charger_spawner.citadel", "Citadel Suit Charger" )

function TOOL.BuildCPanel( panel )
	panel:AddControl( "ListBox", { Label = "#tool.item_charger_spawner.type", Options = list.Get( "ChargerTypes" ), Height = 128 } )

	-- I can't be bothered to get it to work well with duplicator, so fuck it
	--panel:CheckBox( "#tool.item_charger_spawner.citadel", "item_charger_spawner_citadel" )
end
