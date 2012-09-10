AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ChargeSound = Sound("wds2/weapons/tankmine/charge.wav")
ENT.AttachSound = ""

ENT.IsBeingHeld = false
ENT.IsExploding = false
ENT.HasAttached = false
ENT.Constrained = false
ENT.IsArmed = false

ENT.RopePorts =	{
					Vector(2.4,0,-3.3967),
					Vector(2.4,0,-1.1044),
					Vector(2.4,0,1.1044),
					Vector(2.4,0,3.3967),
					
					Vector(-2.4,0,-3.3967),
					Vector(-2.4,0,-1.1044),
					Vector(-2.4,0,1.1044),
					Vector(-2.4,0,3.3967)
				}

function ENT:Initialize()

	self:SetModel("models/wds/device21.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	
end

function ENT:SpawnFunction(p,t)

	if !t.Hit then return end
	
	local e = ents.Create(self.ClassName)
	e.WDSO = p
	e:Spawn()
	e:Activate()
	e:SetPos(t.HitPos+t.HitNormal*-e:OBBMins().z)
	e.ChargeSound = CreateSound(e,"wds2/weapons/tankmine/charge.wav")
	e.ChargeSound:ChangeVolume(10)
	return e
	
end

function ENT:Use(ply)
	if ply:IsPlayer() then
		self:Arm(ply)
	end
end

function ENT:Think()

	if self.HasAttached and ValidEntity(self.AttachedEnt) then
	
		if self.AttachTime + 2 <= CurTime() and !self.Constrained then
		
			if !self.AttachedEnt:IsPlayer() and !self.AttachedEnt:IsNPC() then // Until I find out how to constrain players and NPCs to their spot.
			
				for _, v in pairs(self.RopePorts) do
				
					local pos = self:GetPos()
					local tr = {}
					tr.start = pos
					tr.endpos = Vector((pos.x + math.random(-400, 400)),(pos.y + math.random(-400, 400)),(pos.z + math.random(-400, 400)))
					tr.filter = self
					tr = util.TraceLine(tr)
					if tr.Hit then
						constraint.Rope(tr.Entity, self, tr.PhysicsBone, 0, tr.Entity:WorldToLocal(tr.HitPos), v, pos:Distance(tr.HitPos) + 10, 0, 0, 3, "cable/physbeam", false)
					end
					
				end
				
			end
			
			self.ChargeSound:Play()
			self.Constrained = true
			
		end
		
		if self.AttachTime+15 <= CurTime() then
		
			self:Explode()
			return
			
		end
		
	end
	
end

function ENT:OnRemove()
	self.ChargeSound:Stop()
end

function ENT:Explode()

	self.IsExploding = true

	local EffectBall = ents.Create("prop_combine_ball")
	EffectBall:SetPos(self.Entity:GetPos())
	EffectBall:Spawn()
	EffectBall:Fire("explode","",0)
	EffectBall:Fire("kill","", 0)
	
	local DmgInfo = DamageInfo()
	DmgInfo:SetAttacker(self.WDSO)
	DmgInfo:SetInflictor(self)
	DmgInfo:SetDamageType(DMG_DISSOLVE)
	
	local Damage = 400
	
	WDS2.CreateExplosion(self:GetPos(),350,math.random(400,500),self)
	
	for _,ply in pairs(ents.FindInSphere(self:GetPos(), 350)) do
	
		if ply:IsPlayer() or ply:IsNPC() then
		
			DmgInfo:SetDamage(math.Clamp(Damage*-((self:GetPos():Distance(ply:GetPos())/350)-1),5,Damage))
			ply:TakeDamageInfo(DmgInfo)
			
		elseif ply:GetClass() == self.ClassName then
		
			if ply.IsArmed and ply != self and !ply.IsExploding then
				ply:Explode()
			end
			
		end
		
	end
	
	self:Remove()
	return
	
end

function ENT:Arm(ply)

	if !self.IsArmed then
	
		self:SetSkin(1)
		self.IsArmed = true
		self.WDSO = ply
		
	end
	
end

function ENT:Touch(ent)

	if self.IsArmed and !self.HasAttached and !self.IsBeingHeld then
	
		self:EmitSound(self.AttachSound)
	
		self.HasAttached = true
		self.AttachedEnt = ent
		
		constraint.Weld(self,ent,0,0,0,true)
		
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		
		self.AttachTime = CurTime()
		self:SetDTFloat(0, self.AttachTime)
		
	end
	
end

function WDS2_Tankmine_Pickup(ply, ent)

	if ent:GetClass() == "wds2_tool_tankmine" and ply:IsPlayer() then
	
		ent.IsBeingHeld = true
		ent:Arm(ply)
		
	end
	
end
hook.Add("GravGunOnPickedUp","WDS2_Tankmine_Pickup",WDS2_Tankmine_Pickup)

function WDS2_Tankmine_Pickup(ply,ent)

	if ent:GetClass() == "wds2_tool_tankmine" and ply:IsPlayer() then
	
		ent.IsBeingHeld = false
		
	end
	
end
hook.Add("GravGunOnDropped","WDS2_Tankmine_Pickup",WDS2_Tankmine_Pickup)
