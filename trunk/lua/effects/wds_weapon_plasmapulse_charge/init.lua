
EFFECT.NextAddSize = 0
EFFECT.Size = 0
EFFECT.Mat = Material("wds/effects/flare")

function EFFECT:Init(data)
	self.Ent		= data:GetEntity()
	self.Offset		= data:GetOrigin()
	self.Scale		= data:GetScale()
	self.CreateTime	= CurTime()
end

function EFFECT:Think()
	if self.CreateTime+self.Scale <= CurTime() then
		self.Size = self.Size-7
	elseif self.NextAddSize <= CurTime() then
		self.Size = self.Size+0.5
		self.NextAddSize = CurTime()+0.05
	end
	return self.Size > 0
end

function EFFECT:Render()
	local Pos = util.LocalToWorld(self.Ent,self.Offset)
	render.SetMaterial(self.Mat)
	render.DrawSprite(Pos,self.Size*8,self.Size*4,Color(255,226,174,240))
	self:SetRenderBoundsWS(Pos*-self.Size,Pos*self.Size)
end
