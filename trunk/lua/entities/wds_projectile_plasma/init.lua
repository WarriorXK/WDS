AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ExplodeEffect	= "wds_projectile_plasmapulse_explosion"
ENT.TrailEffect		= "wds_projectile_plasmapulse_trail"
ENT.Velocity		= 1000
ENT.Gravity			= false
ENT.Radius			= 20
ENT.Damage			= 120
ENT.Model			= "models/wds/bullet.mdl"
ENT.Drag			= false
