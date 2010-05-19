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
	self:DTVar("Int",0,"LastHit")
	self:DTVar("Int",1,"Energy")
	self:DTVar("Bool",0,"Online")
end
