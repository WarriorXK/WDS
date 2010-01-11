AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ExplodeEffect	= "wds_projectile_tankshell_explosion"
ENT.TrailEffect		= "wds_projectile_tankshell_trail"
ENT.Velocity		= 1000
ENT.Gravity			= true
ENT.Radius			= 20
ENT.Damage			= 150
ENT.Model			= "models/wds/bullet.mdl"
ENT.Drag			= true
