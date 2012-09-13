AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Charge = 0

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
		phys:SetVelocityInstantaneous(self:GetForward()*1500)
	end
	local ed = EffectData()
		ed:SetMagnitude(self.Charge)
		ed:SetEntity(self)
	util.Effect("wds2_plasmacharger_trail",ed,true,true)
end

function ENT:Touch(ent)
	if IsValid(ent) and ent:GetClass() == "shield" then // Stargate shield Support
		self:Explode()
	end
end

function ENT:PhysicsCollide(data,physobj)
	self:Explode(data.HitPos)
	return
end

function ENT:SetCharge(Charge)
	self.Charge = Charge
end

function ENT:Explode(pos)

	local Damage = 50 * self.Charge
	pos = pos or self:GetPos()
	
	WDS2.CreateExplosion(pos, 50 * self.Charge, Damage, self)
	local ed = EffectData()
		ed:SetMagnitude(self.Charge)
		ed:SetOrigin(pos)
		ed:SetStart(-self:WorldToLocal(self:GetVelocity()))
	util.Effect("wds2_plasmacharger_hit",ed,true,true)
	
	local DmgInfo = DamageInfo()
	DmgInfo:SetAttacker(self.WDSO)
	DmgInfo:SetInflictor(self)
	DmgInfo:SetDamageType(DMG_DISSOLVE)
	
	for _,v in pairs(ents.FindInSphere(pos, 150)) do
		if v:IsPlayer() or v:IsNPC() then
			DmgInfo:SetDamage(math.Clamp(Damage*-((self:GetPos():Distance(v:GetPos())/150)-1),5,Damage))
			v:TakeDamageInfo(DmgInfo)
		end
	end
	
	self:Remove()
	
end
