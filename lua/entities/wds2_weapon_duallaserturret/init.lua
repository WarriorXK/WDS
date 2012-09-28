AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local FireSound = Sound("wds2/weapons/duallaserturret/fire.wav")

local RightBarrel = Vector(42,-8.3,0)
local LeftBarrel = Vector(42,8.3,0)

ENT.ShouldFire1 = false
ENT.ShouldFire2 = false
ENT.NextShot1 = 0
ENT.NextShot2 = 0

function ENT:Initialize()
	self:SetModel("models/wds/device13.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.Inputs = Wire_CreateInputs(self,{"Fire1","Fire2"})
	self.Outputs = Wire_CreateOutputs(self,{"Can Fire1","Can Fire2"})
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
	if self.NextShot1 <= CurTime() then
		if self.ShouldFire1 then
			self:FireShot(true)
		end
		Wire_TriggerOutput(self,"Can Fire1",1)
	else
		Wire_TriggerOutput(self,"Can Fire1",0)
	end
	if self.NextShot2 <= CurTime() then
		if self.ShouldFire2 then
			self:FireShot(false)
		end
		Wire_TriggerOutput(self,"Can Fire2",1)
	else
		Wire_TriggerOutput(self,"Can Fire2",0)
	end
	self:NextThink(CurTime())
	return true
end

function ENT:FireShot(IsLeftBarrel)
	local Pos
	if IsLeftBarrel then
		Pos = LeftBarrel
		self.NextShot1 = CurTime()+0.40
		self.NextShot2 = CurTime()+0.20
	else
		Pos = RightBarrel
		self.NextShot1 = CurTime()+0.20
		self.NextShot2 = CurTime()+0.40
	end

	local ed = EffectData()
		ed:SetEntity(self)
		ed:SetStart(Pos)
	util.Effect("wds2_duallaser_flare",ed)
	
	local ent = ents.Create("wds2_projectile_duallaser")
	ent:SetPos(self:LocalToWorld(Pos))
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:Activate()
	ent.Cannon = self
	ent.WDSO = self.WDSO

	self:EmitSound( FireSound )

end

function ENT:TriggerInput(name,val)
	if name == "Fire1" then
		self.ShouldFire1 = tobool(val)
	elseif name == "Fire2" then
		self.ShouldFire2 = tobool(val)
	end
end

function WDS2_DualLaserTurret_EntityTakeDamage(Target, Inflictor, Attacker, Damage, DmgInfo)
	if IsValid(Inflictor) and Inflictor:GetClass() == "wds2_projectile_duallaser" and DmgInfo:GetDamageType() == DMG_CRUSH then // Prevents damage from the projectile as physical object
		if DmgInfo:GetDamageType() == DMG_CRUSH then
			DmgInfo:ScaleDamage(0)
		end
		DmgInfo:SetDamageForce(WDS2.ZeroVector)
	end
end
hook.Add("EntityTakeDamage","WDS2_DualLaserTurret_EntityTakeDamage",WDS2_DualLaserTurret_EntityTakeDamage)
