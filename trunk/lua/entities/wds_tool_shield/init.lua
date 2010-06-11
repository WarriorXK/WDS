AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShouldBeOnline = false
ENT.NextConversion = 0

ENT.MaxStrength = 1000
ENT.MaxDamage = 50

function ENT:Initialize()
	self:SetModel("models/wds/device09.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.Inputs = Wire_CreateInputs(self,{"On"})
	self.Outputs = Wire_CreateOutputs(self,{"Online","Energy"})
end

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create("wds_tool_shield")
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end

function ENT:Think()
	local CAmount
	if self.ShouldBeOnline then
		CAmount = math.Round(self.MaxStrength/100)
		if self:IsOnline() then
			self:DrainEnergy(math.Round(self:GetSize()/100))
		elseif self:GetStrength() >= self.MaxStrength/10 then
			self:TurnOn()
		end
	else
		CAmount = math.Round(self.MaxStrength/50)
		if self:IsOnline() then
			self:TurnOff()
		end
	end
	if self.NextConversion <= CurTime() and self:GetStrength() < self.MaxStrength and self:HasEnergy(CAmount*2) then
		self:SetStrength(self:GetStrength()+CAmount)
		self:DrainEnergy(CAmount*2)
		self.NextConversion = CurTime()+1
	end
end

function ENT:TurnOn()
	self.dt.ShieldEntity = ents.Create("wds_tool_shielddome")
	self.dt.ShieldEntity:SetPos(self:GetPos())
	self.dt.ShieldEntity:SetAngles(self:GetAngles())
	self.dt.ShieldEntity:SetParent(self)
	self.dt.ShieldEntity:Spawn()
	self.dt.ShieldEntity:Activate()
	constraint.Weld(self,self.dt.ShieldEntity,0,0,0,false)
end

function ENT:TurnOff()
	if ValidEntity(self:GetShieldEntity()) then self:GetShieldEntity():Remove()	end
	self.dt.ShieldEntity = nil
end

function ENT:TakeShieldDamage(Dam,Pos)
	self:SetStrength(self:GetStrength()-Dam)
	if Pos then
		local ed = EffectData()
			ed:SetEntity(self)
			ed:SetOrigin(Pos)
			ed:SetNormal((self:GetPos()-Pos):Normalize())
			ed:SetScale(1*(math.Clamp(Dam/20,1,5)))
		util.Effect("wds_shield_hit",ed)
	end
end

function ENT:SetStrength(amount)
	self.dt.Strength = math.Clamp(amount,0,self.MaxStrength)
	if self:GetStrength() <= 0 then self:TurnOff() end
end

function ENT:DrainEnergy(amount)
	
end

function ENT:HasEnergy(amount)
	return true
end

function ENT:TriggerInput(name,val)
	if name == "On" then
		self.ShouldBeOnline = tobool(val)
	end
end
