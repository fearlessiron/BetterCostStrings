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
	local bool bLogBanner;

	Version = "v" $ class'BetterCostStrings_Settings'.const.VERSION_MAJOR;
	Version $= "." $ class'BetterCostStrings_Settings'.const.VERSION_MINOR;
	Version $= "." $ class'BetterCostStrings_Settings'.const.VERSION_PATCH;

	bLogBanner = class'BetterCostStrings_Defaults'.default.LOG_BANNER;

	`log("    ____       __  __               ______           __     _____  __      _                 ", bLogBanner, 'BetterCostStrings');
	`log("   / __ )___  / /_/ /____  _____   / ____/___  _____/ /_   / ___/ / /_____(_)___  ____ ______", bLogBanner, 'BetterCostStrings');
	`log("  / __  / _ \\/ __/ __/ _ \\/ ___/  / /   / __ \\/ ___/ __/   \\__ \\/ __/ ___/ / __ \\/ __ \\/ ___/", bLogBanner, 'BetterCostStrings');
	`log(" / /_/ /  __/ /_/ /_/  __/ /     / /___/ /_/ (__  ) /_    ___/ / /_/ /  / / / / / /_/ (__  ) ", bLogBanner, 'BetterCostStrings');
	`log("/_____/\\___/\\__/\\__/\\___/_/      \\____/\\____/____/\\__/   /____/\\__/_/  /_/_/ /_/\\__, /____/  ", bLogBanner, 'BetterCostStrings');
	`log("                                                                      " $ Version $ "   /____/        ", bLogBanner, 'BetterCostStrings');
}
