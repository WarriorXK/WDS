AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

SWEP.NextPlacement	= 0
SWEP.PlaceSound		= Sound("Metal.SawbladeStick")

function SWEP:PrimaryAttack()
	self.Owner.WDSMineTable = self.Owner.WDSMineTable or {}
	local tr = WDS.EyeTrace(self.Owner)
	if tr.Hit and tr.Entity:IsWorld() and self.Owner:EyePos():Distance(tr.HitPos) <= 90 and self.NextPlacement <= CurTime() and self:GetMineCount() <= 20 then
		self.NextPlacement = CurTime()+1
		self:EmitSound(self.PlaceSound)
		local ed = EffectData()
			ed:SetOrigin(tr.HitPos)
			ed:SetNormal(tr.HitNormal)
			ed:SetMagnitude(4)
			ed:SetScale(1)
			ed:SetRadius(8)
		util.Effect("Sparks",ed)
		local ent = ents.Create("wds_projectile_apmine")
		local ang = tr.HitNormal:Angle()
		ang:RotateAroundAxis(ang:Right(),-90)
		ent:SetAngles(ang)
		ent:SetPos(tr.HitPos)
		ent.WDSO = self.Owner
		ent:Spawn()
		ent:Activate()
		table.insert(self.Owner.WDSMineTable,ent)
	end
end

function SWEP:GetMineCount()
	self.Owner.WDSMineTable = self.Owner.WDSMineTable or {}
	local a = 0
	for k,v in pairs(self.Owner.WDSMineTable) do
		if v and v:IsValid() then
			a = a + 1
		else
			self.Owner.WDSMineTable[k] = nil
		end
	end
	return a
end

function SWEP:SecondaryAttack() end

function SWEP:Reload() end

function SWEP:Think() end

function SWEP:ShouldDropOnDie()
	return true
end
