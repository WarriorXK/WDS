ENT.Type			= "anim"
ENT.Base			= "base_entity"
ENT.PrintName		= "Core entity"

ENT.Author			= "kevkev/Warrior xXx"
ENT.Contact			= ""
ENT.Purpose			= "Linking your contraption to combine all health"
ENT.Instructions	= "All entities welded to this entity will have the combined health"
ENT.Category 		= "WDS2"
ENT.WireDebugName	= ENT.PrintName

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

function ENT:SetupDataTables()
	self:DTVar("Float", 0, "NextCoreCharge")
	self:DTVar("Int", 0, "CorePower")
end
