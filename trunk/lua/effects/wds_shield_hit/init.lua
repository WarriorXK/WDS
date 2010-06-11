
EFFECT.Material = Material("wds/effects/shieldhit")
EFFECT.Min = 0.1

function EFFECT:Init(data)
	self.Shield = data:GetEntity()
	self.HitPos = data:GetOrigin()
	self.Normal = data:GetNormal()
	self.Size = data:GetScale()*50
	self.Alpha = 255
	self.Entity:SetPos(self.HitPos)
	self.Entity:SetParent(self.Shield)
end 

function EFFECT:Think()
	if !ValidEntity(self.Shield) then return false end
	self.Alpha = self.Alpha-0.01
	self.Min = self.Min+0.003
	self.Size = self.Size*(0.99-self.Min)
	return self.Alpha >= 0 and self.Size >= 0
end 

function EFFECT:Render()
	self.Material:SetMaterialVector("$color",Vector(0,50,100))
	self.Material:SetMaterialFloat("$alpha",self.Alpha)
	render.SetMaterial(self.Material)
	render.DrawQuadEasy(self.Entity:GetPos(),self.Normal	,self.Size,self.Size*-1)
	render.DrawQuadEasy(self.Entity:GetPos(),self.Normal*-1	,self.Size,self.Size*-1)
	self.Material:SetMaterialVector("$color",Vector(255,255,255))
end
