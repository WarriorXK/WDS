
EFFECT.Mat = "particle/particle_smokegrenade"

function EFFECT:Init(data)
	local emitter = ParticleEmitter(data:GetOrigin())
	for i=0,data:GetMagnitude() do
		local particle = emitter:Add(self.Mat,data:GetOrigin()+Vector(math.Rand(-256,256),math.Rand(-256,256),math.Rand(-64,64))+Vector(0,0,42))
		if particle then
			local Size = math.Rand(164,256)
			local Col = math.random(240,255)
			particle:SetVelocity(VectorRand()*math.Rand(1920,2142))
			particle:SetLifeTime(0)
			particle:SetDieTime(math.Rand(30,50))
			particle:SetColor(Col,Col,Col)
			particle:SetStartAlpha(math.Rand(142,162))
			particle:SetEndAlpha(0)
			particle:SetStartSize(Size)
			particle:SetEndSize(Size)
			particle:SetRoll(math.Rand(-360,360))
			particle:SetRollDelta(math.Rand(-1,1))
			particle:SetAirResistance(math.Rand(520,620))
			particle:SetGravity(Vector(0,0,math.Rand(-32,-64)))
			particle:SetCollide(true)
			particle:SetBounce(0.42)
			particle:SetLighting(1)
		end
	end
	emitter:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end
