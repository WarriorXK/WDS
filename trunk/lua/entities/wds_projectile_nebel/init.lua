AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ExplodeEffect	= "wds_projectile_nebel_explosion"
ENT.TrailEffect		= "wds_projectile_nebel_trail"
ENT.SmokeEffect		= "wds_projectile_nebel_smoke"
ENT.Velocity		= 0
ENT.Gravity			= true
ENT.Radius			= 40
ENT.Damage			= 150
ENT.Model			= "models/wds/bullet.mdl"
ENT.Drag			= true

AccessorFunc(ENT,"Mode","Mode",FORCE_NUMBER)

function ENT:Think() end

function ENT:Explode(data)
	if tobool(string.find(tostring(math.Round(self:GetMode())/2),".5")) then // If an even number
		WDS.Explosion(data.HitPos,self.Radius,self.Damage,{self},self.WDSO,self)
		local ed = EffectData()
			ed:SetOrigin(data.HitPos)
			ed:SetMagnitude(self.Radius)
		util.Effect(self.ExplodeEffect,ed)
	else
		local ed = EffectData()
			ed:SetOrigin(data.HitPos)
			ed:SetMagnitude(32)
		util.Effect(self.SmokeEffect,ed)
	end
end
