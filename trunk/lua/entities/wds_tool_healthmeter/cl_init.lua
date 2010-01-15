include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
local Mat = Material("tripmine_laser")

function ENT:Draw()
	self:DrawModel()
	local tr = WDS.TraceLine(self:GetPos(),self:GetPos()+(self:GetForward()*10000),{self})
	self:SetRenderBoundsWS(self:GetPos()-self:GetUp()*-self:BoundingRadius(),tr.HitPos)
end

function ENT:DrawTranslucent()
	local tr = WDS.TraceLine(self:GetPos(),self:GetPos()+(self:GetForward()*10000),{self})
	render.SetMaterial(Mat)
	render.DrawBeam(self:GetPos(),tr.HitPos,6,0,10,Color(255,255,255,255))
end
language.Add("wds_tool_healthmeter",ENT.PrintName)