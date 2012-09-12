ENT.Type			= "anim"
ENT.Base			= "base_entity"
ENT.PrintName		= "Plasma Charger"

ENT.Author			= "kevkev/Warrior xXx"
ENT.Contact			= ""
ENT.Purpose			= "Blasting your foe's buildings to dust."
ENT.Instructions	= "Aim at your foe and fire it."
ENT.Category 		= "WDS2"
ENT.WireDebugName	= ENT.PrintName

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end
