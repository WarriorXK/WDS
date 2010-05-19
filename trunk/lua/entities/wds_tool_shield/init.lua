AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.NextShieldUpdate = 0
ENT.ShouldBeOnline = false
ENT.NextRegenerate = 0
ENT.AllowedObjects = {}
ENT.FilteredClasses =	{
							"env_laserdot",
							"env_sprite",
							"env_spritetrail",
							"env_rockettrail",
							"physgun_beam"
						}
ENT.LastHit = 0

ENT.RegenerateAmountOffline = 50
ENT.RegenerateAmountOnline = 20
ENT.RegenerateDelay = 1
ENT.MaxDamage = 500
ENT.MaxEnergy = 1000
ENT.MinEnergy = 50

function ENT:Initialize()
	self:SetModel("models/wds/device09.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:CreateShield()
	self.Radius = self.Shield:GetSize()
	self:KillShield()
	self.Inputs = Wire_CreateInputs(self,{"On"})
	self.Outputs = Wire_CreateOutputs(self,{"Online","Energy"})
	self.dt.Energy = 0
end

function ENT:SpawnFunction(p,t)
	if !t.Hit then return end
	local e = ents.Create("wds_tool_shield")
	e:SetPos(t.HitPos+t.HitNormal*20)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	return e
end

function ENT:CreateShield()
	self:KillShield()
	self.Shield = ents.Create("wds_tool_shielddome")
	self.Shield.Generator = self
	self.Shield:SetPos(self:GetPos())
	self.Shield:SetAngles(self:GetAngles())
	self.Shield:SetParent(self)
	self.Shield:Spawn()
	self.Shield:Activate()
end

function ENT:KillShield()
	if self.Shield then
		if self.Shield:IsValid() then
			self.Shield:Remove()
		end
		self.Shield = nil
	end
end

function ENT:OnRemove()
	self:KillShield()
end

function ENT:Think()
	local On
	if self.dt.Online then
		On = 1
		if self.NextShieldUpdate <= CurTime() then
			self:UpdateShield()
			self.NextShieldUpdate = CurTime()+0.1
		end
		if self.NextRegenerate < CurTime() and self.LastHit+2 <= CurTime() then
			self:SetEnergy(self.dt.Energy+self.RegenerateAmountOnline)
			self.NextRegenerate = CurTime()+self.RegenerateDelay
		end
		if !self.ShouldBeOnline then self:TurnOff() end
	else
		On = 0
		if self.NextRegenerate < CurTime() then
			self:SetEnergy(self.dt.Energy+self.RegenerateAmountOffline)
			self.NextRegenerate = CurTime()+self.RegenerateDelay
		end
		if self.ShouldBeOnline then self:TurnOn() end
	end
	Wire_TriggerOutput(self,"Online",On)
	self:NextThink(CurTime())
	return true
end

function ENT:UpdateShield()
	for _,v in pairs(ents.FindInSphere(self:GetPos(),self.Radius)) do
		local phys = v:GetPhysicsObject()
		local Dir = (v:GetPos()-self:GetPos()):Normalize()
		local Effect = false
		local Size = 1
		if !table.HasValue(self.AllowedObjects,v) and !v:IsWeapon() and !string.find(v:GetClass(),"predicted_viewmodel") then
			if v:GetClass() == "crossbow_bolt" then
				v:SetLocalVelocity(Dir*v:GetVelocity():Length()*1000)
				self:SetEnergy(self.dt.Energy-20)
				Effect = true
				Size = 25
			elseif v:GetClass() == "prop_combine_ball" then
				self.LastHit = CurTime()
				phys:SetVelocity(Dir*v:GetVelocity():Length())
				self:SetEnergy(self.dt.Energy-50)
				Effect = true
				Size = 50
			elseif v:GetClass() == "rpg_missile" then
				self:SetEnergy(self.dt.Energy-50)
				v:SetLocalVelocity(Dir*v:GetVelocity():Length()*1000+Vector(0,0,10000))
				v:SetAngles(Dir:Angle())
				v:SetHealth(0)
				local bul = {
					Num = 1,
					Src = v:GetPos(),
					Dir = Vector(0,0,0),
					Spread = Vector(0,0,0),
					Tracer = 0,
					Force = 1,
					Damage = 100
				}
				self:FireBullets(bul)
				Size = 50
				Effect = true
			elseif v and v:IsValid() and phys and phys:IsValid() then
				self.LastHit = CurTime()
				phys:SetVelocity(Dir*v:GetVelocity():Length()*1000+Vector(0,0,10000))
				self:SetEnergy(self.dt.Energy-math.Clamp(phys:GetMass()/5,10,self.MaxDamage))
				Effect = true
				Size = math.Clamp(phys:GetVolume()/7,1,150)
			elseif !table.HasValue(self.FilteredClasses,v:GetClass()) then
				print("\t"..tostring(v))
			end
			if Effect then
				local ed = EffectData()
					ed:SetEntity(self)
					ed:SetOrigin(v:GetPos())
					ed:SetScale(Size)
				util.Effect("wds_shield_hit",ed)
			end
			if !self.dt.Online then	break end
		end
	end
end

function ENT:SetEnergy(a)
	self.dt.Energy = math.Clamp(a,0,self.MaxEnergy)
	Wire_TriggerOutput(self,"Energy",self.dt.Energy)
	if self.dt.Energy <= 0 then self:TurnOff() end
end

function ENT:TurnOn()
	if self.dt.Energy >= self.MinEnergy then
		local ed = EffectData()
			ed:SetEntity(self)
		util.Effect("wds_shield_turnon",ed)
		self:CreateShield()
		self.dt.Online = true
		self.AllowedObjects = ents.FindInSphere(self:GetPos(),self.Radius)
	end
end

function ENT:TurnOff()
	self.AllowedObjects = {}
	local ed = EffectData()
		ed:SetEntity(self)
	util.Effect("wds_shield_turnoff",ed)
	self:KillShield()
	self.dt.Online = false
end

function ENT:TriggerInput(name,val)
	if name == "On" then
		if val == 1 then
			self.ShouldBeOnline = true
		else
			self.ShouldBeOnline = false
		end
	end
end

hook.Add("ShouldCollide","WDS.Shield.ShouldCollide",function(ent1,ent2)
	if ent1:GetClass() == "wds_tool_shielddome" then
		local Result = !table.HasValue(ent1.Generator.AllowedObjects,ent2)
		if !Result then return false end
	elseif ent2:GetClass() == "wds_tool_shielddome" then
		local Result = !table.HasValue(ent2.Generator.AllowedObjects,ent2)
		if !Result then return false end
	end
end)
