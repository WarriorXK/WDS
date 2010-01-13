
EFFECT.Mat = Material("cable/redlaser")

function EFFECT:Init(d)
	self.StartPos = d:GetOrigin()	
	self.EndPos = d:GetStart()
	self.Dir = self.EndPos-self.StartPos
	self.Entity:SetRenderBoundsWS(self.StartPos,self.EndPos)
	self.DieTime = CurTime()+0.3
end

function EFFECT:Think()
	return self.DieTime > CurTime()
end

function EFFECT:Render()
	render.SetMaterial(self.Mat)
	render.DrawBeam(self.EndPos,self.StartPos,7,0,0,Color(255,0,0,255))
end
