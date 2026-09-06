# Better Cost Strings

XCOM 2 mod that shows inventory counts and highlights sparse artifacts and resources in cost strings
when building items, starting research, etc.

## Compatibility

This mod can be activated for existing campaigns. It overrides the class "UIUtilities_Strategy",
so it is incompatible with other mods that override the same class.

## Logging

On startup the mod prints a banner with its version to `Launch.log`. If you find this noisy, set
`LOG_BANNER=false` in `XComBetterCostStrings_Defaults.ini`. Other mods can override the setting
from their own config by adding that line under the
`[BetterCostStrings.BetterCostStrings_Defaults]` section.
