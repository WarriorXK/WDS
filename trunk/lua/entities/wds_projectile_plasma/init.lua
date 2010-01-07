AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.ExplodeEffect = "wds_projectile_plasmapulse_explosion"
ENT.TrailEffect = "wds_projectile_plasmapulse_trail"
ENT.Velocity = 1000
ENT.Radius = 10
ENT.Damage = 10
ENT.Model = "models/Gibs/HGIBS.mdl"
