
EFFECT.Material = Material("wds/effects/shieldhit")

function EFFECT:Init(data)
	self.ShieldEntity = data:GetEntity()
	self.HitPos = data:GetOrigin()
	self.Size = data:GetScale()
	self.Normal = (self.ShieldEntity:GetPos()-self.HitPos):Normalize()
	self.Alpha = 255
	self.Entity:SetPos(self.HitPos)
end 

function EFFECT:Think()
	if !self.ShieldEntity or !self.ShieldEntity:IsValid() then return false end
	self.Alpha = self.Alpha-0.01
	self.Size = self.Size * 0.99
	return self.Alpha >= 0
end 

function EFFECT:Render()
	self.Material:SetMaterialVector("$color",Vector(0,50,100))
	self.Material:SetMaterialFloat("$alpha",self.Alpha)
	render.SetMaterial(self.Material)
	render.DrawQuadEasy(self.Entity:GetPos(),self.Normal	,self.Size,self.Size*-1)
	render.DrawQuadEasy(self.Entity:GetPos(),self.Normal*-1	,self.Size,self.Size*-1)
	self.Material:SetMaterialVector("$color",Vector(255,255,255))
end
