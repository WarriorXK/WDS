
local Mat = "wds/effects/blankparticle"
local Grav = Vector(0,0,50)

EFFECT.NextFlame = 0

function EFFECT:Init(d)
	self.TargetEntity = d:GetEntity()
	self.CreationTime = CurTime()
	if ValidEntity(self.TargetEntity) then
		self.Emitter = ParticleEmitter(self.TargetEntity:GetPos())
	end
end

function EFFECT:Think()
	local Valid = ValidEntity(self.TargetEntity)
	if self.NextFlame <= CurTime() then
		if Valid then
			local Mul = CurTime() - self.CreationTime
			local Flame = self.Emitter:Add("particles/flamelet"..math.random(1,5),self.TargetEntity:GetPos() + Vector(math.random(-5,5),math.random(-5,5),math.random(-5,5)))
			//Flame:SetVelocity(self.TargetEntity:GetVelocity())
			Flame:SetLifeTime(1)
			Flame:SetDieTime(2)
			Flame:SetStartAlpha(255)
			Flame:SetStartSize(math.Rand(15,30) * (10 * Mul))
			Flame:SetEndSize(2)
			Flame:SetRoll(math.Rand(-360,360))
			Flame:SetRollDelta(math.Rand(-1,1))
			Flame:SetAirResistance(200)
			Flame:SetGravity(WDS2.ZeroVector)

		elseif self.Emitter then
			self.Emitter:Finish()
		end
		self.NextFlame = CurTime() + 0.001
	end
	return Valid
end

function EFFECT:Render() 
end
