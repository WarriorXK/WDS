
GCB_Override = true -- Should we load when GCombat is found?

function sv_GCWDSM_Load()
	if !SERVER then return end
	function cbt_register(e,h,a)
		return WDS2.InitProp(e)
	end
	function gcombat.registerent(e,h,a)
		return WDS2.InitProp(e)
	end
	function cbt_dealdevhit(e,d,p)
		WDS2.DealDirectDamage(e,d)
		if IsValid(e) and !e.WDS2.Dead then
			return 1
		end
		return 2
	end
	function gcombat.devhit(e,d,_)
		WDS2.DealDirectDamage(e,d)
		if e and e:IsValid() and !e.WDS2.Dead then
			return 1
		end
		return 2
	end
	function gcombat.hcgexplode(p,r,d,pir)
		WDS2.CreateExplosion(p,r,d,ents.FindInSphere(p,2))
	end
	function cbt_validate(e)
		return WDS2.IsValid(e)
	end
	function gcombat.validate(e)
		return WDS2.IsValid(e)
	end
	function gcombat.canhitent()
		return WDS2.CanDamageEntity(e)
	end
	function gcombat.addprotectedent(ent)
		if !IsValid(ent) then return end
		if type(ent.WDS2) != "table" then WDS2.InitProp(ent) end
		ent.WDS2.Immune = true
	end
	hook.Add("WDS2_EntityShouldTakeDamage","WDS2_GC_Module",function(ent,damage)
		if ent.gcbt_breakactions or ent.hasdamagecase then
			return false
		end
	end)
	function cbt_newexplode(p,r,d,pi,f)
		WDS2.CreateExplosion(p,r,d,ents.FindInSphere(p,1))
	end
	function cbt_breakent(e,d)
		return WDS2.PropDeath(e)
	end
	function cbt_shieldhit(sh,e,n,p,d)
		return
	end
	function cbt_addprotectedent(e)
		if !e then return false end
		if type(e) == "string" then
			table.insert(WDS2.ProtectedClasses,e)
		elseif IsValid(e) then
			table.insert(WDS2.ProtectedClasses,e:GetClass())
		end
	end
end

function GCWDSM_Load()
	function cbt_trace(s,e,f,m)
		return WDS2.TraceLine(spos,epos,fl)
	end
	function cbt_geteyetrace(p)
		return WDS2.EyeTrace(p)
	end
end

timer.Simple(1.1,function() // Making sure GCombat loads first
	if GCB_Override or COMBATDAMAGEENGINE == nil then
		if WDS2 then
			gcombat = gcombat or {}
			WDS2GCOMBATMODULE = 1
			COMBATDAMAGEENGINE = 1
			GCWDSM_Load()
			sv_GCWDSM_Load()
		else
			Error("Warning : WDS not found, GCombat/WDS module not loading!")
			return
		end
	end
end)
