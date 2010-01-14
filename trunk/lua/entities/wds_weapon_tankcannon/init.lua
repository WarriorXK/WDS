AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(1,0,0)
ENT.ExplodeRadius	= 30
ENT.TraceEffect		= ""
ENT.ShootEffect		= "wds_weapon_tankcannon_shot"
ENT.ReloadSound		= ""
ENT.ShootOffset		= 40
ENT.ChargeSound		= ""
ENT.ReloadDelay		= 5
ENT.ShootSound		= "wds/weapons/tankcannon/fire.wav"
ENT.FireDelay		= 1.5
ENT.Ammo			= 5
ENT.Damage			= 130
ENT.Model			= "models/wds/device02.mdl"
ENT.Class			= "wds_weapon_tankcannon"

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
	if self.Ammo <= 0 then
		self.Ammo = 5
		self:SetNextFire(CurTime()+self.ReloadDelay)
		if self.ReloadSound then self:EmitSound(self.ReloadSound) end
		return
	end
	self.Ammo = self.Ammo-1
	local ent = ents.Create("wds_projectile_tankshell")
	ent:SetPos(self:LocalToWorld(self.ShootDirection*self.ShootOffset))
	local ang = self:LocalToWorldAngles(self.ShootDirection:Angle())
	ang:RotateAroundAxis(ang:Right(),-90)
	ent:SetAngles(ang)
	ent.WDSO = self.WDSO or self
	ent.WDSE = self
	ent:SetDamage(self.Damage)
	ent:SetRadius(self.ExplodeRadius)
	ent:SetSpeed(3000)
	ent:Spawn()
	ent:Activate()
	if self.ShootSound then self:EmitSound(self.ShootSound) end
	local ed = EffectData()
		ed:SetEntity(self)
		ed:SetOrigin(self.ShootDirection*self.ShootOffset)
	util.Effect(self.ShootEffect,ed)
	self:SetNextFire(CurTime()+self.FireDelay)
end
