
function EFFECT:Init(data)
	local Pos = data:GetStart()
	local Norm = data:GetNormal()
	local Emitter = ParticleEmitter(Pos)
	for n=0,8 do
		for i=1,2 do
			local PBase = (i == 1 and Norm or Norm * -1)
			local particle = Emitter:Add("particles/flamelet"..math.random(1,5),Pos + (PBase * (n*4)))
			particle:SetVelocity(PBase * 300)
			particle:SetLifeTime(1)
			particle:SetDieTime(math.Rand(1.4,1.7))
			particle:SetStartAlpha(255)
			particle:SetStartSize(30)
			particle:SetRoll(math.Rand(-360,360))
			particle:SetRollDelta(math.Rand(-1,1))
			particle:SetAirResistance(500)
			particle:SetGravity(WDS2.ZeroVector)
		end
	end
	for n=1,8 do
		for i=1,2 do
			local PBase = (i == 1 and Norm or Norm * -1)
			local particle = Emitter:Add("particles/smokey",Pos + (PBase * (n*4)))
			particle:SetVelocity(PBase * (200 * (n / 3)))
			particle:SetLifeTime(1)
			particle:SetDieTime(math.Rand(2,4))
			particle:SetStartAlpha(50)
			particle:SetStartSize(5)
			particle:SetEndSize(20)
			particle:SetRoll(math.Rand(-360,360))
			particle:SetRollDelta(math.Rand(-1,1))
			particle:SetAirResistance(300 * (n / 3))
			particle:SetGravity(WDS2.ZeroVector)
		end
	end
	Emitter:Finish()
end 

function EFFECT:Think() return false end

function EFFECT:Render() end
