AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.NextDamage = 0

function ENT:Initialize()
	self:SetModel("models/wds/pball.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetVelocityInstantaneous(self:GetForward() * 4000)
	end
	local ed = EffectData()
		ed:SetEntity(self)
	util.Effect("wds2_flamethrower_balltrail",ed,true,true)
	self.ImmuneToFire = true
end

function ENT:Think()
	self:NextThink(CurTime())
	return true
end

function ENT:Touch(ent)
	if IsValid(ent) and ent:GetClass() == "shield" then // Stargate shield Support
		self:Die()
	end
end

function ENT:PhysicsCollide(data,physobj)
	self:Die(data.HitEntity)
	return
end

function ENT:Die(ent)
	if IsValid(ent) then
		local Att = IsValid(self.WDSO) and self.WDSO or self.Cannon
		local DmgInfo = DamageInfo()
		DmgInfo:SetAttacker(self.WDSO)
		DmgInfo:SetInflictor(self)
		DmgInfo:SetDamageType(DMG_BURN)
		DmgInfo:SetDamage(math.random(40,60))
		ent:TakeDamageInfo(DmgInfo)
	end
	local ed = EffectData()
		ed:SetOrigin(self:GetPos())
	util.Effect("wds2_flamethrower_fireballdeath",ed)
	self:Remove()
end
