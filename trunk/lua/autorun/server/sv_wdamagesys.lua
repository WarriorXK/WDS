
WDS = WDS or {}
WDS.FadingEntities = {}

WDS.Config = {}
WDS.Config.MaxHealth = 10000
WDS.Config.ModelHealth = {} // Contains preset health of specific models.
WDS.Config.MaterialStrength =	{ // Contains the strength of all the known materials.
									canister = 1.5,
									carpet = 1,
									combine_metal = 2.2,
									combine_glass = 1.7,
									cardboard = 0.6,
									concrete = 2.5,
									concrete_block = 2.5,
									chainlink = 1.5,
									default = 1,
									dirt = 1,
									flesh = 0.9,
									floating_metal_barrel = 1,
									glass = 0.7,
									gmod_ice = 1,
									gmod_bouncy = 0.9,
									ice = 1,
									metal = 2,
									metal_barrel = 1,
									metal_bouncy = 2,
									metalpanel = 1.3,
									metalvent = 0.6,
									paper = 0.3,
									paintcan = 0.9,
									popcan = 0.5,
									porcelain = 0.8,
									plastic = 0.8,
									plastic_barrel = 0.8,
									player = 0.9,
									rubber = 0.9,
									rubbertire = 1.1,
									solidmetal = 1.7,
									slipperyslime = 1,
									wood = 0.7,
									wood_crate = 0.7,
									wood_furniture = 0.7,
									wood_panel = 1.1,
									wood_solid = 1.2,
									zombieflesh = 1
								}

/*
	WDS Core functions
	
	Here are the most basic functions used in WDS.
*/

function WDS.InitEntity(ent)
	ent.DamageSystem = ent.DamageSystem or {}
	ent.DamageSystem.MaxHealth	= math.Clamp(WDS.CalculateMaxHealth(ent),1,WDS.Config.MaxHealth)
	ent.DamageSystem.Health		= ent.DamageSystem.MaxHealth
	ent.DamageSystem.Dead		= true
end

function WDS.CalculateMaxHealth(ent)
	local Phys = ent:GetPhysicsObject()
	return math.Round(WDS.Config.ModelHealth[ent] or math.Clamp(Phys:GetMass(),1,5000)*(WDS.Config.MaterialStrength[Phys:GetMaterial()] or 1))
end

function WDS.TakeDamage(ent,dmg)
	if ent:IsWorld() or ent:IsVehicle() or string.find(ent:GetClass(),"func_") == 1 or !ent:IsValid() or !ent:GetPhysicsObject():IsValid() then return end
	if !ent.DamageSystem then WDS.InitEntity(ent) end
	local Call = hook.Call("WDS_EntityTakeDamage",GAMEMODE,ent,dmg)
	if Call != nil and !tobool(a) then return end
	ent.DamageSystem.Health = ent.DamageSystem.Health-dmg
	if ent.DamageSystem.Health <= 0 then
		WDS.KillEnt(ent)
	end
end

function WDS.KillEnt(ent) -- Destroys an entity with a effect, Format : Entity, Returns if the entity is destroyed with an custom function.
	if !ent.DamageSystem then WDS.InitEntity(ent) end
	if ent.DamageSystem.Health >= 1 then ent.DamageSystem.Health = 0 end
	ent.DamageSystem.Dead = true
	local Call = hook.Call("WDS_EntityDeath",GAMEMODE,ent)
	if Call != nil and !tobool(a) then return end
	if ent:GetClass() == "prop_ragdoll" then
		ent:SetSolid(COLLISION_GROUP_DEBRIS)
		return
	else
		if ent:GetClass() != "prop_physics" and ent:GetClass() != "prop_physics_multiplayer" then
			local DeadEnt = ents.Create("prop_physics")
			DeadEnt:SetModel(ent:GetModel())
			DeadEnt:SetSkin(ent:GetSkin())
			DeadEnt:SetMaterial(ent:GetMaterial())
			DeadEnt:SetPos(ent:GetPos())
			DeadEnt:SetAngles(ent:GetAngles())
			DeadEnt:SetColor(ent:GetColor())
			ent:Remove()
			DeadEnt:Spawn()
			DeadEnt:Activate()
			DeadEnt:SetSolid(COLLISION_GROUP_DEBRIS)
			local phys = DeadEnt:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(true)
				phys:EnableGravity(false)
			end
			WDS.AddFadingEntity(DeadEnt)
		else
			ent:SetSolid(COLLISION_GROUP_DEBRIS)
			constraint.RemoveAll(ent)
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(true)
				phys:EnableGravity(false)
			end
			WDS.AddFadingEntity(ent)
		end
	end
	return
end

/*
	WDS User functions
	
	Here are the functions that are non-essential to WDS but are still very useful.
*/

function WDS.TakeExDamage(ent,dmg,att,inf)
	if (ent:IsPlayer() and ent:Alive()) or ent:IsNPC() then
		ent:TakeDamage(dmg,att,inf)
	elseif ent:GetClass() == "shield" then
		ent:Hit(inf,(ent:GetPos()-inf:GetPos()):Angle():GetNormal(),inf:GetPos(),dmg)
	else
		WDS.TakeDamage(ent,dmg)
	end
end

function WDS.AttackTrace(st,en,fl,dmg,rad,att,inf)
	local tr = WDS.TraceLine(st,en,fl)
	if tr.Hit then
		if rad > 0 then
			WDS.Explosion(tr.HitPos,rad,dmg,{},att,inf)
		else
			if tr.HitShield then
				tr.Entity:Hit(inf,tr.HitNormal,tr.HitPos,dmg/3,-1*tr.HitNormal)
				return
			end
			WDS.TakeExDamage(tr.Entity,dmg,att,inf)
		end
	end
	return tr
end

function WDS.Explosion(pos,rad,dmg,fl,att,inf,trc)
	fl = fl or {}
	for _,v in pairs(ents.FindInSphere(pos,rad)) do
		if !table.HasValue(fl,v) then
			local t
			if trc then
				t = WDS.TraceLine(pos,v:GetPos(),(fl or {}))
			end
			local dam = dmg-math.Round((dmg/100)*(v:GetPos():Distance(pos)/rad)*100)
			print(v,t and t.Entity or nil, dam)
			if dam <= 0 then dam = 1 end
			if v and v:IsValid() then
				local Val = false
				if trc then
					Val = t.Entity == v
				else
					Val = true
				end
				if Val then WDS.TakeExDamage(v,dam,att,inf) end
			end
		end
	end
end

/*
	WDS Side functions
	
	Functions that are somewhat unrelated to WDS.
*/

function WDS.AddFadingEntity(ent)
	if !table.HasValue(WDS.FadingEntities,ent) then
		table.insert(WDS.FadingEntities,ent)
	end
end

timer.Create("WDS_FadingEntityCheck",0.05,0,function()
	for k,v in pairs(WDS.FadingEntities) do
		if v and v:IsValid() then
			local r,g,b,a = v:GetColor()
			if a <= 1 then
				v:Remove()
				WDS.FadingEntities[k] = nil
			else
				v:SetColor(r,g,b,a-3)
			end
		else
			WDS.FadingEntities[k] = nil
		end
	end
end)
