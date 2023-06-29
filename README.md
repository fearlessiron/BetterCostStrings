﻿# Better Cost Strings

XCOM 2 mod that shows inventory counts and highlights sparse artifacts and resources in cost strings
when building items, starting research, etc.

## Compatibility

This mod can be activated for existing campaigns. It overrides the class "UIUtilities_Strategy",
so it is incompatible with other mods that override the same class.

## Building

The mod can be built with Visual Studio Code. Be sure to add a `settings.json` file to the
directory `.vscode` and add your Steam paths as follows:

```
{
    "xcom.highlander.sdkroot": "D:\\Steam\\SteamApps\\common",
    "xcom.highlander.gameroot": "D:\\Steam\\SteamApps\\common\\XCOM 2",
}
```

Caveat: `xcom.highlander.sdkroot` must not contain the complete path to the SDK but to the folder
above. So if the SDK is in `D:\Steam\SteamApps\common\XCOM 2 SDK`, the value for the variable must
be `D:\\Steam\\SteamApps\\common`.

To build both for Vanilla and War of the Chosen without changing the settings, both the Vanilla SDK
and the War of the Chosen SDK need to be in the same Steam folder (`D:\Steam\SteamApps\common` in
the example). If that's not the case, the `xcom.highlander.sdkroot` path has to be adapted when
switching the target.
