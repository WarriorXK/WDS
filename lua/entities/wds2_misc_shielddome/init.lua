AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/wds/1024shield.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:SetRenderMode(RENDERMODE_TRANSTEXTURE)
	self:DrawShadow(false)
end

function ENT:Think()
	//self:CheckColor()
	if !ValidEntity(self.Generator) then self:Remove() end
end

function ENT:CheckColor()
	self:SetColor(Color(255,255,255, 40 + (math.sin(CurTime()) * 20)))
	PrintTable(self:GetColor())
end

function ENT:OnTakeDamage(...)
	self.Generator:DomeTakeDamage(...)
end

function ENT:PhysicsCollide(...)
	self.Generator:DomePhysicsCollide(...)
end
