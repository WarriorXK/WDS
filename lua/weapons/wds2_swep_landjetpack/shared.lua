
SWEP.PrintName				= "Land Jetpack"			
SWEP.Author					= "WarriorXK/kevkev"
SWEP.Slot					= 4
SWEP.SlotPos				= 1
SWEP.Contact				= ""
SWEP.Purpose				= "Getting around fast on a planet"
SWEP.Instructions			= "Press space to get a boost"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
//SWEP.ViewModel				= "models/weapons/wds/v_jetpack.mdl"
SWEP.WorldModel				= "models/wds/w_jetpack.mdl"
SWEP.HoldType 				= "normal"
SWEP.ViewModelFOV			= 62
SWEP.ViewModelFlip			= true
SWEP.IconLetter				= "w"

SWEP.Primary.Automatic		= false
SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Ammo			= ""
SWEP.Secondary.ClipSize		= maxfuel
SWEP.Secondary.DefaultClip	= maxfuel
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= ""

SWEP.NextCharge = 0
SWEP.NextJump = 0

if SERVER then
	include("init.lua")
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("shared.lua")
else
	include("cl_init.lua")
end

function SWEP:Initialize()
	if SERVER then
		self.dt.JetCharge = WDS2.Jetpack.MaxEnergy
	end
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack() end

function SWEP:SecondaryAttack() end

function SWEP:SetupDataTables()
	self:DTVar("Float",0,"JetCharge")
	self:DTVar("Bool",0,"Flying")
end
