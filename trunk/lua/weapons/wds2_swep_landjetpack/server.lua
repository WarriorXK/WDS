
local VectForward = Vector(1,0,0)

WDS2.Jetpack = {}
WDS2.Jetpack.AreAllowed = true
WDS2.Jetpack.MaxEnergy = 80
WDS2.Jetpack.EnergyUse = 5
WDS2.Jetpack.EnergyRegeneration = 5

function WDS2.ConsoleCommandJetpackAllowed(ply, command, args)
	if !ply:IsAdmin() then
		ply:ChatPrint("This console command is only for administrators!")
		return
	else
		WDS2.Jetpack.AreAllowed = tobool(args[1])
		
		local status = "disabled"
		
		if WDS2.Jetpack.AreAllowed then
			status = "enabled"
		end
		
		for _,v in pairs(player.GetAll()) do
			v:ChatPrint("The spawning of WDS jetpacks is now "..status.."!")
		end
	end
end
concommand.Add("wds2_jetpacksallowed",WDS2.ConsoleCommandJetpackAllowed)

function WDS2.ConsoleCommandJetpackMaxEnergy(ply, command, args)
	if !ply:IsAdmin() then
		ply:ChatPrint("This console command is only for administrators!")
		return
	else
		
		WDS2.Jetpack.MaxEnergy = tonumber(args[1])
		
		for _,v in pairs(player.GetAll()) do
			v:ChatPrint("WDS Jetpacks now have a max charge of "..WDS2.Jetpack.MaxEnergy.."!")
		end
	end
end
concommand.Add("wds2_jetpackmaxenergy",WDS2.ConsoleCommandJetpackMaxEnergy)

function WDS2.ConsoleCommandJetpackEnergyUse(ply, command, args)
	if !ply:IsAdmin() then
		ply:ChatPrint("This console command is only for administrators!")
		return
	else
		WDS2.Jetpack.EnergyUse = tonumber(args[1])
		
		for _,v in pairs(player.GetAll()) do
			v:ChatPrint("WDS jetpacks now use "..tostring(WDS2.Jetpack.EnergyUse).." energy per second!")
		end
	end
end
concommand.Add("wds2_jetpackenergyuse",WDS2.ConsoleCommandJetpackEnergyUse)

function WDS2.ConsoleCommandJetpackEnergyRegeneration(ply, command, args)
	if !ply:IsAdmin() then
		ply:ChatPrint("This console command is only for administrators!")
		return
	else
		WDS2.Jetpack.EnergyRegeneration = tonumber(args[1])
		
		for _,v in pairs(player.GetAll()) do
			v:ChatPrint("WDS jetpacks now regenerate "..tostring(WDS2.Jetpack.EnergyRegeneration).." energy per second!")
		end
	end
end
concommand.Add("wds2_jetpackenergyregeneration",WDS2.ConsoleCommandJetpackEnergyRegeneration)

function WDS2.JetpackLimit(ply,class,wep)
	if class == "wds2_swep_landjetpack" and !WDS2.Jetpack.AreAllowed then
		return false
	end
end
hook.Add("PlayerSpawnSWEP","WDS2.JetpackLimitSpawn",WDS2.JetpackLimit)
hook.Add("PlayerGiveSWEP","WDS2.JetpackLimitGive",WDS2.JetpackLimit)

function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
	self.Owner:DrawWorldModel(true)
end

function SWEP:Think()
	if self.Owner:KeyDown(IN_JUMP) and self.Owner:GetMoveType() != MOVETYPE_NOCLIP then
		if self.dt.JetCharge >= (WDS2.Jetpack.EnergyUse / 10) then
			if self.NextJump <= CurTime() then
				self.Owner:SetLocalVelocity(self.Owner:GetVelocity()+(self.Owner:GetUp() * 80))
				self.dt.JetCharge = self.dt.JetCharge - (WDS2.Jetpack.EnergyUse / 10)
				self.NextJump = CurTime()+0.1
				if SERVER then
					if !self.Owner.WDS2_JetpackEffect then
						local ed = EffectData()
							ed:SetEntity(self.Owner)
						util.Effect("wds2_landjetpack_trail",ed)
						self.Owner.WDS2_JetpackEffect = true
					end
				end
			end
			self.dt.Flying = true
		else
			self.dt.Flying = false
		end
	else
		self.dt.Flying = false
	end
	if !self.dt.Flying and self.dt.JetCharge < WDS2.Jetpack.MaxEnergy and self.NextCharge <= CurTime() and !self.Owner:KeyDown(IN_JUMP) then
		self.dt.JetCharge = self.dt.JetCharge + (WDS2.Jetpack.EnergyRegeneration / 10)
		self.NextCharge = CurTime()+0.1
	end
end

function SWEP.WDS_LJ_PlayerSpawn(ply)
	ply.WDS2_JetpackEffect = false
end
hook.Add("PlayerSpawn","SWEP.WDS_LJ_PlayerSpawn",SWEP.WDS_LJ_PlayerSpawn)
