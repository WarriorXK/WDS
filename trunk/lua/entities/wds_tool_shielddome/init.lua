AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local ShieldMat = "models/props_combine/health_charger_glass"

function ENT:Initialize()
	self:SetModel("models/wds/1024shield.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:DrawShadow(false)
	if !self.Generator then
		self.Generator = self:GetParent()
	end
	timer.Simple(0,function()
		self:SetMaterial(ShieldMat)
	end)
end

function ENT:Think()
	if !self.Generator or !self.Generator:IsValid() then
		self:Remove()
		return
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakeWDSDamage(dmginfo:GetDamage())
end

function ENT:TakeWDSDamage(dmg)
	self.Generator:DrainEnergy(math.Clamp(dmg/2,5,self.Generator.MaxDamage))
end

function WDS_ShieldDome_TakeDamage(ent,dmg)
	if ent:GetClass() == "wds_tool_shielddome" then
		ent:TakeWDSDamage(dmg)
		return false
	end
end
hook.Add("WDS_EntityTakeDamage","WDS_ShieldDome_TakeDamage",WDS_ShieldDome_TakeDamage)
