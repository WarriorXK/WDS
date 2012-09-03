AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShellMode = "AT"

function ENT:Initialize()

	self:SetModel("models/wds/pball.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		//phys:EnableDrag(false)
		phys:EnableGravity(false) // We simulate our own gravity
		phys:SetVelocityInstantaneous(self:GetForward() * 8000)
	end
	
	local ed = EffectData()
		ed:SetEntity(self)
	util.Effect("wds2_smalltankcannon_trail", ed, true, true)
	
end

function ENT:Touch(ent)
	if ValidEntity(ent) and ent:GetClass() == "shield" then // Stargate shield Support
		self:Explode()
	end
end

function ENT:PhysicsCollide(data,physobj)
	self:Explode(data.HitPos)
	return
end

function ENT:Explode(pos)

	pos = pos or self:GetPos()
	
	WDS2.CreateExplosion(pos, 150, 150, self, self.ShellMode)
	util.BlastDamage(self, self.WDSO, pos, 150, 150)
	
	self:Remove()
	
end

function ENT:PhysicsUpdate(phys)
	if ValidEntity(phys) then
		phys:ApplyForceOffset( Vector(0, 0, -70), self:GetForward() * 5 )
	end
end
