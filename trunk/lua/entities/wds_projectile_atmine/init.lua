AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ExplodeEffect	= "wds_projectile_atmine_explosion"
ENT.ExplodeSound	= Sound("WDS/weapons/apmine/explode.wav")
ENT.TrailEffect		= ""
ENT.Velocity		= 0
ENT.Gravity			= true
ENT.Radius			= 150
ENT.Damage			= 300
ENT.Model			= "models/wds/at_mine.mdl"
ENT.Drag			= true

function ENT:SecondInit()
	WDS.InitEntity(self,1)
	self:SetMoveType(MOVETYPE_NONE)
end

function ENT:PhysicsCollide(data,physobj) end
function ENT:Think() end

function ENT:Touch(ent)
	constraint.RemoveAll(ent)
	self:Explode()
end

function ENT:Use(ent)
	self.dt.Online = !self.dt.Online or false
	if !self.dt.Online then
		self:EmitSound(self.DisarmedSound)
	else
		self:EmitSound(self.ArmedSound)
	end
end

function ENT:Explode()
	WDS.Explosion(self:GetPos()+(self:GetUp()*5),self.Radius,self.Damage,{self},self.WDSO,self)
	local ed = EffectData()
		ed:SetOrigin(self:GetPos())
	util.Effect(self.ExplodeEffect,ed)
	self:EmitSound(self.ExplodeSound,100,100)
	self:Remove()
end
