
local Mat = "wds/effects/blankparticle"

function EFFECT:Init(d)
	self.TargetEntity = d:GetEntity()
	if ValidEntity(self.TargetEntity) then
		self.TargetEntity:SetColor(255,255,255,0)
		self.Emitter = ParticleEmitter(self.TargetEntity:GetPos())
	end
end

function EFFECT:Think()
	local Valid = ValidEntity(self.TargetEntity)
	if Valid then
		local Flame = self.Emitter:Add("particles/flamelet"..math.random(1,5),self.TargetEntity:GetPos())
		Flame:SetVelocity(self.TargetEntity:GetVelocity())
		Flame:SetLifeTime(1)
		Flame:SetDieTime(2)
		Flame:SetStartAlpha(255)
		Flame:SetStartSize(50)
		Flame:SetRoll(math.Rand(-360,360))
		Flame:SetRollDelta(math.Rand(-1,1))
		Flame:SetAirResistance(200)
		Flame:SetGravity(WDS2.ZeroVector)
		
		local Smoke = self.Emitter:Add("particles/smokey",self.TargetEntity:GetPos()+Vector(math.random(-5,5),math.random(-5,5),math.random(-5,5)))
		Smoke:SetVelocity(self.TargetEntity:GetVelocity())
		Smoke:SetLifeTime(1.5)
		Smoke:SetDieTime(math.random(2,3))
		Smoke:SetStartAlpha(100)
		Smoke:SetEndAlpha(0)
		Smoke:SetStartSize(30)
		Smoke:SetEndSize(10)
		Smoke:SetRoll(math.Rand(-360,360))
		Smoke:SetRollDelta(math.Rand(-1,1))
		Smoke:SetAirResistance(300)
		Smoke:SetGravity(WDS2.ZeroVector)
		
	elseif self.Emitter then
		self.Emitter:Finish()
	end
	return Valid
end

function EFFECT:Render() 
end
