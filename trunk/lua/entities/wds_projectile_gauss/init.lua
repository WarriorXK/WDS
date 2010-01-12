AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ExplodeEffect	= "wds_projectile_gauss_explosion"
ENT.TrailEffect		= "wds_projectile_gauss_trail"
ENT.Velocity		= 5000
ENT.Gravity			= false
ENT.Radius			= 15
ENT.Damage			= 100
ENT.Model			= "models/wds/bullet.mdl"
ENT.Drag			= false
