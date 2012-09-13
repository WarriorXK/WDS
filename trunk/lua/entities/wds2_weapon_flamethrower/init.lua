AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local BarrelPos = Vector(50,0,0)

ENT.SecFireDelay = 4
ENT.FireDelay = 0.1
ENT.MaxHeat = 500

ENT.ShouldSecFire = false
ENT.HasOverheated = false
ENT.ShouldFire = false
ENT.NextShot = 0
ENT.Heat = 0

function ENT:Initialize()
	self:SetModel("models/wds/device17.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.Inputs = Wire_CreateInputs(self,{"Primary Fire","Secondary Fire"})
	self.Outputs = Wire_CreateOutputs(self,{"Can Fire", "Heat", "Max Heat"})
	Wire_TriggerOutput(self,"Max Heat",self.MaxHeat)
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

	if self.NextShot <= CurTime() and !self.HasOverheated then
		if self.ShouldSecFire then
			self:FireBall()
		elseif self.ShouldFire then
			self:Shoot()
		end
	end
	
	if self.Heat >= self.MaxHeat then
		self.HasOverheated = true
	end
	
	if self.HasOverheated then
		if self.Heat <= (self.MaxHeat / 10) * 8 then
			self.HasOverheated = false
		end
	end
	
	if self.NextShot <= CurTime() and self.Heat >= 1 then
		self.Heat = self.Heat - 1
		self.NextShot = CurTime() + (self.FireDelay * 2)
	end
	
	local CF = 1
	if self.HasOverheated then CF = 0 end
	
	Wire_TriggerOutput(self,"Can Fire", CF)
	Wire_TriggerOutput(self,"Heat",self.Heat)
	self:NextThink(CurTime())
	return true
end

function ENT:FireBall()
	
	local ent = ents.Create("wds2_projectile_fireball")
	ent:SetPos(self:LocalToWorld(BarrelPos))
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:Activate()
	ent.Cannon = self
	ent.WDSO = self.WDSO

	self.Heat = self.Heat + 200
	
	self.NextShot = CurTime() + self.SecFireDelay
	
end

function ENT:Shoot()

	local ent = ents.Create("wds2_projectile_flame")
	ent:SetPos(self:LocalToWorld(BarrelPos))
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:Activate()
	ent.Cannon = self
	ent.WDSO = self.WDSO

	self.Heat = self.Heat + 1
	
	self.NextShot = CurTime() + self.FireDelay
	
end

function ENT:TriggerInput(name,val)
	if name == "Primary Fire" then
		self.ShouldFire = tobool(val)
	elseif name == "Secondary Fire" then
		self.ShouldSecFire = tobool(val)
	end
end

function WDS2_Flamethrower_ScaleDamage(ent, hitgrp, dmginfo)
	local Inflictor = dmginfo:GetInflictor()
	if IsValid(Inflictor) and (Inflictor:GetClass() == "wds2_projectile_flame" or Inflictor:GetClass() == "wds2_projectile_fireball") then // Prevents damage from the projectile as physical object
		if dmginfo:GetDamageType() == DMG_CRUSH then
			dmginfo:ScaleDamage(0)
		end
		dmginfo:SetDamageForce(WDS2.ZeroVector)
	end
end
hook.Add("ScalePlayerDamage","WDS2_Flamethrower_ScalePlayerDamage",WDS2_Flamethrower_ScaleDamage)
hook.Add("ScaleNPCDamage","WDS2_Flamethrower_ScaleNPCDamage",WDS2_Flamethrower_ScaleDamage)
