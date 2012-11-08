ENT.Type			= "anim"
ENT.Base			= "base_entity"
ENT.PrintName		= "Shield Dome"

ENT.Author			= "kevkev/Warrior xXx"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Category 		= "WDS2"
ENT.WireDebugName	= ENT.PrintName

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.NoPhysgunPickup	= true

function ENT:SetupDataTables()
	self:DTVar("Entity",0,"Generator")
end
