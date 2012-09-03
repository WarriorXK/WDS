
local PartCol = Color(255,0,0,255)
local Mat = "wds/effects/blankparticle"

function EFFECT:Init(data)
	self.Ent = data:GetEntity()
	self.Pos = data:GetStart()
	self.DeathTime = CurTime()+0.2
	
	local Emitter = ParticleEmitter(self.Ent:LocalToWorld(self.Pos))
	local particle = Emitter:Add(Mat,self.Ent:LocalToWorld(self.Pos))
	particle:SetLifeTime(0.5)
	particle:SetDieTime(1)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(50)
	particle:SetStartSize(50)
	particle:SetEndSize(20)
	particle:SetRoll(math.Rand(-360,360))
	particle:SetRollDelta(math.Rand(-1,1))
	particle:SetAirResistance(100)
	particle:SetGravity(WDS2.ZeroVector)
	particle:SetColor(PartCol)
	
end 

function EFFECT:Think() return false end

function EFFECT:Render() end
