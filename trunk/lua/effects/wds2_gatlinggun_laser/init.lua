
local SpriteMat = Material("wds/effects/blankparticle")
local LaserMat = Material("cable/redlaser")
local Col = Color(255,70,70,150)

function EFFECT:Init(d)
	self.StartPos = d:GetStart()
	self.EndPos = d:GetOrigin()
	self.DieTime = CurTime() + 0.3
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)
end

function EFFECT:Think()
	return self.DieTime > CurTime()
end

function EFFECT:Render()
	render.SetMaterial(SpriteMat)
	render.DrawSprite(self.StartPos,7,7,Col)
	render.SetMaterial(LaserMat)
	render.DrawBeam(self.EndPos,self.StartPos,7,0,0,Col)
end
