AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.DisarmedSound	= Sound("WDS/weapons/apmine/deactivate.wav")
ENT.ExplodeEffect	= "wds_projectile_mine_explosion"
ENT.ExplodeSound	= Sound("WDS/weapons/apmine/explode.wav")
ENT.TrailEffect		= ""
ENT.ArmedSound		= Sound("WDS/weapons/apmine/activate.wav")
ENT.Velocity		= 0
ENT.DieSound		= Sound("WDS/weapons/apmine/die.wav")
ENT.Gravity			= true
ENT.ArmTime			= 3
ENT.Radius			= 150
ENT.Damage			= 250
ENT.Model			= "models/wds/ap_mine.mdl"
ENT.Drag			= true
ENT.Uses			= 0

function ENT:SecondInit()
	WDS.InitEntity(self,1)
	self.dt.NextExplode = CurTime()+self.ArmTime
	self.dt.Online = true
	self:SetUseType(SIMPLE_USE)
	self:SetMoveType(MOVETYPE_NONE)
end

function ENT:PhysicsCollide(data,physobj) end

function ENT:Think()
	if !self.dt.Online or self.dt.NextExplode > CurTime() then return end
	for _,v in pairs(ents.FindInSphere(self:GetPos(),100)) do
		if v and v:IsValid() and !table.HasValue(WDS.FadingEntities,v) then
			local Distance = v:NearestPoint(self:GetPos()):Distance(self:GetPos())
			local Velocity = v:GetVelocity():Length()
			if Velocity >= 55 or Velocity <= -55 then
				self.dt.Warning = true
				if Distance <= 70 then
					self:Explode()
				end
			end
		end
	end
end

function ENT:Use(ent)
	self.dt.Online = !self.dt.Online or false
	if !self.dt.Online then
		self:EmitSound(self.DisarmedSound)
	else
		self:EmitSound(self.ArmedSound)
	end
end

function ENT:Explode()
	self.Uses = self.Uses+1
	self.dt.Warning = false
	self.dt.NextExplode = CurTime()+10
	WDS.Explosion(self:GetPos()+(self:GetUp()*5),self.Radius,self.Damage,{self},self.WDSO,self)
	local ed = EffectData()
		ed:SetOrigin(self:GetPos())
	util.Effect(self.ExplodeEffect,ed)
	self:EmitSound(self.ExplodeSound,100,100)
	if self.Uses >= 30 then
		self:EmitSound(self.DieSound)
		self:Remove()
	end
end
