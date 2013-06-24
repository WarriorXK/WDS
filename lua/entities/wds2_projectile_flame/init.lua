AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.NextDamage = 0

function ENT:Initialize()

	self:SetModel("models/wds/pball.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetVelocityInstantaneous(self:GetForward() * (2000 + math.random(-50, 50)))
	end
	
	local ed = EffectData()
		ed:SetEntity(self)
	util.Effect("wds2_flamethrower_flame",ed,true,true)
	
	self.DeathTime = CurTime() + math.Rand(0.7,0.8)
	self.CreationTime = CurTime()
	self.ImmuneToFire = true
	
end

function ENT:Think()
	if self.NextDamage <= CurTime() then
		local Rad = 13 * math.Max(15 * (CurTime() - self.CreationTime), 1)
		if Rad < 20 then Rad = 20 end
		
		local Pos = self:GetPos()
		local Dmg = 20

		local DmgInfo = DamageInfo()
		DmgInfo:SetAttacker(self.WDSO)
		DmgInfo:SetInflictor(IsValid(self.Cannon) and self.Cannon or self)
		DmgInfo:SetDamageType(DMG_BURN)
		
		for _,v in pairs(ents.FindInSphere(self:GetPos(), Rad)) do
			if v != self then
				if !v.ImmuneToFire then
					if (v:IsPlayer() and v:Alive()) or v:IsNPC() then
						local Mul = math.Clamp(-((Pos:Distance(v:GetPos())/Rad)-1),0.2,1)
						DmgInfo:SetDamage(Dmg * Mul)
						v:TakeDamageInfo(DmgInfo)
						if math.random(1,3) == 2 then print(v:Ignite(30)) end
						print(Rad)
					else
						// Entitys take damage here.
					end
				end
			end
		end
		self.NextDamage = CurTime() + 0.05
	end
	
	if self.DeathTime < CurTime() then
		self:Die()
		return
	end
	
	self:NextThink(CurTime())
	return true
end

function ENT:Touch(ent)
	if IsValid(ent) and ent:GetClass() == "shield" then // Stargate shield Support
		self:Die()
	end
end

function ENT:PhysicsCollide(data,physobj)
	self:Die(data.HitEntity)
	return
end

function ENT:Die(ent)

	if IsValid(ent) then
	
		local DmgInfo = DamageInfo()
		DmgInfo:SetAttacker(IsValid(self.WDSO) and self.WDSO or self)
		DmgInfo:SetInflictor(IsValid(self.Cannon) and self.Cannon or self)
		DmgInfo:SetDamageType(DMG_BURN)
		DmgInfo:SetDamage(math.random(40,60))
		ent:TakeDamageInfo(DmgInfo)
		
	end
	
	local ed = EffectData()
		ed:SetOrigin(self:GetPos())
	util.Effect("wds2_flamethrower_death",ed)
	
	self:Remove()
end
