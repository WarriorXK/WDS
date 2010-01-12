AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(0,0,1)
ENT.ExplodeRadius	= 10
ENT.ChargeEffect	= "wds_weapon_gaussgun_charge"
ENT.TraceEffect		= ""
ENT.ShootOffset		= 40
ENT.ChargeSound		= "weapons/gauss/chargeloop.wav"
ENT.LastCharge		= 0
ENT.ShootSound		= "weapons/gauss/fire1.wav"
ENT.FireDelay		= 5
ENT.Damage			= 30
ENT.Charge			= 0
ENT.Model			= "models/props_c17/canister01a.mdl"
ENT.Class			= "wds_weapon_gaussgun"

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create(self.Class)
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end

function ENT:Think()
	self.BaseClass["Think"](self)
	if self.Wire_In["On"] == 0 and self.Charge > 0 then
		self:Shoot()
		if self.Sound then
			self.Sound:Stop()
			self.Sound = nil
		end
		self.Charge = 0
		self:SetNextFire(CurTime()+self.FireDelay)
	end
end

function ENT:FireShot()
	if self.LastCharge <= CurTime() then
		self.Charge = math.Clamp(self.Charge+0.3,1,10)
		if !self.Sound then
			self.Sound = CreateSound(self,self.ChargeSound)
			self.Sound:Play()
		end
		self.Sound:ChangePitch(20+(self.Charge*20))
		self.LastCharge = CurTime()+0.1
	end
end

function ENT:Shoot()
	local ent = ents.Create("wds_projectile_gauss")
	ent:SetPos(self:LocalToWorld(self.ShootDirection*self.ShootOffset))
	local ang = self:LocalToWorldAngles(self.ShootDirection:Angle())
	ang:RotateAroundAxis(ang:Right(),-90)
	ent:SetAngles(ang)
	ent.WDSO = self.WDSO or self
	ent.WDSE = self
	ent:SetDamage(self.Damage*self.Charge)
	ent:SetRadius(self.ExplodeRadius+(self.Charge*2))
	ent:SetSpeed(1000+(math.Clamp((self.Charge/2)*1000),2000,6000))
	ent:Spawn()
	ent:Activate()
	if self.ShootSound then self:EmitSound(self.ShootSound) end
end
