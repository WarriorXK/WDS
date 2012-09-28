AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local FireSound = Sound("wds2/weapons/smalltankcannon/fire.wav")

local BarrelExit = Vector(52,0,0)

ENT.ShouldFire = false
ENT.LastShot = 0
ENT.ShellMode = 1

function ENT:Initialize()
	self:SetModel("models/wds/device12.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self.Inputs = Wire_CreateInputs(self,{"Fire","Mode"})
	self.Outputs = Wire_CreateOutputs(self,{"Can Fire"})
end

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create(self.ClassName)
	e:SetPos(t.HitPos)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	e:SetPos(t.HitPos+t.HitNormal*-e:OBBMins().z)
	return e
end

function ENT:Think()
	if self.LastShot+1.5 <= CurTime() then
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
	local Pos = self:LocalToWorld(BarrelExit)

	local ent = ents.Create("wds2_projectile_smalltankcannon")
	ent:SetAngles(self:GetAngles())
	ent:SetPos(Pos)
	ent.Cannon = self
	ent.WDSO = self.WDSO
	ent.DMGType = self.ShellMode == 1 and "AT" or "AP"
	if CPPI then ent:CPPISetOwner(self.WDSO) end // Prop protection API support, prevents "You now own this prop" messages
	ent:Spawn()
	ent:Activate()
	
	self:GetPhysicsObject():ApplyForceCenter(self:GetForward()*-5000)
	
	self:EmitSound( FireSound )

	local ed = EffectData()
		ed:SetStart(Pos)
		ed:SetNormal(self:GetRight())
	util.Effect("wds2_smalltankcannon_flare",ed,true,true)

	self.LastShot = CurTime()
end

function ENT:TriggerInput(name,val)
	if name == "Fire" then
		self.ShouldFire = tobool(val)
	elseif name == "Mode" then
		self.ShellMode = math.Clamp(math.floor(val),1,2)
	end
end
