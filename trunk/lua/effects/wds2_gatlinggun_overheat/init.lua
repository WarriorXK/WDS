
local Offset = Vector(29, 0, 0)

EFFECT.NextSmoke = 0

function EFFECT:Init(d)

	self.TargetEntity = d:GetEntity()

	if ValidEntity(self.TargetEntity) then
		self.Emitter = ParticleEmitter(self.TargetEntity:GetPos())
	end
	
end

function EFFECT:Think()

	local Valid = ValidEntity(self.TargetEntity) and self.TargetEntity.dt.Overheated and self.TargetEntity.dt.Heat > 2
	if Valid then
	
		if self.NextSmoke <= CurTime() then
		
			local Smoke = self.Emitter:Add("particles/smokey", self.TargetEntity:LocalToWorld(Offset))
			Smoke:SetLifeTime(math.Rand(4,5))
			Smoke:SetDieTime(math.Rand(10,12))
			Smoke:SetStartAlpha(math.Rand(10,20))
			Smoke:SetEndAlpha(0)
			Smoke:SetStartSize(math.Rand(7,10))
			Smoke:SetEndSize(15)
			Smoke:SetRoll(math.Rand(-360,360))
			Smoke:SetRollDelta(math.Rand(-1,1))
			Smoke:SetAirResistance(300)
			Smoke:SetGravity(Vector(math.Rand(-20,20), math.Rand(-20,20), math.Rand(100,200)))
			Smoke:SetVelocity(Vector())

			local Mag = (1 / self.TargetEntity.dt.Heat)
			self.NextSmoke = CurTime()+math.Rand(0.08 + Mag, 0.10 + Mag)
			
		end
		
	elseif self.Emitter then
		self.Emitter:Finish()
	end
	
	return Valid
	
end

function EFFECT:Render() 
end
