include('shared.lua')

local Col = Color(216,185,27,255)

function ENT:Draw() end

function ENT:Think()
	if WDS2.Convars.EnableDynamicLights:GetBool() then
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			local LightSize = 400 * WDS2.Convars.DynamicLightsSize:GetFloat()
			dlight.Pos = self:LocalToWorld(self:OBBCenter())
			dlight.r = Col.r
			dlight.g = Col.g
			dlight.b = Col.b
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