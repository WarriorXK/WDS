include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
local LaserMat = Material("tripmine_laser")
local SpriteMat = Material("wds/effects/blankparticle")
local Col = Color(255,0,0,255)

function ENT:Draw()

	self:DrawModel()
	
	local tr = self:GetTrace()
	self:SetRenderBoundsWS( self:LocalToWorld(self.LaserPos), tr.HitPos )
	
end

function ENT:DrawTranslucent()

	if self:GetLaserEnabled() then
	
		local tr = self:GetTrace()
		local Pos = self:LocalToWorld(self.LaserPos)
		
		render.SetMaterial( SpriteMat )
		render.DrawSprite( Pos, 7, 7, Col )
		
		render.SetMaterial( LaserMat )
		render.DrawBeam( Pos, tr.HitPos, 6, 0, 10, Col )
		
	end
	
end
language.Add( ENT.ClassName, ENT.PrintName )