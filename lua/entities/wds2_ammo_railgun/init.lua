AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.DepletedColor = Color(255,40,40,255)
ENT.ChargedColor = Color(40,255,40,255)
ENT.IsInserted = false
ENT.HasCharge = true

function ENT:Initialize()
	self:SetModel("models/wds/device19.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:SetColor(self.ChargedColor)
end

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create(self.ClassName)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	e:SetPos(t.HitPos+t.HitNormal*-e:OBBMins().z)
	if IsValid(t.Entity) and t.Entity:GetClass() == "wds2_weapon_railgun" then t.Entity:AttemptAmmoConnect(e) end
	return e
end

function ENT:Eject(ent)
	self:SetColor(self.DepletedColor)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetVelocityInstantaneous(self:GetUp()*200)
	end
	timer.Simple(5, function() self:Despawn() end)
end

function ENT:Despawn()
	if IsValid(self) then
		WDS2.PropDeath(self)
	end
end
