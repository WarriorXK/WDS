
local SpriteMat = Material("wds/effects/blankparticle")
local LaserMat = Material("wds/effects/bluelaser1")
local Col = Color(70, 70, 255, 150)

function EFFECT:Init(d)
	self.StartPos = d:GetStart()
	self.EndPos = d:GetOrigin()
	self.DieTime = CurTime() + 0.3
	self:SetRenderBoundsWS(self.StartPos,self.EndPos)
end

function EFFECT:Think()
	return self.DieTime > CurTime()
end

function EFFECT:Render()
	render.SetMaterial(SpriteMat)
	render.DrawSprite(self.StartPos, 35, 35, Col)
	render.SetMaterial(LaserMat)
	render.DrawBeam(self.EndPos, self.StartPos, 14, 0, 0, Col)
end
