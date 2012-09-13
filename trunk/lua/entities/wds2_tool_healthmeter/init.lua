AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

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
	local e = ents.Create(self.ClassName)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	e:SetPos(t.HitPos+t.HitNormal*-e:OBBMins().z)
	return e
end

function ENT:Think()
	local tr = self:GetTrace()
	local Health
	local MaxHealth
	if IsValid(tr.Entity) then
		if tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
			Health = tr.Entity:Health()
			MaxHealth = tr.Entity:GetMaxHealth()
		else
			Health = WDS2.GetHealth(tr.Entity)
			MaxHealth = WDS2.GetMaxHealth(tr.Entity)
		end
	else
		Health = 0
		MaxHealth = 0
	end
	
	Health = math.Round(Health*100)/100
	MaxHealth = math.Round(MaxHealth*100)/100
	
	Wire_TriggerOutput(self,"Health",Health)
	Wire_TriggerOutput(self,"MaxHealth",MaxHealth)
	
	self.dt.Health = Health
	
	self:NextThink(CurTime())
	return true
end
