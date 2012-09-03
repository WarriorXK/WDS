
local Mat = "wds/effects/blankparticle"

EFFECT.NextParticle = 0

function EFFECT:Init(d)
	self.TargetEntity = d:GetEntity()
	self.Emitter = ParticleEmitter(self.TargetEntity:GetPos())
end

function EFFECT:Think()
	if ValidEntity(self.TargetEntity) and self.NextParticle <= CurTime() then
		local particle = self.Emitter:Add("particles/flamelet"..math.random(1,5),self.TargetEntity:GetPos())
		particle:SetVelocity(self.TargetEntity:GetVelocity())
		particle:SetLifeTime(1)
		particle:SetDieTime(2)
		particle:SetStartAlpha(255)
		particle:SetStartSize(50)
		particle:SetRoll(math.Rand(-360,360))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetAirResistance(100)
		particle:SetGravity(WDS2.ZeroVector)
		self.NextParticle = CurTime() + 0.01
	else
		self.Emitter:Finish()
	end
	return ValidEntity(self.TargetEntity)
end

function EFFECT:Render() 
end
