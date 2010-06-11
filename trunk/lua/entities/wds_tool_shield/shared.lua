ENT.Type			= "anim"
ENT.Base			= "base_entity"
ENT.PrintName		= "Shield"
ENT.WireDebugName	= ENT.PrintName
ENT.Author			= "kevkev/Warrior xXx"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Category 		= "WDS"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

function ENT:SetupDataTables()
	self:DTVar("Int",0,"Energy")
	self:DTVar("Int",1,"Strength")
	self:DTVar("Bool",0,"Online")
	self:DTVar("Entity",0,"ShieldEntity")
end

function ENT:IsOnline()
	return ValidEntity(self.dt.ShieldEntity)
end

function ENT:GetStrength()
	return self.dt.Strength
end

function ENT:GetEnergy()
	return self.dt.Energy
end

function ENT:GetShieldEntity()
	return self.dt.ShieldEntity
end

function ENT:GetSize()
	return 1024
end
