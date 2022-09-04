#include <sdkhooks>
#include <sdktools>

public Plugin myinfo =
{
    name = "Remove ragdoll velocity",
    author = "backwards",
    description = "Remove Ragdolls Velocity.",
    version = "1.0",
    url = "http://steamcommunity.com/id/mypassword"
}; 

public OnPluginStart()
{
	//late load hooks
	for(int i = 1;i<MaxClients+1;i++)
		if(IsValidClient(i))
			OnClientPutInServer(i);
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamageAlive , OnTakeDamageAlive);
}

public Action OnTakeDamageAlive(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3])
{
	if(!IsValidClient(victim))
		return Plugin_Continue;
		
	float Health = GetEntProp(victim, Prop_Send, "m_iHealth", 4) - damage;
	if(Health < 1)
	{
		float NullVelocity[3] = {0.0, 0.0, 0.0};
		TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, NullVelocity);
	}
	
	return Plugin_Continue;
}

bool IsValidClient(int client)
{
    if (!(1 <= client <= MaxClients) || !IsClientInGame(client) || !IsClientConnected(client))
        return false;
		
    return true;
}