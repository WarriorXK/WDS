AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT._Wire_Out = {}
ENT.Wire_Out = {}
ENT.Wire_In = {}

function ENT:Initialize()
	self:SetModel("models/wds/hpm.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.Outputs = Wire_CreateOutputs(self,{"MaxHealth","Health"})
end

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create("wds_tool_healthmeter")
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end

function ENT:Think()
	local tr = WDS.TraceLine(self:GetPos(),self:GetPos()+(self:GetForward()*10000),{self})
	self.Wire_Out["MaxHealth"] = WDS.GetMaxHealth(tr.Entity)
	self.Wire_Out["Health"] = WDS.GetHealth(tr.Entity)
	self:UpdateWire()
	self:NextThink(CurTime())
	return true
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
