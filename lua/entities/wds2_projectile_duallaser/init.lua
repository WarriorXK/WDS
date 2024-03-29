AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	self:SetModel("models/wds/shard.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
	
		phys:Wake()
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetVelocityInstantaneous(self:GetForward() * 10000)
		
	end
	
end

function ENT:Touch(ent)

	if IsValid(ent) and ent:GetClass() == "shield" then // Stargate shield Support
	
		self:Hit(ent)
		
	end
	
end

function ENT:PhysicsCollide(data,physobj)

	self:Hit(data.HitEntity, data)
	return
	
end

function ENT:Hit(hitent, data)

	if data then
	
		local ed = EffectData()
			ed:SetOrigin(data.HitPos)
			ed:SetNormal(data.HitNormal)
		util.Effect("wds2_duallaser_hit",ed,true,true)
		
	end
	
	local DmgInfo = DamageInfo()
		DmgInfo:SetAttacker(self.WDSO)
		DmgInfo:SetInflictor(self)
		DmgInfo:SetDamageType(DMG_DISSOLVE)
		DmgInfo:SetDamage(math.random(15,30))
	hitent:TakeDamageInfo(DmgInfo)
	WDS2.DealDirectDamage(hitent,15,"AT")
	
	self:Remove()
	
end

function WDS2_DualLaserTurret_EntityTakeDamage(Target, DmgInfo)

	local Inflictor = DmgInfo:GetInflictor()
	
	if IsValid(Inflictor) and Inflictor:GetClass() == "wds2_projectile_duallaser" then // Prevents damage from the projectile as physical object

		if DmgInfo:GetDamageType() == DMG_CRUSH then
		
			DmgInfo:ScaleDamage(0)
			
		end
		
		DmgInfo:SetDamageForce(WDS2.ZeroVector)
		
	end
	
end
hook.Add("EntityTakeDamage","WDS2_DualLaserTurret_EntityTakeDamage",WDS2_DualLaserTurret_EntityTakeDamage)
