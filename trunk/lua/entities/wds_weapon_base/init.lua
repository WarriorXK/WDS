AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

// Edit these variables on your own ent.
ENT.ShootDirection	= Vector(0,0,1)
ENT.ExplodeRadius	= 10
ENT.TraceEffect		= "wds_weapon_base_trace"
ENT.ShootOffset		= 10
ENT.ShootSound		= ""
ENT.FireDelay		= 1
ENT.Damage			= 40
ENT.Model			= "models/props_c17/canister01a.mdl"
ENT.Class			= "wds_weapon_base"

ENT._Wire_Out = {}
ENT.Wire_Out = {}
ENT.Wire_In = {}

ENT.NextFire = 0

function ENT:Initialize()
	self:SetModel(self.Model or"models/props_c17/canister01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.Inputs = Wire_CreateInputs(self,{"On"})
	self.Outputs = Wire_CreateOutputs(self,{"Can Fire"})
end

AccessorFunc(ENT,"NextFire","NextFire",FORCE_NUMBER)

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create(self.Class or "wds_weapon_base")
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end

function ENT:Think() // Don't overwrite think (Overwrite FireShot() for custom shots).
	if tobool(self.Wire_In["On"]) and self:CanFire() then
		self:FireShot()
	end
	self.Wire_Out["Can Fire"] = tonumber(self:CanFire())
	self:UpdateWire()
	self:NextThink(CurTime())
	return true
end

function ENT:FireShot() // Overwrite this for missile launchers or things that have different shooting functions.
	local Pos = self:LocalToWorld(self.ShootDirection*self.ShootOffset)
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
