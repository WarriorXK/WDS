include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end
language.Add(ENT.ClassName, ENT.PrintName)
