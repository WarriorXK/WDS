ENT.Type			= "anim"
ENT.Base			= "wds_projectile_base"
ENT.PrintName		= "Anti Personell Mine"
ENT.Author			= "kevkev/Warrior xXx"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Category 		= "WDS"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.NoPhysgunPickup	= true

function ENT:SetupDataTables()
	self:DTVar("Float",0,"NextExplode")
	self:DTVar("Bool",0,"Warning")
	self:DTVar("Bool",1,"Online")
end
