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

function ENT:TakeShieldDamage(Dam,Pos)
	self.Generator:DrainEnergy(Dam)
	if Pos then
		local ed = EffectData()
			ed:SetEntity(self)
			ed:SetOrigin(Pos)
			ed:SetNormal((self:GetPos()-Pos):Normalize())
			ed:SetScale(1*(math.Clamp(Dam/20,1,5)))
		util.Effect("wds_shield_hit",ed)
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakeShieldDamage(dmginfo:GetDamage(),dmginfo:GetDamagePosition())
end

function WDS_ShieldDome_TakeDamage(ent,dmg,pos)
	if ent:GetClass() == "wds_tool_shielddome" then
		ent:TakeShieldDamage(math.Clamp(dmg/2,5,ent.Generator.MaxDamage),pos)
		return false
	end
end
hook.Add("WDS_EntityTakeDamage","WDS_ShieldDome_TakeDamage",WDS_ShieldDome_TakeDamage)


hook.Add("PhysgunPickup","WDS_ShieldDome_PhysgunPickup",function(ply,ent)
	if ent:GetClass() == "wds_tool_shielddome" then return false end
end)

hook.Add("CanTool","WDS_ShieldDome_CanTool",function(ply,tr,toolmode)
	if tr.Entity:GetClass() == "wds_tool_shielddome" then return false end
end)
