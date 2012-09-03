include('shared.lua')

local Mat = Material("wds/effects/at_mine_glow")
local Col = Color(30, 180, 255, 110)

ENT.EffectRandom = 15.5
ENT.LastThink = 0

function ENT:Draw()

	if self.dt.Timer > 0 and self.dt.Timer + 2 <= CurTime() then // If the timer has been set and the ropes have been attached
	
		render.SetMaterial(Mat)
		render.DrawSprite(self:GetPos(), self.EffectRandom, self.EffectRandom, Col)
		
	end
	self:DrawModel()

end

function ENT:Think()

	if self.dt.Timer > 0 and self.dt.Timer + 2 <= CurTime() and WDS2.Convars.EnableDynamicLights:GetBool() then
	
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
		
			local LightSize = 70 * WDS2.Convars.DynamicLightsSize:GetFloat()
			dlight.Pos = self:LocalToWorld(self:OBBCenter())
			dlight.r = Col.r
			dlight.g = Col.g
			dlight.b = Col.b
			dlight.Brightness = 1
			dlight.Size = LightSize
			dlight.Decay = LightSize * 5
			dlight.DieTime = CurTime() + 1
			
		end

	end
	
	if self.LastThink != CurTime() then self.EffectRandom = math.random(15, 16) end // Prevents the effect from changing size when the game is pauzed

	self.LastThink = CurTime()
	self:NextThink(CurTime()+1)
	return true
	
end
language.Add(ENT.ClassName,ENT.PrintName)
