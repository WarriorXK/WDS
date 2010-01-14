AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(1,0,0)
ENT.ShootPosses =	{
						Vector(10,0,4.5),
						Vector(10,4.5,0),
						Vector(10,0,-4.5),
						Vector(10,-4.5,0),
					}
ENT.ExplodeRadius	= 200
ENT.TraceEffect		= ""
ENT.ShootEffect		= "wds_weapon_nebelwerfer_shot"
ENT.ShootOffset		= 40
ENT.ChargeSound		= ""
ENT.ShootSound		= "wds/weapons/nebelwerfer/fire.wav"
ENT.FireDelay		= 30
ENT.Damage			= 300
ENT.Model			= "models/wds/device04.mdl"
ENT.Class			= "wds_weapon_nebelwerfer"

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
	local Am = table.Count(self.ShootPosses)
	for i=1,4 do
		for b=1,Am do
			timer.Simple(i+(b/Am),self.Shoot,self,self.ShootPosses[b],i)
		end
	end
	self:SetNextFire(CurTime()+self.FireDelay)
end

function ENT:Shoot(pos,mode)
	if !self or !self:IsValid() then return end
	local ent = ents.Create("wds_projectile_nebel")
	ent:SetPos(self:LocalToWorld(pos))
	local ang = self:LocalToWorldAngles(self.ShootDirection:Angle())
	ang:RotateAroundAxis(ang:Right(),-math.random(85,95))
	ang:RotateAroundAxis(ang:Forward(),math.random(-5,5))
	ent:SetAngles(ang)
	ent.WDSO = self.WDSO or self
	ent.WDSE = self
	ent:SetDamage(self.Damage)
	ent:SetRadius(self.ExplodeRadius)
	ent:SetSpeed(math.random(1300,1600))
	ent:SetMode(mode)
	ent:Spawn()
	ent:Activate()
	local ed = EffectData()
		ed:SetEntity(self)
		ed:SetOrigin(pos)
	util.Effect(self.ShootEffect,ed)
	if self.ShootSound then self:EmitSound(self.ShootSound) end
end
