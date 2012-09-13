AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/wds/jetfuel.mdl")
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
	self:Charge(ply)
end

function ENT:Use(ply)
	self:Charge(ply)
end

function ENT:Charge(ply)
	if ply:IsPlayer() then
		local Jetpack = ply:GetWeapon("wds2_swep_landjetpack")
		if IsValid(Jetpack) and Jetpack.dt.JetCharge < WDS2.Jetpack.MaxEnergy then
			Jetpack.dt.JetCharge = math.Clamp(Jetpack.dt.JetCharge + 100,0,WDS2.Jetpack.MaxEnergy)
			ply:EmitSound("items/battery_pickup.wav")
			self:Remove()
			return
		end
	end
end
