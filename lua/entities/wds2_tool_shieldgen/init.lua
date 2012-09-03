AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.DrainedThreshold = 200
ENT.MaxEnergyDrain = 15
ENT.DrainPerThink = 0
ENT.MaxRadius = 1024
ENT.MaxEnergy = 1000

ENT.EnergyDrain = ENT.MaxEnergyDrain
ENT.ShouldBeOn = false
ENT.DisableEnergy = false
ENT.Drained = false
ENT.Radius = ENT.MaxRadius
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
	self.Inputs = Wire_CreateInputs(self,{"On", "DisableEnergy", "MaxEnergyDrain"})
	self.Outputs = Wire_CreateOutputs(self,{"Enabled", "Energy"})
	if RD2Version != nil then RD_AddResource(self, "energy", 0) end
	self:SetRadius(self.MaxRadius)
	self:SetEnergy(self.MaxEnergy)
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
			if !ValidEntity(self.ShieldDome) then
				self:CreateDome()
			end
			self:SetEnergy(self:GetEnergy() - self.DrainPerThink)
		else
			self.Drained = true
		end
	else
		if ValidEntity(self.ShieldDome) then
			self.ShieldDome:Remove()
		end
	end
	local EnergyDrained = 0
	if RD2Version != nil and !self.DisableEnergy then // RD2 stuff
		local Enrg = RD_GetResourceAmount(self, "energy")
		local Drain = math.Clamp(self.MaxEnergy - self:GetEnergy(), 0, math.min(self.EnergyDrain, Enrg))
		if Enrg > Drain then
			RD_ConsumeResource(self, "energy", Drain)
			EnergyDrained = Drain
		end
	end
	self:SetEnergy(self:GetEnergy() + EnergyDrained)
	if self.Drained and self:GetEnergy() >= self.DrainedThreshold then self.Drained = false end
	self:NextThink(CurTime()+0.1)
	return true
end

function ENT:DomeTakeDamage(dmginfo)
	local Drain = dmginfo:GetDamage() * (self.Radius / self.MaxRadius)
	self:SetEnergy(self:GetEnergy() - Drain)
end

function ENT:DomePhysicsCollide(data,physobj)
	
end

function ENT:SetEnergy(val)
	self.dt.Energy = math.Clamp(val, 0, self.MaxEnergy)
	Wire_TriggerOutput(self,"Energy",self:GetEnergy())
end

function ENT:SetRadius(val)
	self.Radius = math.Clamp(val,128,self.MaxRadius)
	self.Scale = self.Radius / self.MaxRadius
end

function ENT:CreateDome()
	if ValidEntity(self.ShieldDome) then self.ShieldDome:Remove() end
	self.ShieldDome = ents.Create("wds2_misc_shielddome")
	self.ShieldDome:SetPos(self:LocalToWorld(self:OBBCenter()))
	self.ShieldDome:SetAngles(self:GetAngles())
	self.ShieldDome:SetParent(self)
	self.ShieldDome.Generator = self
	self.ShieldDome:Spawn()
	self.ShieldDome:Activate()
	self.ShieldDome.dt.Scale = self.Scale
	//constraint.Weld(self, self.ShieldDome, 0, 0, 0)
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

hook.Add("WDS2_EntityShouldTakeDamage", "WDS2_EntityShouldTakeDamage_shieldgen", function(ent, damage)
	if ValidEntity(ent) and ent:GetClass() == "wds2_misc_shielddome" then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(damage)
		ent.Generator:TakeDamage(dmginfo)
	end
end)
