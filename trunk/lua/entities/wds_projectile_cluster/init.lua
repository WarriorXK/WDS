AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ExplodeEffect	= "wds_projectile_cluster_explosion"
ENT.TrailEffect		= "wds_projectile_cluster_trail"
ENT.Velocity		= 0
ENT.Gravity			= true
ENT.Filter			= {}
ENT.Radius			= 40
ENT.Damage			= 150
ENT.Model			= "models/wds/bullet.mdl"
ENT.Drag			= true

function ENT:Think() end

function ENT:Explode(data)
	WDS.Explosion(data.HitPos,self.Radius,self.Damage,self.Filter,self.WDSO,self)
	local ed = EffectData()
		ed:SetOrigin(data.HitPos)
		ed:SetMagnitude(self.Radius)
	util.Effect(self.ExplodeEffect,ed)
end
