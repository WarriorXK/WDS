AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local ChargeSound = Sound("wds/weapons/plasmacharger/charge.wav")
local FireSound = Sound("wds/weapons/plasmacharger/fire.wav")

ENT.NextDischarge = 0
ENT.ChargeDelay = 0
ENT.ShouldFire = false
ENT.Charging = false
ENT.Charge = 0

ENT.MaxCharge = 6
ENT.MinCharge = 3
ENT.CurPitch = 0

function ENT:Initialize()

	self:SetModel("models/wds/device05.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self.Inputs = Wire_CreateInputs(self,{"Fire","Charge"})
	self.Outputs = Wire_CreateOutputs(self,{"Can Fire", "% Charged"})
	
end

function ENT:SpawnFunction(p,t)

	if !t.Hit then return end
	
	local e = ents.Create(self.ClassName)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	e:SetPos( t.HitPos + t.HitNormal * -e:OBBMins().z )
	e:CreateChargeSound()
	return e
	
end

function ENT:CreateChargeSound()

	self.ChargeSound = CreateSound( self, ChargeSound )
	self.ChargeSound:ChangeVolume(5, 0)
	
end

function ENT:Think()

	if !self.ChargeSound then self:CreateChargeSound() end
	
	if self.Charging and self.ChargeDelay <= CurTime() then
	
		if !self.ChargeSound:IsPlaying() then self.ChargeSound:Play() end
		
		self.Charge = math.Clamp( self.Charge + 0.1, 0, self.MaxCharge )
		self.NextDischarge = CurTime() + 2
		self.CurPitch = 40 + ( self.Charge * 5 )
		
	else
	
		if self.ChargeSound:IsPlaying() and self.CurPitch <= 10 then self.ChargeSound:Stop() end
		
		self.CurPitch = math.Approach( self.CurPitch, 0, 0.5 )
		
		if self.NextDischarge <= CurTime() then
			self.Charge = math.Clamp( self.Charge - 0.1, 0, self.MaxCharge )
		end
		
	end
	
	if self.ChargeSound:IsPlaying() then self.ChargeSound:ChangePitch(self.CurPitch, 0) end
	
	if self.Charge >= self.MinCharge then
	
		if self.ShouldFire then
			self:FireShot(self.Charge)
		end
		Wire_TriggerOutput(self,"Can Fire",1)
		
	else
		Wire_TriggerOutput(self,"Can Fire",0)
	end
	
	Wire_TriggerOutput(self,"% Charged",math.Round((self.Charge/self.MaxCharge)*100))
	
	self:NextThink(CurTime()+0.1)
	return true
	
end

function ENT:FireShot(Charge)

	local ent = ents.Create("wds2_projectile_plasmacharger")
	ent:SetAngles(self:GetAngles())
	ent:SetPos( self:GetPos() + (self:GetForward() * 40) )
	ent.Cannon = self
	ent.WDSO = self.WDSO
	ent:SetCharge( Charge )
	if CPPI then ent:CPPISetOwner(self.WDSO) end // Prop protection API support, prevents "You now own this prop" messages
	ent:Spawn()
	ent:Activate()
	
	self:EmitSound( FireSound )
	
	self.Charge = 0
	self.ChargeSound:Stop()
	self.ChargeDelay = CurTime()+0.5
	
end

function ENT:OnRemove()
	if self.ChargeSound:IsPlaying() then self.ChargeSound:Stop() end
end

function ENT:TriggerInput(name,val)
	if name == "Fire" then
		self.ShouldFire = tobool(val)
	elseif name == "Charge" then
		self.Charging = tobool(val)
	end
end
