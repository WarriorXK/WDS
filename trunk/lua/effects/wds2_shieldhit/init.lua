
local Mat = "wds/effects/blankparticle"

function EFFECT:Init(d)

	local Size = d:GetMagnitude() == 0 and 1 or d:GetMagnitude()
	local Vec = d:GetStart()
	local Pos = d:GetOrigin()
	
	local AngCol = d:GetAngles()
	local Col = Color(255, 255, 255)

	local Emitter = ParticleEmitter(Pos)
	
	for i=1, 50 do
	
		local Particle = Emitter:Add(Mat,Pos)
		local VelValue = 1 * Size
		Particle:SetVelocity(((Vec:GetNormal() * math.random(-VelValue, VelValue)) + Vector(math.Rand(-VelValue, VelValue), math.Rand(-VelValue, VelValue), math.Rand(-VelValue, VelValue))) * 100)
		Particle:SetAirResistance( 100 )
		Particle:SetDieTime(math.Rand(0.2, 0.5))
		Particle:SetStartAlpha(200)
		Particle:SetEndAlpha(20)
		Particle:SetGravity(Vector(50 * math.Rand(-1,1), 50 * math.Rand(-1,1), 50 * math.Rand(-1,1)))
		Particle:SetStartSize(5.5 * Size)
		Particle:SetEndSize(5 * Size)
		Particle:SetRoll(0)
		Particle:SetRollDelta(0)
		
		print("\n")
		PrintTable(Col)
		print(AngCol.p, AngCol.y, AngCol.r)
		
		Col.r = math.Rand(AngCol.p - 10, AngCol.p + 10)
		Col.g = math.Rand(AngCol.y - 10, AngCol.y + 10)
		Col.b = math.Rand(AngCol.r - 10, AngCol.r + 10)
		
		Particle:SetColor(Col.r, Col.g, Col.b)
		Particle:SetCollide(true)
		Particle:SetCollideCallback(function(part) part:SetDieTime(0) end)
		
	end
	
end

function EFFECT:Think()
	return false
end

function EFFECT:Render() 
end
