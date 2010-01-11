AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(0,0,1)
ENT.ExplodeRadius	= 10
ENT.BurstAmount		= 3
ENT.TraceEffect		= "wds_weapon_laserburst_trace"
ENT.ShootOffset		= 10
ENT.BurstDelay		= 0.1
ENT.ShootSound		= "wds/weapons/laserburst/shoot.wav"
ENT.FireDelay		= 1
ENT.Damage			= 12
ENT.Model			= "models/props_c17/canister01a.mdl"
ENT.Class			= "wds_weapon_laserburst"

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
	local Time = 0
	for i=1,self.BurstAmount do
		timer.Simple(Time,self.Shoot,self)
		Time = Time+self.BurstDelay
	end
	self:SetNextFire(CurTime()+self.FireDelay)
	if self.ChargeSound then self:EmitSound(self.ChargeSound) end
end

function ENT:Shoot()
	if !self or !self:IsValid() then return end
	local Pos = self:LocalToWorld(self.ShootDirection*self.ShootOffset)
	local tr = WDS.AttackTrace(Pos,self:LocalToWorld(self.ShootDirection*10000),{self},self.Damage,0,self.WDSO or self,self)
	local ed = EffectData()
		ed:SetOrigin(Pos)
		ed:SetStart(tr.HitPos)
	util.Effect(self.TraceEffect,ed)
	if self.ShootSound then self:EmitSound(self.ShootSound) end
end
