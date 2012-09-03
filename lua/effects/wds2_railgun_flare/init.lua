
local Exits =	{
					Vector(0.9205, 5.6819, 3.5498),
					Vector(0.9597, 5.7284, -3.1844),
					Vector(0.8518, 0.2412, -6.4653),
					Vector(0.9391,-5.6558, -3.3094),
					Vector(0.7471, -5.7975, 3.3635),
					Vector(0.9126, -0.1301, 6.7888)
				}

function EFFECT:Init(data)

	local Ent = data:GetEntity()
	local Pos = Ent:LocalToWorld(data:GetStart())
	local Emitter = ParticleEmitter(Pos)
	
	for _,v in pairs(Exits) do
	
		local PBase = (Ent:GetPos()-Ent:LocalToWorld(v)):GetNormal()
		for n=1,8 do
		
			local Particle = Emitter:Add("wds/effects/blankparticle",Pos + (PBase * (n*4)))
			Particle:SetVelocity(PBase * 300)
			Particle:SetLifeTime(1)
			Particle:SetDieTime(math.Rand(2,4))
			Particle:SetStartAlpha(255)
			Particle:SetStartSize(20)
			Particle:SetRoll(math.Rand(-360,360))
			Particle:SetRollDelta(math.Rand(-1,1))
			Particle:SetAirResistance(500)
			Particle:SetGravity(WDS2.ZeroVector)
			Particle:SetColor(75,math.random(80,180),255)
			
			local Particle = Emitter:Add("particles/smokey",Pos + (PBase * (n*4)))
			Particle:SetVelocity(PBase * (230 * (n / 3)))
			Particle:SetLifeTime(1)
			Particle:SetDieTime(math.Rand(2,6))
			Particle:SetStartAlpha(50)
			Particle:SetStartSize(5)
			Particle:SetEndSize(20)
			Particle:SetRoll(math.Rand(-360,360))
			Particle:SetRollDelta(math.Rand(-1,1))
			Particle:SetAirResistance(325 * (n / 3))
			Particle:SetGravity(WDS2.ZeroVector)
			
		end
		
	end
	
	Emitter:Finish()
	
end 

function EFFECT:Think() return false end

function EFFECT:Render() end
