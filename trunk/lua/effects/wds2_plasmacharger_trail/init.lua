
local Mat = "wds/effects/blankparticle"

EFFECT.NextParticle = 0
EFFECT.Size = 0

function EFFECT:Init(d)

	self.Size = d:GetMagnitude()
	self.TargetEntity = d:GetEntity()
	
	if IsValid(self.TargetEntity) then
		self.TargetEntity.Draw = function() end
		
		self.Emitter = ParticleEmitter(self.TargetEntity:GetPos())
	end
	
end

function EFFECT:Think()

	local ValidEffect = self.Emitter and IsValid(self.TargetEntity)
	
	if ValidEffect then
	
		if self.NextParticle <= CurTime() then
		
			local particle = self.Emitter:Add(Mat,self.TargetEntity:GetPos())
			particle:SetVelocity(self.TargetEntity:GetVelocity())
			particle:SetLifeTime(1)
			particle:SetDieTime(2)
			particle:SetColor(75,math.random(80,180),255)
			particle:SetStartAlpha(255)
			particle:SetStartSize(17 * self.Size)
			particle:SetRoll(math.Rand(-360,360))
			particle:SetRollDelta(math.Rand(-1,1))
			particle:SetAirResistance(100)
			particle:SetGravity(WDS2.ZeroVector)
			particle:SetCollide(true)
			particle:SetCollideCallback(function(part) part:SetDieTime(0) end)
			self.NextParticle = CurTime() + 0.01
			
		end
		
	else
	
		if self.Emitter then self.Emitter:Finish() end
		
	end
	
	return ValidEffect
	
end

function EFFECT:Render() end
