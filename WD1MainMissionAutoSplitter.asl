state("Watch_Dogs")
{
    // unknown/default version
}

state("Watch_Dogs" , "v1.04.497") 
{
	int XP: "Disrupt_b64.dll", 0x396E038, 0x768, 0x0, 0x60, 0x8, 0xB8, 0x20;

	int act1mainmissions: "Disrupt_b64.dll", 0x3950830, 0xA8, 0x18, 0xC8, 0x18, 0x180, 0x98, 0xC24 ;

	int act2mainmissions: "Disrupt_b64.dll", 0x3950830, 0x10, 0x48, 0x38, 0x98, 0x2C4;

	int act3mainmissions: "Disrupt_b64.dll", 0x3950830, 0x18, 0x10, 0x50, 0x30, 0x68, 0x654;

	int act4mainmissions: "Disrupt_b64.dll", 0x3950830,  0x58, 0x78, 0x98, 0x954;
}

state("Watch_Dogs" , "v1.06.329 Steam Latest")
{
	int XP: "Disrupt_b64.dll", 0x3BDB920, 0x90, 0x18, 0xAA8;
	
	int act1mainmissions: "Disrupt_b64.dll", 0x3B70098, 0x10, 0x78, 0x98, 0xEC4;

	int act2mainmissions: "Disrupt_b64.dll", 0x3B70098, 0x40, 0x48, 0x168, 0x3B4;

	int act3mainmissions: "Disrupt_b64.dll", 0x3B70098, 0x40, 0x48, 0x1A0, 0x7D4;

	int act4mainmissions: "Disrupt_b64.dll", 0x3B70098, 0x10, 0x48, 0x98, 0xB64;
}

state("Watch_Dogs" , "v1.06.329 Uplay Latest")
{
	int XP: "Disrupt_b64.dll", 0x3B59050, 0x40, 0x98, 0x248, 0xA8;

	int act1mainmissions: "Disrupt_b64.dll", 0x3B91918, 0xE0, 0x1E8, 0x98, 0xEC4;

	int act2mainmissions: "Disrupt_b64.dll", 0x3B91918, 0x110, 0x1F8, 0x168, 0x3B4;

	int act3mainmissions: "Disrupt_b64.dll", 0x3B91918, 0xE0, 0xC8, 0x18, 0x180, 0x98, 0x7D4;

	int act4mainmissions: "Disrupt_b64.dll", 0x3B91918, 0xE0, 0x1E8, 0x98, 0xB64;
}


startup
{
    Action<string> logDebug = (text) => {
        print("[Watch_Dogs Autosplitter | DEBUG] "+ text);
    };
    vars.logDebug = logDebug;

    Func<ProcessModuleWow64Safe, string> calcModuleHash = (module) => {
        vars.logDebug("Calcuating hash of " + module.FileName);
        byte[] exeHashBytes = new byte[0];
        using (System.Security.Cryptography.MD5 sha = System.Security.Cryptography.MD5.Create())
        {
            using (FileStream s = File.Open(module.FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            {
                exeHashBytes = sha.ComputeHash(s);
            }
        }
        string hash = exeHashBytes.Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
        vars.logDebug("Hash: " + hash);
        return hash;
    };
    vars.calcModuleHash = calcModuleHash;

	vars.lastSplitTime = null;
	Func<bool> isNotDoubleSplit = () => {
		bool isDoubleSplit = false;
		if (vars.lastSplitTime != null) {
			System.TimeSpan ts = System.DateTime.Now - vars.lastSplitTime;
			if (ts.TotalSeconds < 20) {
				isDoubleSplit = true;
				vars.logDebug("Double split detected!");
			}
		}
		vars.lastSplitTime = System.DateTime.Now;
		return !isDoubleSplit;
	};
	vars.isNotDoubleSplit = isNotDoubleSplit;
}

init
{
    // vars.logDebug("modules: " + String.Join(", ", modules.Select(m=> m.ModuleName + " : " + m.BaseAddress.ToString() + " : " + m.EntryPointAddress.ToString())));
    ProcessModuleWow64Safe module = modules.Single(x => String.Equals(x.ModuleName, "Disrupt_b64.dll", StringComparison.OrdinalIgnoreCase));
    string hash = vars.calcModuleHash(module);
    switch (hash)
    {
        case "C3B1AD89FCCC74FE9C5BC5050A233308":
            version = "v1.04.497";
            break;
	case "1837A42D913BB7DAF94FEF3163BA615A":
            version = "v1.06.329 Steam Latest";
            break;    
        case "77D09E2A3DAAABBFEE4F3466F52A5794":
            version = "v1.06.329 Uplay Latest"; 
            break;
        default:
            throw new NotImplementedException("Unrecognized hash: " + hash);
            break;
    }
}

split{ 
	if(current.act1mainmissions == old.act1mainmissions+1)    //Aiden Story
		return vars.isNotDoubleSplit();

	if(current.act2mainmissions == old.act2mainmissions+1)    //Aiden Story
		return vars.isNotDoubleSplit();

	if(current.act3mainmissions == old.act3mainmissions+1)    //Aiden Story
		return vars.isNotDoubleSplit();

	if(current.act4mainmissions == old.act4mainmissions+1)    //Aiden Story
		return vars.isNotDoubleSplit();

	if(current.XP == old.XP+250 && current.act1mainmissions!=3 && current.act4mainmissions!=5)   //BB A1M1 & BB A1M2
		return vars.isNotDoubleSplit();
	
	if(current.XP == old.XP+500 && current.act1mainmissions!=1 && current.act2mainmissions!=1 && current.act2mainmissions!=5 && current.act2mainmissions<7)   //BB A1M3
		return vars.isNotDoubleSplit(); 

	if(current.XP == old.XP+600)               //BB A2M1
		return vars.isNotDoubleSplit();

	if(current.XP == old.XP+650)               //BB A2M2
		return vars.isNotDoubleSplit();
	
	if(current.XP == old.XP+800)               //BB A2M3 & BB A2M4
		return vars.isNotDoubleSplit();
	
	if(current.XP == old.XP+1000)              //BB A3M1
		return vars.isNotDoubleSplit();

	if(current.XP == old.XP+1500)              //BB A3M2
		return vars.isNotDoubleSplit();
}
