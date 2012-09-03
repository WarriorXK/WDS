include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
local Mat = Material("tripmine_laser")
local Col = Color(255,255,255,255)

local HScreenVect = Vector(-1.7, 1.38, 1.6)
local HScreenAng = Angle(0,270,28)
local HScreenScale = 0.1
local HScreenSizeH = 28
local HScreenSizeW = 40
local HScreenTextH = 2
local HScreenTextW = 0

function ENT:Draw()
	self:DrawModel()
	local tr = self:GetTrace()
	self:SetRenderBoundsWS(self:GetPos(),tr.HitPos)
	cam.Start3D2D(self:LocalToWorld(HScreenVect),self:LocalToWorldAngles(HScreenAng),HScreenScale)
		self:Draw3D2D()
	cam.End3D2D()
end

function ENT:Draw3D2D()
	// Black background
	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect(0,0,HScreenSizeH,HScreenSizeW)
	
	local Tbl = string.Explode("", tostring(math.Round(self.dt.Health)))
	local Text = ""
	
	for k,v in pairs(Tbl) do
		Text = Text .. v
		if (k % 4) == 0 then Text = Text .. "\n" end // Add a newline after every 4th character
	end
	
	draw.DrawText(Text,"Trebuchet18",HScreenTextW,HScreenTextH,Color(255,255,255,255),ALIGN_LEFT)
	
end

function ENT:DrawTranslucent()
	local tr = self:GetTrace()
	render.SetMaterial(Mat)
	render.DrawBeam(self:GetPos(),tr.HitPos,6,0,10,Col)
end
language.Add(ENT.ClassName,ENT.PrintName)