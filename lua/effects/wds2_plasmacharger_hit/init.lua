
local Mat = "wds/effects/blankparticle"

function EFFECT:Init(d)
	local Vec = d:GetStart()
	local Pos = d:GetOrigin()
	local Emitter = ParticleEmitter(Pos)
	
	for i=1,500 do
		local Particle = Emitter:Add(Mat,Pos)
		Particle:SetVelocity(((Vec:GetNormal() * math.random(-1,1)) + Vector(math.Rand(-1, 1),math.Rand(-1, 1),math.Rand(-1, 1))) * 100)
		Particle:SetAirResistance(70)
		Particle:SetDieTime(math.Rand(0.5,6))
		Particle:SetStartAlpha(200)
		Particle:SetEndAlpha(20)
		Particle:SetGravity(Vector(50*math.Rand(-1,1),50*math.Rand(-1,1),50*math.Rand(-1,1)))
		Particle:SetStartSize(30)
		Particle:SetEndSize(40)
		Particle:SetRoll(0)
		Particle:SetRollDelta(0)
		Particle:SetColor(75,math.random(80,180),255)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render() 
end
