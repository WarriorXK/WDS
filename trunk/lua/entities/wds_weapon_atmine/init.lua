AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(0,0,1)
ENT.ExplodeRadius	= 0
ENT.ReloadSound		= ""
ENT.ShootOffset		= 1
ENT.ChargeSound		= ""
ENT.ReloadDelay		= 5
ENT.ShootSound		= ""
ENT.FireDelay		= 2
ENT.Ammo			= 5
ENT.Model			= "models/wds/device08.mdl"
ENT.Class			= "wds_weapon_atmine"

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
	if self.Ammo <= 0 then
		self.Ammo = 5
		self:SetNextFire(CurTime()+self.ReloadDelay)
		if self.ReloadSound then self:EmitSound(self.ReloadSound) end
		return
	end
	local tr = WDS.TraceLine(self:GetPos(),self:GetPos()+(self:GetUp()*-150),{self})
	if tr.Hit and tr.Entity:IsWorld() and !tr.HitSky then
		self.Ammo = self.Ammo-1
		local ent = ents.Create("wds_projectile_atmine")
		local ang = tr.HitNormal:Angle()
		ang:RotateAroundAxis(ang:Right(),-90)
		ent:SetAngles(self:GetAngles())
		ent:SetPos(tr.HitPos)
		ent.WDSO = self.WDSO
		ent.WDSE = self
		ent:Spawn()
		ent:Activate()
		if self.ShootSound then self:EmitSound(self.ShootSound) end
		self:SetNextFire(CurTime()+self.FireDelay)
	end
end
