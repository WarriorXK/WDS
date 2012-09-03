ENT.Type			= "anim"
ENT.Base			= "base_entity"
ENT.PrintName		= "Laser Guided Missle Launcher"

ENT.Author			= "kevkev/Warrior xXx"
ENT.Contact			= ""
ENT.Purpose			= "Shooting fast and random moving targets."
ENT.Instructions	= "Aim at your foe and fire it."
ENT.Category 		= "WDS2"
ENT.WireDebugName	= ENT.PrintName

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.LaserPos = Vector(17,0,9.4)

function ENT:SetupDataTables()
	self:DTVar("Bool",0,"LaserEnabled")
end

function ENT:GetLaserEnabled()
	return self.dt.LaserEnabled
end

function ENT:GetTrace()
	local Pos = self:LocalToWorld(self.LaserPos)
	return WDS2.TraceLine(Pos,Pos+(self:GetForward()*50000),{self})
end
