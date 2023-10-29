class X2DownloadableContentInfo_BetterCostStrings extends X2DownloadableContentInfo;

static event OnLoadedSavedGame()
{

}

static event InstallNewCampaign(XComGameState StartState)
{

}

static event OnPostTemplatesCreated()
{
 	local string Version;

	Version = "v" $ class'BetterCostStrings_Settings'.const.VERSION_MAJOR;
	Version $= "." $ class'BetterCostStrings_Settings'.const.VERSION_MINOR;
	Version $= "." $ class'BetterCostStrings_Settings'.const.VERSION_PATCH;

	`log("    ____       __  __               ______           __     _____  __      _                 ");
	`log("   / __ )___  / /_/ /____  _____   / ____/___  _____/ /_   / ___/ / /_____(_)___  ____ ______");
	`log("  / __  / _ \\/ __/ __/ _ \\/ ___/  / /   / __ \\/ ___/ __/   \\__ \\/ __/ ___/ / __ \\/ __ \\/ ___/");
	`log(" / /_/ /  __/ /_/ /_/  __/ /     / /___/ /_/ (__  ) /_    ___/ / /_/ /  / / / / / /_/ (__  ) ");
	`log("/_____/\\___/\\__/\\__/\\___/_/      \\____/\\____/____/\\__/   /____/\\__/_/  /_/_/ /_/\\__, /____/  ");
	`log("                                                                      " $ Version $ "   /____/        ");
}
