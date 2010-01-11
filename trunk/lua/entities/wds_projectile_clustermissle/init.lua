AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ClusterPosses =	{
						Vector(1,0,0),
						Vector(1,1,0),
						Vector(0,1,0),
						Vector(-1,1,0),
						Vector(-1,0,0),
						Vector(-1,-1,0),
						Vector(0,-1,0),
						Vector(1,-1,0)
					}
ENT.ExplodeEffect	= ""
ENT.ClusterClass	= "wds_projectile_cluster"
ENT.TrailEffect		= "wds_projectile_clustermissle_trail"
ENT.Velocity		= 1000
ENT.LockTime		= 0
ENT.Gravity			= true
ENT.Radius			= 40
ENT.Damage			= 150
ENT.Model			= "models/wds/bullet.mdl"
ENT.Drag			= true

function ENT:Think() end

function ENT:Explode(data)
	local e = ents.Create("prop_physics")
	e:SetModel(self:GetModel())
	e:SetColor(self:GetColor())
	e:SetSkin(self:GetSkin())
	e:Spawn()
	e:Activate()
	local phys = e:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetVelocityInstantaneous(self:GetVelocity())
	end
	local Tab = {}
	for _,v in pairs(self.ClusterPosses) do
		local e = ents.Create(self.ClusterClass)
		e:SetPos(self:LocalToWorld(v*10))
		e:SetAngles(self:GetAngles())
		e:SetDamage(self.Damage)
		e:SetRadius(self.Radius)
		e.WDSO = self.WDSO or self
		e.WDSE = self
		e:Spawn()
		e:Activate()
		local phys = e:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetVelocityInstantaneous(self:GetVelocity()+(v*math.random(80,100)))
		end
		table.insert(Tab,e)
	end
	for _,v in pairs(Tab) do
		v.Filter = Tab
	end
end

function ENT:PhysicsSimulate(phys,deltatime)
	local TAngle = self:GetAngles()
	if self.Launcher and self.Launcher:IsValid() and self.Launcher.TargetPos and self.LockTime <= CurTime() then
		TAngle = (self.Launcher.TargetPos-self:GetPos()):Angle()
	end
	phys:Wake()
	local pr = {}
	pr.secondstoarrive	= 8
	pr.pos				= self:GetPos()+self:GetUp()*(self.Velocity*3)
	pr.maxangular		= 90000
	pr.maxangulardamp	= 90000
	pr.maxspeed			= 1000000
	pr.maxspeeddamp		= 10000
	pr.dampfactor		= 0.1
	pr.teleportdistance	= 5000
	pr.deltatime		= deltatime
	pr.angle			= TAngle
	phys:ComputeShadowControl(pr)
end
