AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootDirection	= Vector(0,0,1)
ENT.ExplodeRadius	= 10
ENT.ChargeEffect	= ""
ENT.ShootEffect		= "wds_weapon_base_shoot"
ENT.ChargeSound		= ""
ENT.ShootOffset		= 40
ENT.ReloadDelay		= 4
ENT.ReloadSound		= ""
ENT.ShootSound		= ""
ENT.Projectile		= ""
ENT.ChargeTime		= 0
ENT.FireDelay		= 1
ENT.MaxAmmo			= 0
ENT.Damage			= 40
ENT.Model			= "models/props_c17/canister01a.mdl"
ENT.Class			= "wds_weapon_base"
ENT.Speed			= 0

ENT.NextFire		= 0
ENT.Ammo			= ENT.MaxAmmo or 0

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.Inputs = Wire_CreateInputs(self,{"On"})
	self.Outputs = Wire_CreateOutputs(self,{"Can Fire"})
	self._Wire_Out = {}
	self.Wire_Out = {}
	self.Wire_In = {}
	if self.SecondInit then
		self:SecondInit()
	end
end

AccessorFunc(ENT,"NextFire","NextFire",FORCE_NUMBER)

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
	if tobool(self.Wire_In["On"]) and self:CanFire() then
		self:FireShot()
	end
	self.Wire_Out["Can Fire"] = tonumber(self:CanFire())
	self:UpdateWire()
	self:NextThink(CurTime())
	return true
end

function ENT:FireShot()
	if self.MaxAmmo and self.MaxAmmo > 0 then
		if self.Ammo < 0 then
			self.Ammo = self.MaxAmmo
			self:SetNextFire(CurTime()+self.ReloadDelay)
			return
		else
			self.Ammo = self.Ammo-1
		end
	end
	if self.ChargeTime and self.ChargeTime > 0 then
		timer.Simple(self.ChargeTime,self.Shoot,self)
	else
		self:Shoot()
	end
	local ed = EffectData()
		ed:SetEntity(self)
		ed:SetOrigin(self.ShootDirection*self.ShootOffset)
		ed:SetScale(self.ChargeTime)
	util.Effect(self.ChargeEffect,ed)
	self:SetNextFire(CurTime()+self.FireDelay)
	if self.ChargeSound then self:EmitSound(self.ChargeSound) end
end

function ENT:Shoot()
	if self.Projectile and self.Projectile != "" and type(self.Projectile) == "string" then
		local ent = ents.Create(self.Projectile)
		ent:SetPos(self:LocalToWorld(self.ShootDirection*self.ShootOffset))
		local ang = self:LocalToWorldAngles(self.ShootDirection:Angle())
		ang:RotateAroundAxis(ang:Right(),-90)
		ent:SetAngles(ang)
		ent.WDSO = self.WDSO or self
		ent.WDSE = self
		ent:SetDamage(self.Damage)
		ent:SetRadius(self.ExplodeRadius)
		ent:SetSpeed(self.Speed)
		ent:Spawn()
		ent:Activate()
		local ed = EffectData()
			ed:SetEntity(self)
			ed:SetOrigin(self.ShootDirection*self.ShootOffset)
		util.Effect(self.ShootEffect,ed)
	else
		local Pos = self:LocalToWorld(self.ShootDirection*self.ShootOffset)
		local Rad = 0
		if self.ExplodeHit and self.ExplodeRadius and self.ExplodeRadius > 0 then
			Rad = self.ExplodeRadius
		end
		local tr = WDS.AttackTrace(Pos,self:LocalToWorld(self.ShootDirection*10000),{self},self.Damage,Rad,self.WDSO or self,self)
		local ed = EffectData()
			ed:SetEntity(self)
			ed:SetOrigin(Pos)
			ed:SetStart(tr.HitPos)
		util.Effect(self.ShootEffect,ed)
	end
	if self.ShootSound then self:EmitSound(self.ShootSound) end
	self:SetNextFire(CurTime()+self.FireDelay)
end

function ENT:UpdateWire()
	for k,v in pairs(self.Wire_Out) do
		k = tostring(k)
		v = tonumber(v)
		if !self._Wire_Out[k] or self._Wire_Out[k] != v then
			self._Wire_Out[k] = v
			Wire_TriggerOutput(self,k,v)
		end
	end
end

function ENT:TriggerInput(name,val)
	self.Wire_In[name] = val
end

function ENT:CanFire()
	return self:GetNextFire() <= CurTime()
end
