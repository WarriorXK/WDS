AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(1,0,0)
ENT.ExplodeRadius	= 10
ENT.ChargeEffect	= "wds_weapon_plasmapulse_charge"
ENT.TraceEffect		= ""
ENT.ShootOffset		= 42
ENT.ChargeSound		= "wds/weapons/plasmapulse/powerup.wav"
ENT.ShootSound		= "wds/weapons/plasmapulse/shoot.wav"
ENT.ChargeTime		= 2
ENT.FireDelay		= 5
ENT.Damage			= 150
ENT.Model			= "models/wds/device05.mdl"
ENT.Class			= "wds_weapon_plasmapulse"

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create(self.Class or "wds_weapon_base")
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end

function ENT:FireShot()
	timer.Simple(self.ChargeTime,self.Shoot,self)
	local ed = EffectData()
		ed:SetEntity(self)
		ed:SetOrigin(self.ShootDirection*self.ShootOffset)
		ed:SetScale(self.ChargeTime)
	util.Effect(self.ChargeEffect,ed)
	self:SetNextFire(CurTime()+self.FireDelay)
	if self.ChargeSound then self:EmitSound(self.ChargeSound) end
end

function ENT:Shoot()
	if !self or !self:IsValid() then return end
	local ent = ents.Create("wds_projectile_plasma")
	ent:SetPos(self:LocalToWorld(self.ShootDirection*self.ShootOffset))
	local ang = self:LocalToWorldAngles(self.ShootDirection:Angle())
	ang:RotateAroundAxis(ang:Right(), -90)
	ent:SetAngles(ang)
	ent.WDSO = self.WDSO or self
	ent.WDSE = self
	ent:SetDamage(self.Damage)
	ent:SetRadius(self.ExplodeRadius)
	ent:SetSpeed(5000)
	ent:Spawn()
	ent:Activate()
	if self.ShootSound then self:EmitSound(self.ShootSound) end
end
