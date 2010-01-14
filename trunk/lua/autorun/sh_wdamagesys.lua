
WDS = WDS or {}

function WDS.EyeTrace(ply)
	if WLib then return WLib.EyeTrace(ply) end
	return WDS.TraceLine(ply:GetShootPos(),ply:GetShootPos()+ply:GetAimVector()*10000,{ply,ply:GetActiveWeapon()})
end

function WDS.TraceLine(st,en,fl)
	if WLib then return WLib.Trace(st,en,fl) end
	if StargateExtras then
		return StargateExtras:ShieldTrace(st,en-st,fl)
	elseif StarGate then
		return StarGate.Trace:New(st,en-st,fl)
	end
	return util.QuickTrace(st,en-st,fl)
end

hook.Add("PhysgunPickup","WDS.PhysgunPickup",function(ply,ent)
	if ent.NoPhysgunPickup then return false end
end)
