AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local PowerOnSound = Sound("wds/weapons/shield/poweron.wav")
local HumSound = Sound("wds/weapons/shield/generator_hum.wav")

ENT.MaxEnergyDrain = 15
ENT.DisableEnergy = false
ENT.EnergyDrain = ENT.MaxEnergyDrain
ENT.ShouldBeOn = false
ENT.IsOnline = false
ENT.Drained = false
ENT.Scale = 1

function ENT:Initialize()

	self:SetModel("models/XQM/Rails/trackball_1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self.Inputs = Wire_CreateInputs(self,{"On", "DisableEnergy", "MaxEnergyDrain", "Radius"})
	self.Outputs = Wire_CreateOutputs(self,{"Online", "Energy"})
	
	if RD2Version != nil then RD_AddResource(self, "energy", 0) end
	
	self:SetRadius(self.MaxRadius)
	self:SetEnergy(self.MaxEnergy)
	
	self.HumSound = CreateSound(self, HumSound)
	self.HumSound:ChangeVolume(10, 0)
	
end

function ENT:SpawnFunction(p,t)

	if !t.Hit then return end
	
	local e = ents.Create(self.ClassName)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	e:SetPos(t.HitPos+t.HitNormal*-e:OBBMins().z)
	
	return e
end

function ENT:Think()

	if self.ShouldBeOn and !self.Drained then
		if self:GetEnergy() >= math.max(self.DrainPerThink, 1) then
			
			if !self.IsOnline then
			
				self:EmitSound(PowerOnSound)
				self.HumSound:Play()
				
			end
			
			self.IsOnline = true
			
			if !IsValid(self.dt.ShieldDome) then
				self:CreateDome()
			end
			
			self:SetEnergy(self:GetEnergy() - self.DrainPerThink)
			
		else
		
			self.HumSound:Stop()
			self.IsOnline = false
			self.Drained = true
			
		end
		
	else
	
		self.HumSound:Stop()
		self.IsOnline = false
		if IsValid(self.dt.ShieldDome) then self.dt.ShieldDome:Remove() end
		
	end
	
	local EnergyDrained = 0
	if RD2Version != nil and !self.DisableEnergy then // RD2 stuff
		local Enrg = RD_GetResourceAmount(self, "energy")
		local Drain = math.Clamp(self.MaxEnergy - self:GetEnergy(), 0, math.min(self.EnergyDrain, Enrg))
		if Enrg >= Drain then
			RD_ConsumeResource(self, "energy", Drain)
			EnergyDrained = Drain
		end
	end
	
	Wire_TriggerOutput(self, "Online", self.IsOnline and 1 or 0)
	
	self:SetEnergy(self:GetEnergy() + EnergyDrained)
	if self.Drained and self:GetEnergy() >= self.DrainedThreshold then self.Drained = false end
	
	self:NextThink(CurTime())
	return true
end

function ENT:DomeTakeDamage(dmginfo)

	local Drain = dmginfo:GetDamage() * (self:GetRadius() / self.MaxRadius)
	self:SetEnergy(self:GetEnergy() - Drain)
	
	local ed = EffectData()
		ed:SetMagnitude(1)
		ed:SetOrigin(dmginfo:GetDamagePosition())
		ed:SetStart(dmginfo:GetDamagePosition()-self:GetPos())
		ed:SetEntity(self)
	util.Effect("wds2_shieldhit", ed)
	
end

function ENT:DomePhysicsCollide(data,physobj)
	
end

function ENT:SetEnergy(val)
	self.dt.Energy = math.Clamp(val, 0, self.MaxEnergy)
	Wire_TriggerOutput(self,"Energy",self:GetEnergy())
end

function ENT:SetRadius(val)
	self.dt.Radius = math.Clamp(val,128,self.MaxRadius)
	self.Scale = self.dt.Radius / self.MaxRadius
end

function ENT:CreateDome()

	if IsValid(self.dt.ShieldDome) then self.dt.ShieldDome:Remove() end
	
	self.dt.ShieldDome = ents.Create("wds2_misc_shielddome")
	self.dt.ShieldDome:SetPos(self:LocalToWorld(self:OBBCenter()))
	self.dt.ShieldDome:SetAngles(self:GetAngles())
	self.dt.ShieldDome:SetParent(self)
	self.dt.ShieldDome.dt.Generator = self
	self.dt.ShieldDome:Spawn()
	self.dt.ShieldDome:Activate()
	self.dt.ShieldDome.dt.Scale = self.Scale
	
end

function ENT:TriggerInput(name,val)
	if name == "On" then
		self.ShouldBeOn = tobool(val)
	elseif name == "DisableEnergy" then
		self.DisableEnergy = tobool(val)
	elseif name == "MaxEnergyDrain" then
		self.EnergyDrain = math.Clamp(0, self.MaxEnergyDrain)
	elseif name == "Radius" then
		self:SetRadius(tonumber(val))
	end
end
