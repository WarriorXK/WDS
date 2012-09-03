include('shared.lua')

local BeamStartPos = Vector(-8,0,0.7)
local BeamEndPos = Vector(12.5,0,0.7)

local BeamColor = Color(255,0,0,255)
ENT.BeamSize = 45
local BeamMat = Material("tripmine_laser")

local SpriteMat = Material("wds/effects/blankparticle")
ENT.SpriteColor = Color(255,0,0,150)
ENT.SpriteSize = 4.1

function ENT:Draw()
	local SPos = self:LocalToWorld(BeamStartPos)
	local EPos = self:LocalToWorld(BeamEndPos)
	render.SetMaterial(BeamMat)
	render.DrawBeam(SPos, EPos, self.BeamSize, 1, 1, BeamColor)
	render.SetMaterial(SpriteMat)
	render.DrawSprite(SPos, self.SpriteSize, self.SpriteSize, self.SpriteColor)
	render.SetMaterial(SpriteMat)
	render.DrawSprite(EPos, self.SpriteSize, self.SpriteSize, self.SpriteColor)
end

function ENT:Think()
	if WDS2.Convars.EnableDynamicLights:GetBool() then
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			local LightSize = 100*WDS2.Convars.DynamicLightsSize:GetFloat()
			dlight.Pos = self:LocalToWorld(self:OBBCenter())
			dlight.r = BeamColor.r
			dlight.g = BeamColor.g
			dlight.b = BeamColor.b
			dlight.Brightness = 1
			dlight.Size = LightSize
			dlight.Decay = LightSize*5
			dlight.DieTime = CurTime()+1
		end
	end
	self:NextThink(CurTime()+1)
	return true
end
language.Add(ENT.ClassName,ENT.PrintName)