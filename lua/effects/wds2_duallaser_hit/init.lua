
local Decal = "WDS2.DualLaserImpact"

function EFFECT:Init(data)

	self.Pos = data:GetOrigin()
	local Norm = data:GetNormal()
	
	util.Decal(Decal ,self.Pos + (Norm * 2), self.Pos - (Norm * 2)) // TODO : WY U NO WORK!
end 

function EFFECT:Think() return false end

function EFFECT:Render() end
