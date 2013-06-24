include('shared.lua')

local Col = Color(216,185,27,255)

ENT.NextDynLight = 0

function ENT:Draw()
	
	if self.NextDynLight <= CurTime() then
	
		if WDS2.Convars.EnableDynamicLights:GetBool() then
		
			local dlight = DynamicLight(self:EntIndex())
			if dlight then
			
				local LightSize = 400 * WDS2.Convars.DynamicLightsSize:GetFloat()
				dlight.Pos = self:GetPos()
				dlight.r = Col.r
				dlight.g = Col.g
				dlight.b = Col.b
				dlight.Brightness = 1
				dlight.Size = LightSize
				dlight.Decay = 0
				dlight.DieTime = CurTime()+0.2
				
			end
			
			self.NextDynLight = CurTime()+0.1
			
		else
		
			self.NextDynLight = CurTime()+1
			
		end
		
	end
	
end

language.Add(ENT.ClassName, ENT.PrintName)