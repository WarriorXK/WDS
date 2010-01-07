AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

// Edit these variables on your own ent.
ENT.ExplodeEffect = "wds_projectile_base_explosion"
ENT.TrailEffect = "wds_projectile_base_trail"
ENT.Velocity = 1000
ENT.Radius = 10
ENT.Damage = 10
ENT.Model = "models/Gibs/HGIBS.mdl"

function ENT:Initialize()
	self:SetModel(self.Model or "models/Gibs/HGIBS.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableGravity(false)
	end
	local ed = EffectData()
		ed:SetEntity(self)
	util.Effect(self.TrailEffect,ed)
end

AccessorFunc(ENT,"Damage","Damage",FORCE_NUMBER)
AccessorFunc(ENT,"Radius","Radius",FORCE_NUMBER)

function ENT:Think()
	self:SetVelocity(self:GetUp()*self.Velocity)
	self:NextThink(CurTime()+2) // We don't need to update that often
	return true
end

function ENT:PhysicsCollide(data,physobj)
	self:Explode(data)
	if self and self:IsValid() then self:Remove() end
end

function ENT:Explode(data)
	WDS.Explosion(data.HitPos,self.Radius,self.Damage,{self},self.WDSO,self)
	local ed = EffectData()
		ed:SetOrigin(data.HitPos)
		ed:SetMagnitude(self.Radius)
	util.Effect(self.ExplodeEffect,ed)
end
