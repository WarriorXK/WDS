include('shared.lua')

local Col = Color(168,143,42,255)

function ENT:Initialize()
	//self.LoopSound = CreateSound(self,"wds2/weapons/smalltankcannon/projectile_loop.wav") //Todo : Change the sound
	//self.LoopSound:Play()
end

function ENT:Draw() end // We don't need to be drawn

function ENT:OnRemove()
	//self.LoopSound:Stop()
end

function ENT:Think()

	if WDS2.Convars.EnableDynamicLights:GetBool() then
	
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
		
			local LightSize = 250*WDS2.Convars.DynamicLightsSize:GetFloat()
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
language.Add(ENT.ClassName, ENT.PrintName)