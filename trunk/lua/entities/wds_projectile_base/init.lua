AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

// Edit these variables on your own ent.
ENT.ExplodeEffect	= "wds_projectile_base_explosion"
ENT.TrailEffect		= "wds_projectile_base_trail"
ENT.Velocity		= 1000
ENT.Gravity			= false
ENT.Radius			= 10
ENT.Damage			= 10
ENT.Model			= "models/wds/bullet.mdl"
ENT.Drag			= false

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableGravity(self.Gravity)
		phys:EnableDrag(self.Drag)
		phys:SetVelocityInstantaneous(self:GetUp()*self.Velocity)
	end
	if type(self.PhysicsSimulate) == "function" then
		self:StartMotionController()
	end
	local ed = EffectData()
		ed:SetEntity(self)
	util.Effect(self.TrailEffect,ed)
	if self.SecondInit then
		self:SecondInit()
	end
end

AccessorFunc(ENT,"Velocity","Speed",FORCE_NUMBER)
AccessorFunc(ENT,"Radius","Radius",FORCE_NUMBER)
AccessorFunc(ENT,"Damage","Damage",FORCE_NUMBER)

function ENT:Think() end

function ENT:PhysicsCollide(data,physobj)
	self:Explode(data)
	if self and self:IsValid() then self:Remove() end
end

function ENT:Explode(data)
	WDS.Explosion(data.HitPos,self.Radius,self.Damage,{self},self.WDSO,self)
	local ed = EffectData()
		ed:SetOrigin(data.HitPos)
		ed:SetMagnitude(self.Radius)
	util.Effect(self.ExplodeEffect,ed)
end
