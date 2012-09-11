
local Mat = "wds/effects/blankparticle"

function EFFECT:Init(d)

	local Size = d:GetMagnitude()
	local Vec = d:GetStart()
	local Pos = d:GetOrigin()
	local Emitter = ParticleEmitter(Pos)
	
	for i=1,500 do
		local Particle = Emitter:Add(Mat,Pos)
		local VelValue = 0.3 * Size
		Particle:SetVelocity(((Vec:GetNormal() * math.random(-VelValue, VelValue)) + Vector(math.Rand(-VelValue, VelValue), math.Rand(-VelValue, VelValue), math.Rand(-VelValue, VelValue))) * 100)
		Particle:SetAirResistance(70)
		Particle:SetDieTime(math.Rand(0.5, 6))
		Particle:SetStartAlpha(200)
		Particle:SetEndAlpha(20)
		Particle:SetGravity(Vector(50 * math.Rand(-1,1), 50 * math.Rand(-1,1), 50 * math.Rand(-1,1)))
		Particle:SetStartSize(10 * Size)
		Particle:SetEndSize(13.5 * Size)
		Particle:SetRoll(0)
		Particle:SetRollDelta(0)
		Particle:SetColor(75, math.random(80,180), 255)
	end
	
end

function EFFECT:Think()
	return false
end

function EFFECT:Render() 
end
