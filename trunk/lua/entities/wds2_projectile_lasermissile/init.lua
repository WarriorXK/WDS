AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.TargetPos = Vector(0,0,0)

function ENT:Initialize()
	self:SetModel("models/wds/device16.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableDrag(false)
		phys:EnableGravity(false)
	end
	self:StartMotionController()
	local ed = EffectData()
		ed:SetEntity(self)
	util.Effect("wds2_laserguidedmissle_trail",ed,true,true)
end

function ENT:Touch(ent)
	if ValidEntity(ent) and ent:GetClass() == "shield" then // Stargate shield Support
		self:Explode()
	end
end

function ENT:PhysicsCollide(data,physobj)
	self:Explode(data.HitPos)
	return
end

function ENT:Explode(pos)
	pos = pos or self:GetPos()
	WDS2.CreateExplosion(pos, 150, 150, self)
	util.BlastDamage(self, self.WDSO, pos, 150, 150)
	self:Remove()
end

function ENT:PhysicsSimulate(phys,deltatime)
	phys:Wake()
	self.TargetPos = (ValidEntity(self.Launcher) and self.Launcher:GetLaserEnabled()) and self.Launcher:GetTrace().HitPos or self.TargetPos
	local pr = {}
	pr.secondstoarrive	= 0.5
	pr.pos				= self:GetPos()+self:GetForward()*80
	pr.maxangular		= 5000
	pr.maxangulardamp	= 10000
	pr.maxspeed			= 1000000
	pr.maxspeeddamp		= 10000
	pr.dampfactor		= 0.1
	pr.teleportdistance	= 0
	pr.deltatime		= deltatime
	pr.angle			= (self.TargetPos-self:GetPos()):Angle()
	phys:ComputeShadowControl(pr)
end
