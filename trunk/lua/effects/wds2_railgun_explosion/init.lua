
local Mat = "wds/effects/blankparticle"

EFFECT.HasExploded = false
EFFECT.NextSpark = 0

function EFFECT:Init(d)
	self.Pos = d:GetOrigin()
	self.ExplosionDelay = 2.5
	self.SparkDelay = 4
	self.BallSize = 70
	self.Emitter = ParticleEmitter(self.Pos)
	
	self.ExplosionTime = CurTime()+self.ExplosionDelay
	self.SparkTime = CurTime()+self.SparkDelay
	self.DeathTime = CurTime()+7
	self.EndTime = CurTime()+5.5
	
	for i=1,20 do
		local Particle = self.Emitter:Add(Mat,self.Pos)
		Particle:SetVelocity(Vector(math.Rand(-1, 1),math.Rand(-1, 1),math.Rand(-1, 1)) * 20)
		Particle:SetAirResistance(50)
		Particle:SetDieTime(self.ExplosionDelay)
		Particle:SetStartAlpha(100)
		Particle:SetEndAlpha(255)
		Particle:SetStartSize(20)
		Particle:SetEndSize(self.BallSize)
		Particle:SetRoll(0)
		Particle:SetRollDelta(0)
		Particle:SetColor(75,math.random(80,180),255)
	end
	
end

function EFFECT:Think()
	if self.EndTime >= CurTime() then
		local VelMul = 500
		if self.ExplosionTime < CurTime() and !self.HasExploded then
			for i=1,200 do
				local Vel =  Vector(math.Rand(-1, 1),math.Rand(-1, 1),math.Rand(-0.8, 0.8)) * VelMul
				for i=1,4 do
					local Particle = self.Emitter:Add(Mat,self.Pos)
					Particle:SetVelocity(Vel)
					Particle:SetAirResistance(math.random(60,80))
					Particle:SetDieTime(math.Rand(2,4.5))
					Particle:SetStartAlpha(200)
					Particle:SetEndAlpha(70)
					Particle:SetStartSize(70)
					Particle:SetEndSize(20)
					Particle:SetRoll(0)
					Particle:SetRollDelta(0)
					Particle:SetColor(75,math.random(80,180),255)
				end
			end
			self.HasExploded = true
		end

		if self.SparkTime < CurTime() and self.NextSpark <= CurTime() then
			local Rand = ((VelMul / 2) / 3) * 2
			for i=1,3 do
				local Particle = self.Emitter:Add(Mat,self.Pos+Vector(math.random(-Rand,Rand),math.random(-Rand,Rand),math.random(-Rand,Rand)))
				Particle:SetAirResistance(50)
				Particle:SetDieTime(math.Rand(1,1.5))
				Particle:SetStartAlpha(200)
				Particle:SetEndAlpha(70)
				Particle:SetStartSize(30)
				Particle:SetEndSize(30)
				Particle:SetRoll(0)
				Particle:SetRollDelta(0)
				Particle:SetColor(150,math.random(80,180),255)
			end
			self.NextSpark = CurTime()+0.03
		end
	end

	return self.DeathTime >= CurTime()
end

function EFFECT:Render() end
