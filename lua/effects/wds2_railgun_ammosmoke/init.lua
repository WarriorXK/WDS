
local Mat = "wds/effects/blankparticle"
local Gravity = Vector(0,0,70)

EFFECT.NextSmoke = 0

function EFFECT:Init(d)
	self.TargetEntity = d:GetEntity()
	self.Offset = d:GetOrigin() or WDS2.ZeroVector
	self.Gravity = d:GetStart() or Gravity
	self.EffectScale = d:GetScale() or 1
	self.ParticleDelay = d:GetMagnitude() or 0.03
	self.LifeTime = d:GetRadius()
	self.EndTime = CurTime()+(self.LifeTime or 4)
	if ValidEntity(self.TargetEntity) then
		self.Emitter = ParticleEmitter(self.TargetEntity:GetPos())
	end
end

function EFFECT:Think()
	local Valid = ValidEntity(self.TargetEntity)
	if Valid then
	
		if self.NextSmoke <= CurTime() then
			local Smoke = self.Emitter:Add("particles/smokey",self.TargetEntity:LocalToWorld(self.Offset+Vector(math.random(-4,4),math.random(-4,4),math.random(-4,4))))
			Smoke:SetVelocity(self.TargetEntity:GetVelocity())
			Smoke:SetLifeTime(1)
			Smoke:SetDieTime(math.random(3,5))
			Smoke:SetStartAlpha(100)
			Smoke:SetEndAlpha(0)
			Smoke:SetStartSize(5*self.EffectScale)
			Smoke:SetEndSize(10*self.EffectScale)
			Smoke:SetRoll(math.Rand(-360,360))
			Smoke:SetRollDelta(math.Rand(-1,1))
			Smoke:SetAirResistance(300)
			Smoke:SetGravity(self.Gravity)
			//Smoke:SetCollide(true)

			self.NextSmoke = CurTime()+self.ParticleDelay
		end
		
	elseif self.Emitter then
		self.Emitter:Finish()
	end
	return (Valid and self.EndTime >= CurTime())
end

function EFFECT:Render() 
end
