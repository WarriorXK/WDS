include('shared.lua')

ENT.SpriteSize	= 9
ENT.Mat			= Material("wds/effects/blankparticle")

function ENT:Draw()
	self:DrawModel()
	render.SetMaterial(self.Mat)
	local Col = Color(0,0,255)
	if self.dt.Warning then
		Col = Color(255,0,0)
	end
	if self.dt.Online then
		render.DrawSprite(self:GetPos()+(self:GetUp()*2),self.SpriteSize,self.SpriteSize,Col)
	end
end
language.Add("wds_projectile_mine",ENT.PrintName)