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

function ENT:SetupDataTables()
	self:DTVar("Int",0,"Energy")
end

function ENT:GetEnergy()
	return self.dt.Energy
end
