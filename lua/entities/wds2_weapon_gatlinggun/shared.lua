ENT.Type			= "anim"
ENT.Base			= "base_entity"
ENT.PrintName		= "Gatling Gun"

ENT.Author			= "kevkev/Warrior xXx"
ENT.Contact			= ""
ENT.Purpose			= "Targetting fast moving units using a high fire rate."
ENT.Instructions	= "Aim at your foe and fire it."
ENT.Category 		= "WDS2"
ENT.WireDebugName	= ENT.PrintName

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

function ENT:SetupDataTables()
	self:DTVar("Bool",0,"Overheated")
	self:DTVar("Float",0,"Heat")
end
