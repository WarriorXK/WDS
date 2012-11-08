AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.FireSound = Sound("")

ENT.ShootPos = Vector(33, 0, 0)

ENT.SpinPercentage = 0
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
	self.Inputs = Wire_CreateInputs(self,{"Fire"})
	self.Outputs = Wire_CreateOutputs(self,{"Spin Percentage"})
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
	if self.NextFire <= CurTime() then
	
		if self.ShouldFire then
			
			self.SpinPercentage = math.min(self.SpinPercentage + 1, 100)
		
			if self.SpinPercentage > 30 then
			
				self:FireShot()
				self.NextFire = CurTime() + (1.1 - (self.SpinPercentage / 100))
				
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
	local tr = WDS2.TraceLine(ShootPos,self:GetPos()+(self:GetForward()*50000),{self},msk)
	
	
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
