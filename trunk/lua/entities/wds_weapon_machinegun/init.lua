AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection = Vector(0,0,1)
ENT.ExplodeRadius = 10
ENT.TraceEffect = "wds_tracer_medbullet"
ENT.ShootOffset = 10
ENT.ShootSound = ""
ENT.FireDelay = 0.1
ENT.Damage = 4
ENT.Model = "models/props_c17/canister01a.mdl"
ENT.Class = "wds_weapon_machinegun"

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create(self.Class or "wds_weapon_base")
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end
