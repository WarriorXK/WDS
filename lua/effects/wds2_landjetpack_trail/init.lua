
local RightJetVector = Vector(-10,-5,38.5)
local LeftJetVector = Vector(-10,5,38.5)

local PartVel = Vector(0,0,-300)

EFFECT.NextParticles = 0

function EFFECT:Init(d)
	self.TargetEntity = d:GetEntity()
	if IsValid(self.TargetEntity) then
		self.Emitter = ParticleEmitter(self.TargetEntity:GetPos())
	end
end

function EFFECT:Think()
	local Valid = IsValid(self.TargetEntity) and self.TargetEntity:Alive()
	if Valid and IsValid(self.TargetEntity:GetActiveWeapon()) and self.TargetEntity:GetActiveWeapon():GetClass() == "wds2_swep_landjetpack" and self.TargetEntity:GetActiveWeapon().dt.Flying then

		local Ang = self.TargetEntity:EyeAngles()
		Ang.p = 0
		
		local LPos = LocalToWorld(LeftJetVector, WDS2.ZeroAngle, self.TargetEntity:GetPos(), Ang)
		local RPos = LocalToWorld(RightJetVector, WDS2.ZeroAngle, self.TargetEntity:GetPos(), Ang)
		
		if self.NextParticles <= CurTime() then
			
			local RandVel = Vector(math.Rand(-2,2),math.Rand(-2,2),0)
			
			// Right Thruster
			local RFlame = self.Emitter:Add("particles/flamelet"..math.random(1,5),RPos)
			RFlame:SetLifeTime(1)
			RFlame:SetDieTime(2)
			RFlame:SetStartAlpha(255)
			RFlame:SetStartSize(5)
			RFlame:SetRoll(math.Rand(-360,360))
			RFlame:SetRollDelta(math.Rand(-1,1))
			RFlame:SetAirResistance(300)
			RFlame:SetGravity(WDS2.ZeroVector)
			RFlame:SetVelocity(PartVel + RandVel)
			RFlame:SetCollide(true)
			RFlame:SetCollideCallback(function(part) part:SetLifeTime(0.2) part:SetDieTime(0.3) end)
			
			local RSmoke = self.Emitter:Add("particles/smokey",RPos+Vector(math.random(-2,2),math.random(-2,2),math.random(-2,2)))
			RSmoke:SetLifeTime(1.5)
			RSmoke:SetDieTime(math.random(2,3))
			RSmoke:SetStartAlpha(100)
			RSmoke:SetEndAlpha(0)
			RSmoke:SetStartSize(10)
			RSmoke:SetEndSize(10)
			RSmoke:SetRoll(math.Rand(-360,360))
			RSmoke:SetRollDelta(math.Rand(-1,1))
			RSmoke:SetAirResistance(300)
			RSmoke:SetGravity(WDS2.ZeroVector)
			RSmoke:SetVelocity(PartVel + RandVel)
			RSmoke:SetCollide(true)
			
			// Left Thruster
			local LFlame = self.Emitter:Add("particles/flamelet"..math.random(1,5),LPos)
			LFlame:SetLifeTime(1)
			LFlame:SetDieTime(2)
			LFlame:SetStartAlpha(255)
			LFlame:SetStartSize(5)
			LFlame:SetRoll(math.Rand(-360,360))
			LFlame:SetRollDelta(math.Rand(-1,1))
			LFlame:SetAirResistance(300)
			LFlame:SetGravity(WDS2.ZeroVector)
			LFlame:SetVelocity(PartVel + RandVel)
			LFlame:SetCollide(true)
			LFlame:SetCollideCallback(function(part) part:SetLifeTime(0.2) part:SetDieTime(0.3) end)

			local LSmoke = self.Emitter:Add("particles/smokey",LPos+Vector(math.random(-2,2),math.random(-2,2),math.random(-2,2)))
			LSmoke:SetLifeTime(1.5)
			LSmoke:SetDieTime(math.random(2,3))
			LSmoke:SetStartAlpha(100)
			LSmoke:SetEndAlpha(0)
			LSmoke:SetStartSize(10)
			LSmoke:SetEndSize(10)
			LSmoke:SetRoll(math.Rand(-360,360))
			LSmoke:SetRollDelta(math.Rand(-1,1))
			LSmoke:SetAirResistance(300)
			LSmoke:SetGravity(WDS2.ZeroVector)
			LSmoke:SetVelocity(PartVel + RandVel)
			LSmoke:SetCollide(true)
			
			self.NextParticles = CurTime() + 0.005
		end
		
	elseif self.Emitter then
		self.Emitter:Finish()
	end
	return Valid
end

function EFFECT:Render() end
