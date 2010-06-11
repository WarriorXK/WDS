AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShouldBeOnline = false

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
	if self.ShouldBeOnline then
		if self:IsOnline() then
			self:DrainEnergy(math.Round(self:GetSize()/100))
		else
			self:TurnOn()
		end
	elseif self:IsOnline() then
		self:TurnOff()
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
	if ValidEntity(self.dt.ShieldEntity) then self.dt.ShieldEntity:Remove()	end
	self.dt.ShieldEntity = nil
end

function ENT:DrainEnergy(amount)
	
end

function ENT:TriggerInput(name,val)
	if name == "On" then
		if val == 1 then
			self.ShouldBeOnline = true
		else
			self.ShouldBeOnline = false
		end
	end
end
