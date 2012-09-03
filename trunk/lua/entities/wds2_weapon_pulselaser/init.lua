AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.FireSound = Sound("")

ENT.ShootPos = Vector(33, 0, 0)

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
	self.Outputs = Wire_CreateOutputs(self,{"Can Fire"})
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
			self:FireShot()
			self.NextFire = CurTime()+6
			self:EmitSound(self.FireSound)
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:FireShot()
	local ShootPos = self:LocalToWorld(self.ShootPos)
	local tr = WDS2.TraceLine(ShootPos,self:GetPos()+(self:GetForward()*50000),{self},msk)
	
end

function ENT:TriggerInput(name,val)
	if name == "Fire" then
		self.ShouldFire = tobool(val)
	end
end
