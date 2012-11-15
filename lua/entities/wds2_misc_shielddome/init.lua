AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	self:SetModel("models/wds/1024shield.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self:SetRenderMode(RENDERMODE_TRANSTEXTURE)
	self:DrawShadow(false)
	
end

function ENT:Think()
	if !IsValid(self.dt.Generator) then self:Remove() end
end

function ENT:OnTakeDamage(...)
	self.dt.Generator:DomeTakeDamage(...)
end

function ENT:PhysicsCollide(...)
	self.dt.Generator:DomePhysicsCollide(...)
end

hook.Add("WDS2_EntityShouldTakeDamage", "WDS2_EntityShouldTakeDamage_shieldgen", function(ent, damage)

	if IsValid(ent) and ent:GetClass() == "wds2_misc_shielddome" then
	
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(damage)
		ent:TakeDamage(dmginfo)
		
	end
	
end)
