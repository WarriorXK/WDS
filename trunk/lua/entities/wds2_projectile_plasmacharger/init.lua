AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

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
		ed:SetEntity(self)
	util.Effect("wds2_plasmacharger_trail",ed,true,true)
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
	WDS2.CreateExplosion(pos,150,150,self)
	local ed = EffectData()
		ed:SetOrigin(pos)
		ed:SetStart(-self:WorldToLocal(self:GetVelocity()))
	util.Effect("wds2_plasmacharger_hit",ed,true,true)
	local DmgInfo = DamageInfo()
	DmgInfo:SetAttacker(self.WDSO)
	DmgInfo:SetInflictor(self)
	DmgInfo:SetDamageType(DMG_DISSOLVE)
	
	local Damage = 150
	
	for _,v in pairs(ents.FindInSphere(pos, 150)) do
		if v:IsPlayer() or v:IsNPC() then
			DmgInfo:SetDamage(math.Clamp(Damage*-((self:GetPos():Distance(v:GetPos())/150)-1),5,Damage))
			v:TakeDamageInfo(DmgInfo)
		end
	end
	self:Remove()
end
