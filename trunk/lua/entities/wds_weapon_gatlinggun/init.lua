AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootPosses =	{
						Vector(25,-1.2,6.4),
						Vector(25,2.7,4.2),
						Vector(25,4.8,0.3),
						Vector(25,2.7,-3.8),
						Vector(25,-1,-5.5),
						Vector(25,-5.3,-3.7),
						Vector(25,-7,0.2),
						Vector(25,-5.2,4.1),
					}
ENT.ShootDirection	= Vector(1,0,0)
ENT.ExplodeRadius	= 10
ENT.TraceEffect		= "wds_weapon_gatlinggun_trace"
ENT.ShootOffset		= 10
ENT.ShootSound		= ""
ENT.FireDelay		= 0.1
ENT.NextHole		= 1
ENT.Damage			= 9
ENT.Model			= "models/wds/device06.mdl"
ENT.Class			= "wds_weapon_gatlinggun"

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
	local Pos = self:LocalToWorld(self.ShootPosses[self.NextHole])
	self.NextHole = self.NextHole+1
	if self.NextHole > table.Count(self.ShootPosses) then self.NextHole = 1 end
	local Rad = 0
	if self.ExplodeHit and self.ExplodeRadius and self.ExplodeRadius > 0 then
		Rad = self.ExplodeRadius
	end
	local tr = WDS.AttackTrace(Pos,self:LocalToWorld(self.ShootDirection*10000),{self},self.Damage,Rad,self.WDSO or self,self)
	local ed = EffectData()
		ed:SetOrigin(Pos)
		ed:SetStart(tr.HitPos)
	util.Effect(self.TraceEffect,ed)
	if self.ShootSound then self:EmitSound(self.ShootSound) end
	self:SetNextFire(CurTime()+self.FireDelay)
end
