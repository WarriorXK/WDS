AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local FireSound = Sound("weapons/rpg/rocketfire1.wav")
local ShootPos = Vector(46,0,0)

ENT.ShouldFire = false
ENT.FireDumb = false
ENT.LastShot = 0
ENT.Missle = NULL

function ENT:Initialize()
	self:SetModel("models/wds/device14.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.Inputs = Wire_CreateInputs(self,{"Fire","Dumb Fire","Enable Laser"})
	self.Outputs = Wire_CreateOutputs(self,{"Can Fire"})
	self:SetLaserEnabled(true) // Default to on.
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
	if self.LastShot+4 <= CurTime() and !ValidEntity(self.Missle) then
		if self.ShouldFire then
			self:FireShot()
		end
		Wire_TriggerOutput(self,"Can Fire",1)
	else
		Wire_TriggerOutput(self,"Can Fire",0)
	end
	self:NextThink(CurTime()+0.1)
	return true
end

function ENT:FireShot()
	self.Missle = ents.Create("wds2_projectile_lasermissile")
	self.Missle:SetAngles(self:GetAngles())
	self.Missle:SetPos(self:LocalToWorld(ShootPos))
	self.Missle.Dumb = self.FireDumb
	self.Missle.Launcher = self
	self.Missle.WDSO = self.WDSO
	self.Missle.TargetPos = self:GetTrace().HitPos
	if CPPI then self.Missle:CPPISetOwner(self.WDSO) end // Prop protection API support, prevents "You now own this prop" messages
	self.Missle:Spawn()
	self.Missle:Activate()
	
	if self.FireDumb then self.Missle = NULL end

	self:EmitSound(FireSound) //Todo : Find a better sound?

	self.LastShot = CurTime()
end

function ENT:SetLaserEnabled(bool)
	self.dt.LaserEnabled = tobool(bool)
end

function ENT:TriggerInput(name,val)
	if name == "Fire" then
		self.ShouldFire = tobool(val)
	elseif name == "Dumb Fire" then
		self.FireDumb = tobool(value)
	elseif name == "Enable Laser" then
		self:SetLaserEnabled(tobool(val))
	end
end
