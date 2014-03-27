
if SERVER then
	AddCSLuaFile("sh_wds2.lua")
end

WDS2 = WDS2 or {}
WDS2.Debug = {}
WDS2.Debug.Enabled = game.SinglePlayer()
WDS2.NoProjectileTouch =	{
								wds2_weapon_duallaserturret = "wds2_projectile_duallaser",
								wds2_weapon_flamethrower = "wds2_projectile_fireball",
								wds2_weapon_flamethrower = "wds2_projectile_flame",
								wds2_weapon_lasermissile = "wds2_projectile_lasermissile",
								wds2_weapon_plasmacharger = "wds2_projectile_plasmacharger",
								wds2_weapon_smalltankcannon = "wds2_projectile_smalltankcannon"
							}

// There are here to make things a bit more friendly for the garbage collector
WDS2.ZeroVector = Vector(0,0,0)
WDS2.ZeroAngle = Angle(0,0,0)

function WDS2.GetEntityBounds(ent)
	local maxs = ent:OBBMaxs()
	local mins = ent:OBBMins()
	return {
			mins,
			Vector(maxs.x,mins.y,mins.z),
			Vector(mins.x,maxs.y,mins.z),
			Vector(mins.x,mins.y,maxs.z),
			maxs,
			Vector(mins.x,maxs.y,maxs.z),
			Vector(maxs.x,mins.y,maxs.z),
			Vector(maxs.x,maxs.y,mins.z)
		}
end

function WDS2.TraceLine(spos,epos,fl,msk) // Todo : Add shield support?
	return util.TraceLine({start = spos,endpos = epos,filter = fl,mask = msk or ""})
end

function WDS2.EyeTrace(p)
	return WDS2.TraceLine(ply:GetShootPos(),ply:GetShootPos()+ply:GetAimVector()*10000,{ply,ply:GetActiveWeapon()})
end

function WDS2.Debug.Print(...)
	if WDS2.Debug.Enabled then print(...) end
end

function WDS2.Debug.PrintTable(...)
	if WDS2.Debug.Enabled then PrintTable(...) end
end

function WDS2.PhysgunPickup(ply,ent)
	if SERVER then
		if !ent.WDS2 then
			local succ, err = pcall(WDS2.InitProp, ent)
			if !succ then ErrorNoHalt("WDS2.PhysgunPickup failed : '" .. tostring(err) .. "' on ent '" .. tostring(ent) .. "'") end
		end
		if ent.WDS2.Dead then return false end
	end
	if ent.NoPhysgunPickup then return false end
end
hook.Add("PhysgunPickup","WDS2.PhysgunPickup",WDS2.PhysgunPickup)

function WDS2.GravGunPickup(ply, ent)
	if !IsValid(ent) then return end
	if SERVER then
		if !ent.WDS2 then
			local succ, err = pcall(WDS2.InitProp, ent)
			if !succ then ErrorNoHalt("WDS2.NoGravGunPickup failed : '" .. tostring(err) .. "' on ent '" .. tostring(ent) .. "'") end
		end
		if ent.WDS2.Dead then return false end
	end
	if ent.NoGravGunPickup then return false end
end
hook.Add("GravGunPickupAllowed","WDS2.GravGunPickup",WDS2.GravGunPickup)

function WDS2.ShouldCollide(e1,e2)
	if WDS2.NoProjectileTouch[e1:GetClass()] == e2:GetClass() or WDS2.NoProjectileTouch[e2:GetClass()] == e1:GetClass() then return false end
end
hook.Add("ShouldCollide","WDS2.ShouldCollide",WDS2.ShouldCollide)
