class BetterCostStrings_Settings extends UIScreenListener config(BetterCostStrings_Settings);

// Config version
var config int CONFIG_VERSION;

// Mod Config Menu boilerplate
`include(BetterCostStringsWotC/Src/ModConfigMenuAPI/MCM_API_Includes.uci)

// BCS-1
`MCM_API_AutoCheckboxVars(SHOW_AVAILABLE_RESOURCES);
// BCS-3
`MCM_API_AutoCheckboxVars(ENABLE_HIGHLIGHT_SPARSE);
//
`MCM_API_AutoSliderVars(SPARSE_WARNING_MULTIPLIER);

`include(BetterCostStringsWotC/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

// BCS-1
`MCM_API_AutoCheckboxFns(SHOW_AVAILABLE_RESOURCES);
// BCS-3
`MCM_API_AutoCheckboxFns(ENABLE_HIGHLIGHT_SPARSE);
//
`MCM_API_AutoSliderFns(SPARSE_WARNING_MULTIPLIER, , 2);

event OnInit(UIScreen Screen)
{
	if (MCM_API(Screen) != none)
	{
		`MCM_API_Register(Screen, ClientModCallback);
	}
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
    // Build the settings UI
    local MCM_API_SettingsPage page;
    local MCM_API_SettingsGroup group;

    LoadSavedSettings();

    page = ConfigAPI.NewSettingsPage("Better Cost Strings");
    page.SetPageTitle("Better Cost Strings");
    page.SetSaveHandler(SaveButtonClicked);

    group = page.AddGroup('BCSGeneralSettings', "General settings");
    // BCS-1
    `MCM_API_AutoAddCheckbox(group, SHOW_AVAILABLE_RESOURCES);
    // BCS-3
    `MCM_API_AutoAddCheckbox(group, ENABLE_HIGHLIGHT_SPARSE);
    `MCM_API_AutoAddSlider(group, SPARSE_WARNING_MULTIPLIER, 2, 10, 1);

    page.ShowSettings();
}

simulated function LoadSavedSettings()
{
	SHOW_AVAILABLE_RESOURCES = `GETMCMVAR(SHOW_AVAILABLE_RESOURCES);
	ENABLE_HIGHLIGHT_SPARSE = `GETMCMVAR(ENABLE_HIGHLIGHT_SPARSE);
	SPARSE_WARNING_MULTIPLIER = `GETMCMVAR(SPARSE_WARNING_MULTIPLIER);
}

function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	CONFIG_VERSION = `MCM_CH_GetCompositeVersion();
	SaveConfig();
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	`MCM_API_AutoReset(SHOW_AVAILABLE_RESOURCES);
	`MCM_API_AutoReset(ENABLE_HIGHLIGHT_SPARSE);
	`MCM_API_AutoReset(SPARSE_WARNING_MULTIPLIER);
}

defaultproperties
{
    ScreenClass = none;
}
