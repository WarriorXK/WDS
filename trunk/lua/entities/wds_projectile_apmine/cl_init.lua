include('shared.lua')

local Mat = Material("wds/effects/blankparticle")

function ENT:Draw()
	self:DrawModel()
	render.SetMaterial(Mat)
	if self.dt.NextExplode or 0 > CurTime() then
		render.DrawSprite(self:GetPos()+(self:GetUp()*4),15,15,Color(0,0,255))
	elseif self.dt.Warning then
		render.DrawSprite(self:GetPos()+(self:GetUp()*4),15,15,Color(255,0,0))
	end
end
language.Add("wds_projectile_mine",ENT.PrintName)