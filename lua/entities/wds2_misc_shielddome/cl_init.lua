include('shared.lua')

local EffectColor = Color(255, 255, 255, 255)
local EffectMat = Material("wds/effects/shieldsphere")

ENT.CurSize = 1024

function ENT:Draw()

	if IsValid(self.dt.Generator) then
	
		local Normal = (LocalPlayer():GetPos()-self:GetPos()):GetNormalized()
		render.SetMaterial(EffectMat)
		render.DrawSphere( self:GetPos(), self.CurSize / 2, 35, 35, EffectColor )
		
	end
	
end
language.Add(ENT.ClassName, ENT.PrintName)

function ENT:Think()
	
	local SlowSize = 128
	local Inc = 2
	
	local Diff = self.CurSize-self.dt.Generator:GetRadius()
	if Diff < 0 then Diff = -Diff end
	
	if Diff < SlowSize then
		Inc = (2 / SlowSize) * Diff
	end
	
	self.CurSize = math.Approach(self.CurSize, self.dt.Generator:GetRadius(), Inc)

end
