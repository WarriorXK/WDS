AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection = Vector(0,0,1)
ENT.ExplodeRadius = 10
ENT.TraceEffect = ""
ENT.ShootOffset = 10
ENT.ChargeSound = ""
ENT.ShootSound = ""
ENT.ChargeTime = 2
ENT.FireDelay = 5
ENT.Damage = 4
ENT.Model = "models/props_c17/canister01a.mdl"
ENT.Class = "wds_weapon_plasmapulse"

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
		ed:SetScale(self.ChargeTime+0.1)
	util.Effect("wds_weapon_plasmapulse_charge",ed)
	self:SetNextFire(CurTime()+self.FireDelay)
	if self.ChargeSound then self:EmitSound(self.ChargeSound) end
end

function ENT:Shoot()
	if !self or !self:IsValid() then return end
	local ent = ents.Create("wds_projectile_plasma")
	ent:SetPos(self:LocalToWorld(self.ShootDirection*self.ShootOffset))
	ent:SetAngles(self.ShootDirection:Angle())
	ent.WDSO = self.WDSO or self
	ent.WDSE = self
	ent:SetDamage(self.Damage)
	ent:SetRadius(self.ExplodeRadius)
	ent:Spawn()
	ent:Activate()
	if self.ShootSound then self:EmitSound(self.ShootSound) end
end
