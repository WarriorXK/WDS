include('shared.lua')

function ENT:Draw()
	self:SetModelScale(Vector(self.dt.Scale,self.dt.Scale,self.dt.Scale))
	self:DrawModel()
end
language.Add(ENT.ClassName, ENT.PrintName)