include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.ClipHeight = 0

function ENT:Draw()
	local normal = self:GetUp()*-1
	local Mins = self:OBBMins().z
	local Maxs = self:OBBMaxs().z
	local distance = normal:Dot(self:LocalToWorld(Vector(0,0,Mins+(((Maxs-Mins)/100)*self.ClipHeight))))
	render.EnableClipping(true)
		render.PushCustomClipPlane(normal,distance)
			self:DrawModel()
		render.PopCustomClipPlane()
	render.EnableClipping(false)
end
language.Add("wds_tool_shielddome",ENT.PrintName)

function ENT:Think()
	self.ClipHeight = math.Approach(self.ClipHeight,100,4)
end
