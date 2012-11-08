ENT.Type			= "anim"
ENT.Base			= "base_entity"
ENT.PrintName		= "Shield Generator"

ENT.Author			= "kevkev/Warrior xXx"
ENT.Contact			= ""
ENT.Purpose			= "Protecting yourself from enemy fire"
ENT.Instructions	= "Place it on the ground and activate"
ENT.Category 		= "WDS2"
ENT.WireDebugName	= ENT.PrintName

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.DrainedThreshold = 200
ENT.DrainPerThink = 0
ENT.MaxEnergy = 1000
ENT.MaxRadius = 1024

function ENT:SetupDataTables()
	self:DTVar("Int",0,"Energy")
	self:DTVar("Int",1,"Radius")
end

function ENT:GetEnergy()
	return self.dt.Energy
end

function ENT:GetRadius()
	return self.dt.Radius
end
