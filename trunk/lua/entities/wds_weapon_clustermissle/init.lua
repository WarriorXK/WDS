AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(0,0,1)
ENT.ExplodeRadius	= 10
ENT.TraceEffect		= ""
ENT.ShootEffect		= "wds_weapon_clustermissle_shoot"
ENT.ShootOffset		= 40
ENT.ShootSound		= ""
ENT.FireDelay		= 10
ENT.Radius			= 40
ENT.Damage			= 150
ENT.Model			= "models/props_c17/canister01a.mdl"
ENT.Class			= "wds_weapon_clustermissle"

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create(self.Class)
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end

function ENT:FireShot()
	local ent = ents.Create("wds_projectile_clustermissle")
	ent:SetPos(self:LocalToWorld(self.ShootDirection*self.ShootOffset))
	local ang = self:LocalToWorldAngles(self.ShootDirection:Angle())
	ang:RotateAroundAxis(ang:Right(),-90)
	ent:SetAngles(ang)
	ent.WDSO = self.WDSO or self
	ent.WDSE = self
	ent.Launcher = self
	ent.LockTime = 0.5
	ent:SetDamage(self.Damage)
	ent:SetRadius(self.ExplodeRadius)
	ent:SetSpeed(1000)
	ent:Spawn()
	ent:Activate()
	if self.ShootSound then self:EmitSound(self.ShootSound) end
	local ed = EffectData()
		ed:SetEntity(self)
		ed:SetOrigin(self.ShootDirection*self.ShootOffset)
	util.Effect(self.ShootEffect,ed)
	self:SetNextFire(CurTime()+self.FireDelay)
end
