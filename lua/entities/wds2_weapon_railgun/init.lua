AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local BarrelExit = Vector(84,0,0)
local FlareExit = Vector(70,0,0)

local AmmoExitPos = Vector(-68.3390,0,18.3)
local AmmoPos = Vector(-68.3390,0,13.8042)
local AmmoAng = Angle(0,90,180)

local ExplosionSound = Sound("wds2/weapons/railgun/explosion.wav")
local ShootSound = Sound("wds2/weapons/railgun/fire.wav")
local AmmoSound = Sound("wds2/weapons/railgun/ammo.wav")

ENT.MaxPenetrations = 5

ENT.PenetrationShot = false
ENT.ShouldFire = false
ENT.HasCharge = false
ENT.LastShot = 0

function ENT:Initialize()

	self:SetModel("models/wds/device01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
	self.Inputs = Wire_CreateInputs(self, {"Fire", "Penetrate"})
	self.Outputs = Wire_CreateOutputs(self, {"Can Fire","Charge"})
	
end

function ENT:SpawnFunction(p,t)

	if !t.Hit then return end
	
	local e = ents.Create(self.ClassName)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	e:SetPos(t.HitPos + t.HitNormal * -e:OBBMins().z)
	
	return e
	
end

function ENT:Think()

	if self.LastShot + 5 <= CurTime() and IsValid(self.AmmoCapsule) and self.AmmoCapsule.HasCharge then
	
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

function ENT:Touch(ent)
	self:AttemptAmmoConnect(ent)
end

function ENT:AttemptAmmoConnect(ent)

	if IsValid(ent) and !IsValid(self.AmmoCapsule) and ent:GetClass() == "wds2_ammo_railgun" and ent.HasCharge then
	
		self.AmmoCapsule = ent
		ent:SetAngles(self:LocalToWorldAngles(AmmoAng))
		ent:SetPos(self:LocalToWorld(AmmoPos))
		ent:SetParent(self)
		constraint.Weld(self,ent,0,0,0)
		ent:EmitSound(AmmoSound)
		
	end
	
end

function ENT:FireShot()

	local Pos = self:LocalToWorld(BarrelExit)

	local tr = WDS2.TraceLine(self:GetPos(),self:GetPos()+(self:GetForward()*50000),{self})

	if self.PenetrationShot then
		
		if IsValid(tr.Entity) then
			WDS2.DealDirectDamage(tr.Entity, 500, "AT")
			
			local valid = true
			local Penetrations = 1
			while (valid) do
			
				tr = WDS2.TraceLine(tr.HitPos, tr.HitPos + (self:GetForward() * 50000), {tr.Entity})
				WDS2.DealDirectDamage(tr.Entity, 500 - (100 * Penetrations), "AT")
				
				Penetrations = Penetrations + 1
				
				if tr.HitWorld or Penetrations >= self.MaxPenetrations then valid = false end
			end
			
		end
		
	else
	
		if IsValid(tr.Entity) then
		
			WDS2.DealDirectDamage( tr.Entity, 500, "AT" )
			
		end
		
		WDS2.CreateExplosion(tr.HitPos, 70, 300, self)

		local ed = EffectData()
			ed:SetOrigin(tr.HitPos)
			ed:SetNormal(tr.HitNormal)
		util.Effect("wds2_railgun_explosion",ed,true,true)
		
		local DmgInfo = DamageInfo()
		DmgInfo:SetAttacker(self.WDSO)
		DmgInfo:SetInflictor(self)
		DmgInfo:SetDamageType(DMG_DISSOLVE)

		for i=0,3,0.5 do
			timer.Simple(i, function()
				for _,v in pairs(ents.FindInSphere(tr.HitPos, 150)) do
					if v:IsPlayer() or v:IsNPC() then
						DmgInfo:SetDamage(math.Rand(20,50))
						v:TakeDamageInfo(DmgInfo)
					end
				end
			end)
		end
		
		timer.Simple(2.7, function()
			for _,v in pairs(ents.FindInSphere(tr.HitPos, 300)) do
				if v:IsPlayer() or v:IsNPC() then
					DmgInfo:SetDamage(math.Rand(300,400))
					v:TakeDamageInfo(DmgInfo)
				end
			end
		end)
		
		sound.Play(ExplosionSound, tr.HitPos)
		
	end
	
	self:GetPhysicsObject():ApplyForceCenter(self:GetForward()*-50000)
	
	local ed = EffectData()
		ed:SetEntity(self)
		ed:SetStart(FlareExit)
	util.Effect("wds2_railgun_flare",ed,true,true)
	
	local ed = EffectData()
		ed:SetStart(Pos)
		ed:SetOrigin(tr.HitPos)
	util.Effect("wds2_railgun_trace",ed,true,true)
	
	local ed = EffectData()
		ed:SetEntity(self)
		ed:SetOrigin(Vector(-67.8657,0,11.9236)) // Effect location local to the entity
		ed:SetRadius(3) // How long the effect lasts
		ed:SetMagnitude(0.3) // Particle spawn delay
		ed:SetScale(0.5)
		ed:SetStart(Vector(0,0,70)) // Gravity on the smoke
	util.Effect("wds2_railgun_ammosmoke",ed,true,true)
	
	local ed = EffectData()
		ed:SetEntity(self.AmmoCapsule)
		ed:SetOrigin(Vector(0,0,6)) // Effect location local to the entity
		ed:SetRadius(4) // How long the effect lasts
		ed:SetMagnitude(0.03) // Particle spawn delay
		ed:SetScale(1)
		ed:SetStart(Vector(0,0,70)) // Gravity on the smoke
	util.Effect("wds2_railgun_ammosmoke",ed,true,true)
	
	self:EmitSound(ShootSound)
	
	self.AmmoCapsule.HasCharge = false
	self.AmmoCapsule:SetParent()
	constraint.RemoveAll(self.AmmoCapsule)
	self.AmmoCapsule:SetPos(self:LocalToWorld(AmmoExitPos))
	self.AmmoCapsule:Eject(self)
	self.AmmoCapsule = nil
	
	self.LastShot = CurTime()
	
end

function ENT:TriggerInput(name,val)

	if name == "Fire" then
	
		self.ShouldFire = tobool(val)
		
	elseif name == "Penetrate" then
	
		self.PenetrationShot = tobool(val)
		
	end
	
end
