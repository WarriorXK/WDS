AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local PickupSound = Sound("items/medshot4.wav")

function ENT:Initialize()
	self:SetModel("models/Items/HealthKit.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetTrigger(true)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
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

function ENT:Touch(ply)
	self:Heal(ply)
end

function ENT:Use(ply)
	self:Heal(ply)
end

function ENT:Heal(ply)
	if ply:IsPlayer() and ply:Health() < ply:GetMaxHealth() then
		ply:SetHealth(math.Clamp(ply:Health()+50,0,ply:GetMaxHealth()))
		ply:EmitSound( PickupSound )
		self:Remove()
		return
	end
end
