class BetterCostStrings_Settings extends UIScreenListener config(BetterCostStrings_Settings);

// Mod Config Menu boilerplate
`include(BetterCostStringsWotC/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(BetterCostStringsWotC/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

// Config version
var config int CONFIG_VERSION;

`MCM_CH_VersionChecker(class'BetterCostStrings_Settings_Defaults'.default.CONFIG_VERSION, CONFIG_VERSION)

event OnInit(UIScreen Screen)
{
    if (MCM_API(Screen) != none)
    {
        `MCM_API_Register(Screen, ClientModCallback);
    }

    if (UIShell(Screen) != none)
    {
        EnsureConfigExists();
    }
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
    // Build the settings UI
    local MCM_API_SettingsPage page;

    LoadSavedSettings();

    page = ConfigAPI.NewSettingsPage("Better Cost Strings");
    page.SetPageTitle("Better Cost Strings");
    page.SetSaveHandler(SaveButtonClicked);

    page.ShowSettings();
}

simulated function LoadSavedSettings()
{
}

function SaveButtonClicked(MCM_API_SettingsPage Page)
{
    self.CONFIG_VERSION = `MCM_CH_GetCompositeVersion();
    self.SaveConfig();
}

function EnsureConfigExists()
{
    if (CONFIG_VERSION == 0)
    {
    LoadSavedSettings();
        SaveButtonClicked(none);
    }
}

defaultproperties
{
    ScreenClass = none;
}
