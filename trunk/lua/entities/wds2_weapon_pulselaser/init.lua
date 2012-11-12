AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.FireSound = Sound("")

ENT.ShootPos = Vector(33, 0, 0)

ENT.SpinPercentage = 0
ENT.NextSpinInc = 0
ENT.ShouldFire = false
ENT.NextFire = 0

function ENT:Initialize()

	self:SetModel("models/wds/device07.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self.Inputs = Wire_CreateInputs(self, {"Fire"})
	self.Outputs = Wire_CreateOutputs(self, {"Spin Percentage"})
	
end

function ENT:SpawnFunction(p,t)

	if !t.Hit then return end
	
	local e = ents.Create(self.ClassName)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	e:SetPos(t.HitPos+t.HitNormal*-e:OBBMins().z)
	
	return e
end

function ENT:Think()

	if self.ShouldFire and self.NextSpinInc <= CurTime() then
	
		self.SpinPercentage = math.min(self.SpinPercentage + 0.15, 100)
		self.NextSpinInc = CurTime()+0.01
		
	end

	if self.NextFire <= CurTime() then
	
		if self.ShouldFire then
		
			if self.SpinPercentage > 10 then
			
				self:FireShot()
				self.NextFire = CurTime() + (0.5 - (self.SpinPercentage / 230))
				
			end
			
		else
		
			self.SpinPercentage = math.max(self.SpinPercentage -1, 0)
			
		end
		
	end
	
	Wire_TriggerOutput(self, "Spin Percentage", self.SpinPercentage)
	
	self:NextThink(CurTime())
	return true
	
end

function ENT:FireShot()

	local ShootPos = self:LocalToWorld(self.ShootPos)
	local ConeOfFire = 120
	local tr = WDS2.TraceLine(ShootPos, self:GetPos()+((self:GetForward()*50000) + Vector(math.Rand(-ConeOfFire, ConeOfFire), math.Rand(-ConeOfFire, ConeOfFire), math.Rand(-ConeOfFire, ConeOfFire))), {self}, msk)
	
	if IsValid(tr.Entity) then
	
		WDS2.DealDirectDamage( tr.Entity, math.random(1, 2), "AT" )
		tr.Entity:GetPhysicsObject():ApplyForceOffset((tr.Entity:GetPos()-self:GetPos())*10,tr.HitPos)

	end
	
	local ed = EffectData()
		ed:SetStart(ShootPos)
		ed:SetOrigin(tr.HitPos)
	util.Effect("wds2_pulselaser_beam", ed)
	
	self:EmitSound(self.FireSound)
	
end

function ENT:TriggerInput(name,val)

	if name == "Fire" then
	
		self.ShouldFire = tobool(val)
		
	end
	
end
