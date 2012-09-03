ENT.Type			= "anim"
ENT.Base			= "base_entity"
ENT.PrintName		= "Health Meter"

ENT.Author			= "kevkev/Warrior xXx"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Category 		= "WDS2"
ENT.WireDebugName	= ENT.PrintName

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

function ENT:GetTrace()
	return WDS2.TraceLine(self:GetPos(),self:GetPos()+(self:GetForward()*50000),{self})
end

function ENT:SetupDataTables()
	self:DTVar( "Float", 0, "Health" )
end
