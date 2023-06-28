class BetterCostStrings_Settings extends UIScreenListener config(BetterCostStrings_Settings);

// Mod Config Menu boilerplate
`include(BetterCostStringsWotC/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(BetterCostStringsWotC/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

// Config version
var config int CONFIG_VERSION;

// BCS-1: Config variable to enable highlighting of sparse resources
var config bool ENABLE_HIGHLIGHT_SPARSE;

// BCS-3: Config variable to display available resources (Supplies, Elerium Crystals, etc.)
var config bool SHOW_AVAILABLE_RESOURCES;

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
    local MCM_API_SettingsGroup group;

    LoadSavedSettings();

    page = ConfigAPI.NewSettingsPage("Better Cost Strings");
    page.SetPageTitle("Better Cost Strings");
    page.SetSaveHandler(SaveButtonClicked);

    group = Page.AddGroup('BCSGeneralSettings', "General settings");
    // BCS-1
    group.AddCheckBox('highlightSparse',
        "Highlight sparse resources",
        "If activated, a resource will be highlighted when there is only enough of it in the inventory for one more item.",
        ENABLE_HIGHLIGHT_SPARSE,
        HighlightSparseSaveHandler);

    // BCS-3
    group.AddCheckBox('showAvailableResources',
        "Also show available resources (Supplies, Elerium Crystals, etc.)",
        "If activated, also shows available resources like Supplies, Elerium Crystal, Elerium Cores, etc. in the cost string.",
        SHOW_AVAILABLE_RESOURCES,
        ShowAvailableResourcesSaveHandler);

    page.ShowSettings();
}

`MCM_API_BasicCheckboxSaveHandler(HighlightSparseSaveHandler, ENABLE_HIGHLIGHT_SPARSE)
`MCM_API_BasicCheckboxSaveHandler(ShowAvailableResourcesSaveHandler, SHOW_AVAILABLE_RESOURCES)

simulated function LoadSavedSettings()
{
    ENABLE_HIGHLIGHT_SPARSE = `MCM_CH_GetValue(class'BetterCostStrings_Settings_Defaults'.default.ENABLE_HIGHLIGHT_SPARSE, ENABLE_HIGHLIGHT_SPARSE);
    SHOW_AVAILABLE_RESOURCES = `MCM_CH_GetValue(class'BetterCostStrings_Settings_Defaults'.default.SHOW_AVAILABLE_RESOURCES, SHOW_AVAILABLE_RESOURCES);
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
