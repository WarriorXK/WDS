AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/wds/1024shield.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	//self:SetMaterial("models/props_combine/portalball001_sheet")
	self:DrawShadow(false)
	if !self.Generator then
		self.Generator = self:GetParent()
	end
end

function ENT:Think()
	if !self.Generator or !self.Generator:IsValid() then
		self:Remove()
		return
	end
end

function ENT:GetSize()
	return (Vector(0,0,self:OBBMaxs().z):Distance(Vector(0,0,self:OBBMins().z))/2)+2
end

function ENT:OnTakeDamage(dmginfo)
	local Dam = math.Clamp(dmginfo:GetDamage()/2,5,self.Generator.MaxDamage)
	self.Generator:SetEnergy(self.Generator.dt.Energy-Dam)
end
