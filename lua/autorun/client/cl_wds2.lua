
WDS2 = WDS2 or {}

WDS2.Convars = {}
WDS2.Convars.EnableDynamicLights = CreateClientConVar("wds2_dynamiclightsenabled",1,true,false)
WDS2.Convars.DynamicLightsSize = CreateClientConVar("wds2_dynamiclightssize",1,true,false)

function WDS2.AddClientMenu()
	spawnmenu.AddToolCategory("Options","WDS2 Options","WDS2 Options")
	spawnmenu.AddToolMenuOption("Options","WDS2 Options","GraphicalOptions","Graphical Options","","",WDS2.PopulateGraphicalOptions)
	spawnmenu.AddToolMenuOption("Options","WDS2 Options","AdministrativeOptions","Administrative Options","","",WDS2.PopulateAdminOptions)
end
hook.Add("AddToolMenuTabs","WDS2.AddClientMenu",WDS2.AddClientMenu)

function WDS2.PopulateGraphicalOptions(Panel)
	Panel:ClearControls()
	
	Panel:CheckBox("Show Dynamic Light","wds2_dynamiclightsenabled"):SetToolTip("This option enables or disables dynamic lights on certain WDS2 items and effects. Default : Checked")
	Panel:NumSlider("Dynamic Light Size", "wds2_dynamiclightssize", 0, 5, 1):SetToolTip("This option Specifies how large the dynamic lights should be. Default : 1")
end

function WDS2.PopulateAdminOptions(Panel)
	Panel:ClearControls()
	
	if LocalPlayer():IsAdmin() then
	
		// Jetpack options
		Panel:AddControl("Label",{Text="Jetpack options :"})
		Panel:CheckBox("Allow the use of jetpacks","wds2_jetpacksallowed"):SetToolTip("This option enables or disables the spawning of jetpacks. Default : Enabled")
		local Sldr = Panel:NumSlider("Jetpack maximum energy:", "wds2_jetpackmaxenergy", 20, 500, 0)
			Sldr:SetToolTip("This option specifies how much energy a jet pack has. Default : 80")
			Sldr:SetValue(80)
		
		Sldr = Panel:NumSlider("Jetpack energy use:", "wds2_jetpackenergyuse", 0, 20, 0)
			Sldr:SetToolTip("This option specifies how much energy the jetpack uses per second. Default : 5")
			Sldr:SetValue(5)
		
		Sldr = Panel:NumSlider("Jetpack energy regeneration:", "wds2_jetpackenergyregeneration", 0, 20, 0)
			Sldr:SetToolTip("This option specifies how much energy the jetpack recharges per second. Default : 5")
			Sldr:SetValue(5)
		
	else
		Panel:AddControl("Label",{Text="This panel is only available for admins"})
	end
	
end
