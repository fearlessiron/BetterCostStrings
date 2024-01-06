class BetterCostStrings_MCM_ScreenListener extends UIScreenListener;

event OnInit (UIScreen Screen)
{
	local BetterCostStrings_Settings MCMScreen;

	if (ScreenClass == none)
	{
		if (MCM_API(Screen) != none)
		{
			ScreenClass = Screen.Class;
		}
		else
		{
			return;
		}
	}

	MCMScreen = new class'BetterCostStrings_Settings';
	MCMScreen.OnInit(Screen);
}

defaultproperties
{
    ScreenClass = none;
}

