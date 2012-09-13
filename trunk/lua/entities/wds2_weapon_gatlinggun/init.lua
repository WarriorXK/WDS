AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ShootPosses =	{
						Vector(29,-1.2,6.4),
						Vector(29,2.7,4.2),
						Vector(29,4.8,0.3),
						Vector(29,2.7,-3.8),
						Vector(29,-1,-5.5),
						Vector(29,-5.3,-3.7),
						Vector(29,-7,0.2),
						Vector(29,-5.2,4.1),
					}
ENT.CurrentBarrel = 1
ENT.LastHeatDrain = 0
ENT.ShouldFire = false
ENT.LastShot = 0
ENT.RPM = 60 // 60 RPM = 8 shots per second.

ENT.MaxHeat = 10

function ENT:Initialize()
	self:SetModel("models/wds/device06.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self.dt.Overheated = false
	
	self.Inputs = Wire_CreateInputs(self,{"Fire","RPM"})
	self.Outputs = Wire_CreateOutputs(self,{"Can Fire", "Heat", "Overheated", "CurRPM"})
	Wire_TriggerOutput(self,"CurRPM",self.RPM)
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

function ENT:CanFire()
	return self.LastShot+(60 / (self.RPM * #self.ShootPosses)) <= CurTime() and self.dt.Heat < self.MaxHeat and !self.dt.Overheated
end

function ENT:Think()

	local BarrelCount = table.Count(self.ShootPosses)
	
	if self:CanFire() then
	
		if self.ShouldFire then
			self.dt.Heat = self.dt.Heat + 0.1
			self.LastShot = CurTime()
			self:FireShot()
		end
		
		Wire_TriggerOutput(self,"Can Fire",1)
		
	else
		Wire_TriggerOutput(self,"Can Fire",0)
	end
	
	if self.LastHeatDrain+(1 / #self.ShootPosses) <= CurTime() then
	
		self.dt.Heat = math.Clamp(self.dt.Heat - 0.1,0,self.MaxHeat)
		self.LastHeatDrain = CurTime()
		
	end
	
	if self.dt.Heat >= self.MaxHeat then
	
		self.dt.Overheated = true
		
		local ed = EffectData()
			ed:SetEntity(self)
		util.Effect("wds2_gatlinggun_overheat", ed)
		
	elseif self.dt.Heat <= 0 then
		self.dt.Overheated = false
	end
	
	//Wire_TriggerOutput(self,"Overheated", tonumber(self.dt.Overheated))
	Wire_TriggerOutput(self, "Heat", math.ceil(self.dt.Heat * 10) / 10)
	
	self:NextThink(CurTime())
	return true
	
end

function ENT:FireShot()

	local pos = self:LocalToWorld(self.ShootPosses[self.CurrentBarrel])
	local tr = WDS2.TraceLine(pos, pos + (self:GetForward() * 50000), {self})
	
	if IsValid(tr.Entity) and !tr.Entity:IsWorld() then
	
		WDS2.DealDirectDamage(tr.Entity,17,"AP")
		local Dam = DamageInfo()
			Dam:SetDamage(17)
			Dam:SetInflictor(self)
			Dam:SetAttacker(self.WDSO)
			Dam:SetDamageType(DMG_DISSOLVE)
			Dam:SetDamageForce(self:GetPos()-tr.Entity:GetPos())
			Dam:SetDamagePosition(tr.HitPos)
		tr.Entity:TakeDamageInfo(Dam)
		
		local Phys = tr.Entity:GetPhysicsObject()
		if Phys:IsValid() then
			Phys:ApplyForceOffset((tr.Entity:GetPos()-self:GetPos())*10,tr.HitPos)
		end
		
	end

	self:EmitSound("wds2/weapons/gatlinggun/fire.wav")

	local ed = EffectData()
		ed:SetStart(pos)
		ed:SetOrigin(tr.HitPos)
	util.Effect("wds2_gatlinggun_laser",ed,true,true)
	
	self.CurrentBarrel = self.CurrentBarrel + 1
	if self.CurrentBarrel > table.Count(self.ShootPosses) then self.CurrentBarrel = 1 end
	
end

function ENT:TriggerInput(name,val)
	if name == "Fire" then
		self.ShouldFire = tobool(val)
	elseif name == "RPM" then
		local In = tonumber(val)
		if In <= 0 then	In = 60 end
		self.RPM = math.ceil(math.Clamp(In,1,300))
		Wire_TriggerOutput(self, "CurRPM", self.RPM)
	end
end
