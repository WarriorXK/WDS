
WDS2 = WDS2 or {}
WDS2.NextThink = 0
WDS2.ModelInfo = {}
WDS2.DyingProps = {}
WDS2.MaterialInfo = {}
WDS2.ProtectedClasses = {
							"soundent",
							"player_manager",
							"bodyque",
							"ai_network",
							"info_player_start",
							"predicted_viewmodel",
							"scene_manager",
							"prop_combine_ball",
							"crossbow_bolt"
						}

WDS2.MaxEntityHealth = 10000000
WDS2.EntityDefaultHealth = 500
WDS2.ForceResources = false

function WDS2.InitProp(ent, health, armor, armortype)

	ent.WDS2 = {}
	if !WTib.IsValid(ent) then
	
		ent.WDS2.MaxHealth = 1
		ent.WDS2.Health = 1
		
		ent.WDS2.ArmorType = 1
		ent.WDS2.Armor = 1
		
		ent.WDS2.Immune = true
		ent.WDS2.Dead = false
		
	else
	
		ent.WDS2.MaxHealth = type(health) == "number" and health or WDS2.CalcMaxHealth(ent)
		ent.WDS2.Health = ent.WDS2.MaxHealth
		
		ent.WDS2.ArmorType = type(armortype) == "string" and armor or WDS2.CalcArmorType(ent)
		ent.WDS2.Armor = type(armor) == "number" and armor or WDS2.CalcArmor(ent)
		
		ent.WDS2.Immune = false
		ent.WDS2.Dead = false
		
	end
	
end

function WDS2.CalcMaxHealth(ent)

	local Tab = WDS2.ModelInfo[ent:GetModel()]
	if Tab and Tab.maxhealth then return math.max(tonumber(Tab.maxhealth), 1) end
	
	local Health = WDS2.EntityDefaultHealth
	local PhysObj = ent:GetPhysicsObject()
	
	if PhysObj:IsValid() then
		local MatStrength = 1
		local Mat = PhysObj:GetMaterial()
		
		if WDS2.MaterialInfo[Mat] then MatStrength = WDS2.MaterialInfo[Mat] end
		
		Health = math.ceil(PhysObj:GetMass()*MatStrength)
	end
	return math.min(Health, WDS2.MaxEntityHealth)
	
end

function WDS2.CalcArmorType(ent)
	local Tab = WDS2.ModelInfo[ent:GetModel()]
	if Tab and Tab.armortype and (Tab.armortype == "AP" or Tab.armortype == "AT" or Tab.armortype == "SH") then
		return Tab.armortype
	elseif ent:IsPlayer() or ent:IsNPC() then
		return "AP"
	end
	return "AT"
end

function WDS2.CalcArmor(ent)
	local Mat = "none"
	if ent:GetPhysicsObject() and ent:GetPhysicsObject():IsValid() then Mat = ent:GetPhysicsObject():GetMaterial() end
	local Tab = WDS2.ModelInfo[Mat]
	
	if Tab and Tab.Armor then return math.max(tonumber(Tab.Armor), 1) end
	
	WDS2.Log("New Material found : "..tostring(Mat))
	
	return 1 // Todo : Maybe a formula of sorts?
end

function WDS2.DealDirectDamage(ent, dmg, typ)

	if !WDS2.CanDamageEntity(ent) or ent.WDS2.Dead then return end

	if typ != "AT" and typ != "AP" and typ != "SH" then typ = "AT" end

	local HookCall = hook.Call("WDS2_EntityShouldTakeDamage", GAMEMODE, ent, dmg, typ)
	if HookCall != nil then if !tobool(HookCall) then return end end
	
	WDS2.Debug.Print("Damaging \""..tostring(ent).."\" with "..tostring(dmg).." "..tostring(typ).." damage against "..tostring(WDS2.GetArmorType(ent)))

	ent.WDS2.Health = math.max(ent.WDS2.Health - (dmg * WDS2.CalculateDamageMul(typ, ent)), 0)
	
	WDS2.CheckProp(ent)
	
end

function WDS2.CalculateDamageMul(typ, ent)
	
	local ArmTyp = WDS2.GetArmorType(ent)

	if typ == "AT" then
	
		if ArmTyp == "AP" then
			return 1
		elseif ArmTyp == "SH" then
			return 0.5
		elseif ArmTyp == "AT" then
			return 1
		end
		
	elseif typ == "AP" then
	
		if ArmTyp == "AP" then
			return 2
		elseif ArmTyp == "SH" then
			return 0.7
		elseif ArmTyp == "AT" then
			return 0.5
		end
		
	elseif typ == "SH" then
	
		if ArmTyp == "AP" then
			return 0.1
		elseif ArmTyp == "SH" then
			return 1.2
		elseif ArmTyp == "AT" then
			return 0
		end
		
	end
	
	return 1
	
end

function WDS2.CheckProp(ent)

	if WDS2.GetHealth(ent) <= 0 and !ent.WDS2.Dead and !ent.WDS2.Immune then
	
		WDS2.Debug.Print("Ent " .. tostring(ent) .. " died")
		
		if hook.Call("WDS2_EntityDied", GAMEMODE, e, d) != false then
		
			WDS2.PropDeath(ent,typ)
			
		end
		
	end
	
end

function WDS2.CanDamageEntity(e)

	if !WDS2.IsValid(e) then return false end
	
	local Class = e:GetClass()
	if table.HasValue(WDS2.ProtectedClasses,Class) then return false end

	local HookCall = hook.Call("WDS2_EntityCanTakeDamage",GAMEMODE,e)
	if HookCall != nil then return tobool(HookCall) end
	
	return (!e.WDS2.Immune and !e:IsPlayer() and !e:IsNPC() and !e.IsVehicle() and string.find(Class,"func_") != 1 and !e.ProtectedEntity)
	
end

function WDS2.IsValid(e)

	if !IsValid(e) then return false end
	if !WDS2.EntHasValidTable(e) then WDS2.InitProp(e) end
	
	return true
	
end

function WDS2.EntHasValidTable(e)
	return type(e.WDS2) == "table" and type(e.WDS2.MaxHealth) == "number" and type(e.WDS2.Health) == "number" and type(e.WDS2.Armor) == "number" and type(e.WDS2.ArmorType) == "string"
end

function WDS2.PropDeath(ent)

	if WDS2.EntHasValidTable(ent) then ent.WDS2.Dead = true end
	
	ent:GetPhysicsObject():EnableGravity(false)
	ent:GetPhysicsObject():EnableMotion(true)
	
	constraint.RemoveAll(ent)
	
	table.insert(WDS2.DyingProps, ent)
	
end

function WDS2.GetHealth(ent)

	if !ent.WDS2 then WDS2.InitProp(ent) end
	
	return ent.WDS2.Health
	
end

function WDS2.GetMaxHealth(ent)

	if !ent.WDS2 then WDS2.InitProp(ent) end
	
	return ent.WDS2.MaxHealth
	
end

function WDS2.GetArmorType(ent)

	if !ent.WDS2 then WDS2.InitProp(ent) end
	
	return ent.WDS2.ArmorType
	
end

function WDS2.CreateExplosion(pos, rad, dmg, dealer, dmgtype)

	local filt = type(dealer) == "table" and dealer or {dealer}
	
	for _,targ in pairs(ents.FindInSphere(pos, rad)) do
	
		if !table.HasValue(filt, targ) then
		
			WDS2.DealDirectDamage(targ, dmg * math.Clamp(-((pos:Distance(targ:NearestPoint(pos)) / rad) - 1), 0.2, 1), dmgtype)
			
		end
		
	end
	
end

function WDS2.Log(str)

	local File = "WDS/LogFile.txt"
	local strOut = str.."\n"
	
	if file.Exists(File, "DATA") then
	
		file.Append(File,strOut)
		
	else
	
		file.Write(File,strOut)
		
	end
	
end

function WDS2.Init()

	print("============ WDS2 - Loading Files ============\n")

	if !file.IsDir("WDS","DATA") then file.CreateDir("WDS") end
	
	print("\tLoading models data")
	
	local path = "WDS/Models"
	local base = "DATA"
	
	if file.IsDir(path, base) then
	
		for _,fil in pairs(file.Find(path.."/*", base)) do
		
			WDS2.Debug.Print("\t\t- Loading file '"..tostring(fil).."'")
			
			for k,v in pairs(util.KeyValuesToTable(file.Read(path.."/"..fil, base))) do
			
				WDS2.ModelInfo[k] = v
				
			end
			
		end
		
	else
	
		file.CreateDir(path)
		
	end
	
	print("\n\tLoading materials data")
	
	path = "WDS/Materials"
	base = "DATA"
	
	if file.IsDir(path, base) then
	
		for _,fil in pairs(file.Find(path.."/*", base)) do
		
			WDS2.Debug.Print("\t\t- Loading file '"..tostring(fil).."'")
			
			for k,v in pairs(util.KeyValuesToTable(file.Read(path.."/"..fil, base))) do
			
				WDS2.MaterialInfo[k] = v
				
			end
			
		end
		
	else
	
		file.CreateDir(path)
		
	end
	
	if WDS2.ForceResources then
	
		print("\tForce resources enabled, loading files")
		
		path = "materials/wds"
		if file.IsDir(path, "GAME") then
			WDS2.AddResourceDir(path, "GAME")
		end
		
		path = "models/wds"
		if file.IsDir(path, "GAME") then
			WDS2.AddResourceDir(path, "GAME")
		end
		
		path = "sound/wds2"
		if file.IsDir(path, "GAME") then
			WDS2.AddResourceDir(path, "GAME")
		end
		
	else
	
		print("\n\tForce resources disabled, not adding files.")
		
	end
	
	print("\n============ WDS2 - Files loaded =============")
	
end

function WDS2.AddResourceDir(path, base)

	for _,fil in pairs(file.Find(path.."/*", base)) do
	
		local Fi = path.."/"..fil
		if file.IsDir(Fi, base) then
		
			WDS2.AddResourceDir(Fi, base)
			
		else
		
			WDS2.Debug.Print("\t\t"..tostring(Fi))
			resource.AddSingleFile(Fi)
			
		end
		
	end
	
end

WDS2.Init()

function WDS2.Think()

	if WDS2.NextThink > CurTime() then return end
	
	WDS2.NextThink = CurTime() + 0.015
	
	for k,v in pairs(WDS2.DyingProps) do
	
		if IsValid(v) then
		
			v:SetRenderMode(RENDERMODE_TRANSCOLOR)
			
			local C = v:GetColor()
			v:SetColor(Color(C.r,C.g,C.b,C.a-1))
			
			if C.a-2 <= 0 then
			
				v:Remove()
				WDS2.DyingProps[k] = nil
				
			end
			
		else
		
			WDS2.DyingProps[k] = nil
			
		end
	end
	
end
hook.Add("Think","WDS2.Think",WDS2.Think)

hook.Add("PlayerSpawn", "WDS2.PlayerSpawn", function(ply) ply:Extinguish() end)

/*
timer.Create( "WDS2_Tags", 10, 0, function()

	local TagToAdd = "WDS2"
	local tags = GetConVarString("sv_tags")
	
	if (!tags:find( TagToAdd )) then
		RunConsoleCommand( "sv_tags", tags .. "," .. TagToAdd )
	end
	
end)
*/