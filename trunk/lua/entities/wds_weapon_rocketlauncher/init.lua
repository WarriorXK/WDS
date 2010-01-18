AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(1,0,0)
ENT.ExplodeRadius	= 90
ENT.ChargeEffect	= ""
ENT.ShootEffect		= "wds_weapon_rocketlauncher_shoot"
ENT.ChargeSound		= ""
ENT.ShootOffset		= 40
ENT.ReloadDelay		= 5
ENT.ReloadSound		= "wds/weapons/rocketlauncher/reload.wav"
ENT.ShootSound		= "wds/weapons/rocketlauncher/fire.wav"
ENT.Projectile		= "wds_projectile_rocket"
ENT.ChargeTime		= 0
ENT.FireDelay		= 0.8
ENT.MaxAmmo			= 4
ENT.Damage			= 120
ENT.Model			= "models/wds/device03.mdl"
ENT.Class			= "wds_weapon_rocketlauncher"
ENT.Speed			= 3500

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create(self.Class)
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end
