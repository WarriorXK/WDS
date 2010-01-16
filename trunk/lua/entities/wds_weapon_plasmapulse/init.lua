AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(1,0,0)
ENT.ExplodeRadius	= 10
ENT.ChargeEffect	= "wds_weapon_plasmapulse_charge"
ENT.ShootEffect		= ""
ENT.ChargeSound		= "wds/weapons/plasmapulse/powerup.wav"
ENT.ShootOffset		= 42
ENT.ReloadDelay		= 0
ENT.ReloadSound		= ""
ENT.ShootSound		= "wds/weapons/plasmapulse/shoot.wav"
ENT.Projectile		= "wds_projectile_plasma"
ENT.ChargeTime		= 2
ENT.FireDelay		= 5
ENT.MaxAmmo			= 0
ENT.Damage			= 150
ENT.Model			= "models/wds/device05.mdl"
ENT.Class			= "wds_weapon_plasmapulse"
ENT.Speed			= 5000

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create(self.Class)
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end
