AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ExplodeEffect	= "wds_projectile_rocket_explosion"
ENT.TrailEffect		= "wds_projectile_rocket_trail"
ENT.Velocity		= 2000
ENT.Gravity			= false
ENT.Radius			= 20
ENT.Damage			= 120
ENT.Model			= "models/wds/rocket.mdl"
ENT.Drag			= false
