AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.MaxPower = 1000

function ENT:Initialize()
	self:SetModel("models/wds/device08.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.dt.CorePower = 100
	self.dt.NextCoreCharge = 0
	self.Outputs = Wire_CreateOutputs(self,{"Core Power"})
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

function ENT:GetAllCoreEntities()
	local Out = {}
	for _,v in pairs(constraint.FindConstraints( self, "Weld" )) do
		table.insert(Out, v.Entity[1].Entity == self and v.Entity[2].Entity or v.Entity[1].Entity)
	end
	return Out
end

function ENT:HasEntity(ent)
	return table.HasValue(self:GetAllCoreEntities(), ent)
end

function ENT:Think()
	if self.dt.NextCoreCharge < CurTime() then
		self.dt.CorePower = math.min(self.dt.CorePower + 1, self.MaxPower)
	end
	
	Wire_TriggerOutput(self, "Core Power", self.dt.CorePower)
	
	self:NextThink(CurTime())
	return true
end

function ENT:TakeDirectCoreDamage(damage)
	self.dt.CorePower = self.dt.CorePower - damage
	
	self.dt.NextCoreCharge = CurTime() + 2
	
	if self.dt.CorePower <= 0 then
		self:Death()
		return
	end
end

function ENT:Death()
	// Add an effect to this
	for _,v in pairs(self:GetAllCoreEntities()) do
		v:Remove()
	end
	self:Remove()
end

function ENT:TakeCoreDamage(ent, damage, typ)

	local AllEnts = self:GetAllCoreEntities()
	local DamagePerEnt = damage/#AllEnts
	
	WDS2.Debug.Print("WDS2 Core : " .. DamagePerEnt .. " per ent")
	
	for _,v in pairs(AllEnts) do
		if ValidEntity(v) then
			if WDS2.CanDamageEntity(v) then
			
				local Dmg = (DamagePerEnt * WDS2.CalculateDamageMul(typ, ent))
				v.WDS2.Health = v.WDS2.Health - Dmg
				
				WDS2.Debug.Print(tostring(v) .. " damage : " .. Dmg)
				
				WDS2.CheckProp(v)
				
			end
		end
	end
	
end

hook.Add("WDS2_EntityShouldTakeDamage", "WDS2_EntityShouldTakeDamage_wdscore", function(ent, damage, typ)

	if ValidEntity(ent) then

		for _,v in pairs(ents.FindByClass("wds2_tool_core")) do

			if ent == v then v:TakeDirectCoreDamage(damage, typ) return false end
		
			if v:HasEntity(ent) then

				v:TakeCoreDamage(ent, damage, typ)
				return false
				
			end
			
		end
		
	end
end)
