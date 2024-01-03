
AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.AutomaticFrameAdvance = true

function ENT:Initialize()

	if ( CLIENT ) then return end

	self.Locked = false
	self.Opened = false
	self.NextToggle = 0
	self.CloseDelay = 0

	-- self:PhysicsInit( SOLID_VPHYSICS )

	if ( SERVER ) then
		self:CreateBoneFollowers()
	end

	if ( self:GetModel() == "models/props/portal_door_combined.mdl" ) then
		self.Opened = true
		self:Close()
	end

end

function ENT:SetCloseDelay( num )

	self.CloseDelay = tonumber( num )

end

function ENT:PlayAnimation( str )

	self:ResetSequence( self:LookupSequence( str ) )

end

function ENT:Open()

	if ( self.NextToggle > CurTime() or self.Locked or self.Opened == true ) then return end

	self:PlayAnimation( "Open" )

	local model = self:GetModel():lower()
	if ( model == "models/props_mining/elevator01_cagedoor.mdl" ) then
		self:EmitSound( "ambient/levels/outland/ol04elevatorgate_up.wav" )
	end
	if ( model == "models/props_mining/techgate01.mdl" or model == "models/props_mining/techgate01_outland03.mdl" ) then
		self:EmitSound( "ambient/levels/outland/ol03_slidingoverhead_open.wav" )
	end
	if ( model == "models/props_lab/elevatordoor.mdl" ) then
		self:EmitSound( "plats/hall_elev_door.wav" )
	end
	if ( model == "models/props/portal_door_combined.mdl" ) then
		self:EmitSound( "plats/door_round_blue_unlock_01.wav" )
		timer.Simple( SoundDuration("plats/door_round_blue_unlock_01.wav") - 0.3, function()
			if ( !IsValid( self ) ) then return end
			self:EmitSound( "plats/door_round_blue_open_01.wav" )
		end )
	end
	if ( model == "models/combine_gate_vehicle.mdl" ) then
		self:EmitSound( "Doors.CombineGate_citizen_move1" )
		self:EmitSound( "plats/hall_elev_door.wav" )
		timer.Simple( self:SequenceDuration() - 0.7, function()
			if ( !IsValid( self ) ) then return end
			self:StopSound( "Doors.CombineGate_citizen_move1" )
			self:EmitSound( "Doors.CombineGate_citizen_stop2" )
		end )
	end

	self.NextToggle = CurTime() + self:SequenceDuration()
	self.Opened = true

	if ( self.CloseDelay < 0 ) then return end
	timer.Create( "rb655_door_autoclose_" .. self:EntIndex(), self:SequenceDuration() + self.CloseDelay, 1, function() if ( IsValid( self ) ) then self:Close() end end )

end

function ENT:Close()

	if ( self.NextToggle > CurTime() or self.Locked or self.Opened == false ) then return end

	timer.Remove( "rb655_door_autoclose_" .. self:EntIndex() )

	self:PlayAnimation( "close" )

	local model = self:GetModel():lower()
	if ( model == "models/props_mining/elevator01_cagedoor.mdl" ) then
		self:EmitSound( "ambient/levels/outland/ol01a_gate_open.wav" )
	end
	if ( model == "models/props_mining/techgate01.mdl" or model == "models/props_mining/techgate01_outland03.mdl" ) then
		self:EmitSound( "ambient/levels/outland/ol03_slidingoverhead_open.wav" )
	end
	if ( model == "models/props_lab/elevatordoor.mdl" ) then
		self:EmitSound( "plats/elevator_stop1.wav" )
	end
	if ( model == "models/props/portal_door_combined.mdl" ) then
		self:EmitSound( "plats/door_round_blue_close_01.wav" )
		timer.Simple( SoundDuration("plats/door_round_blue_close_01.wav") - 0.3, function()
			if ( !IsValid( self ) ) then return end
			self:EmitSound( "plats/door_round_blue_lock_01.wav" )
		end )
	end
	if ( model == "models/combine_gate_vehicle.mdl" ) then
		self:EmitSound( "Doors.CombineGate_citizen_move1" )
		self:EmitSound( "plats/hall_elev_door.wav" )
		timer.Simple( self:SequenceDuration() - 0.7, function()
			if ( !IsValid( self ) ) then return end
			self:StopSound( "Doors.CombineGate_citizen_move1" )
			self:EmitSound( "Doors.CombineGate_citizen_stop2" )
		end )
	end

	self.NextToggle = CurTime() + self:SequenceDuration()
	self.Opened = false

end

function ENT:OnRemove()

	if ( SERVER ) then
		self:StopSound( "Doors.Move10" ) -- Small combine doors
		self:StopSound( "Doors.Move11" ) -- Kleiner lab door
		self:StopSound( "Doors.Move12" ) -- Vertical combine doors
		self:StopSound( "Doors.CombineGate_citizen_move1" ) -- Big Combine doors
	end

end

function ENT:AcceptInput( name, activator, caller, data )

	name = string.lower( name )

	if ( name == "open" and self.NextToggle < CurTime() and !self.Locked and self.Opened == false ) then
		self:Open()
	elseif ( name == "close" and self.NextToggle < CurTime() and !self.Locked and self.Opened == true ) then
		self:Close()
	elseif ( name == "lock" ) then
		self.Locked = true
	elseif ( name == "unlock" ) then
		self.Locked = false
	end

end

function ENT:Think()

	if ( SERVER ) then
		self:UpdateBoneFollowers()

		self:NextThink( CurTime() )
		return true
	end

end

function ENT:Draw( flags )

	self:DrawModel( flags )

end

function ENT:DrawTranslucent( flags )

	self:Draw( flags )

end
