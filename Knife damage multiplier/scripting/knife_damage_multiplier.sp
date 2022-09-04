#include <sourcemod>
#include <sdkhooks>

ConVar g_KnifeDamageMultiplier;

public Plugin myinfo = 
{
	name = "Knife Damage multiplier", 
	author = "Aim Monster | LuqS", 
	description = "Multiplies the damage given with knife.", 
	version = "1.0.0", 
	url = "https://github.com/orgs/Aim-Monster/ | Discord: LuqS#6505"
};

public void OnPluginStart()
{
	g_KnifeDamageMultiplier = CreateConVar("knife_damage_multiplier", "1.0", "multiplies with damage given from knife", .hasMin = true, .min = 0.0);

	// Late Load
	for (int current_client = 1; current_client <= MaxClients; current_client++)
	{
		if (IsClientInGame(current_client))
		{
			OnClientPutInServer(current_client)
		}
	}
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon,
		float damageForce[3], float damagePosition[3], int damagecustom)
{
	if (!IsValidEntity(weapon))
	{
		return Plugin_Continue;
	}

	char weapon_name[64];
	GetEntityClassname(weapon, weapon_name, sizeof(weapon_name));

	if ((StrContains(weapon_name, "knife", false) != -1) || (StrContains(weapon_name, "bayonet", false) != -1))
	{
		damage *= g_KnifeDamageMultiplier.FloatValue;
		return Plugin_Changed;
	}

	return Plugin_Continue;
}