class X2EventListener_OverrideStrategyCostString extends X2EventListener;

`include(BetterCostStringsWotC/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
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

	Templates.AddItem(CreateListenerTemplate_OnOverrideStrategyCostString());

	return Templates;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnOverrideStrategyCostString()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'BCS_OverrideStrategyCostString_Listener');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	`log(">>> Adding event listener for OverrideStrategyCostString");
	Template.AddCHEvent('OverrideStrategyCostString', OnOverrideStrategyCostString, ELD_Immediate, 50);

	return Template;
}

// BCS-1
static function bool ShouldHighlightSparseResource()
{
	return `GETMCMVAR(ENABLE_HIGHLIGHT_SPARSE);
}

// BCS-3
static function bool ShouldShowAvailableResources()
{
	return `GETMCMVAR(SHOW_AVAILABLE_RESOURCES);
}

static function int GetSparseMultiplier()
{
	return `GETMCMVAR(SPARSE_WARNING_MULTIPLIER);
}

static function EventListenerReturn OnOverrideStrategyCostString(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
	local XComLWTuple Tuple;
	local name ItemTemplateName;
	local int Quantity;
	local bool IsResourceCost, ShouldAddQuantity;
	local string CostString;

	Tuple = XComLWTuple(EventData);

	ItemTemplateName = Tuple.Data[0].n;
	Quantity = Tuple.Data[1].i;
	IsResourceCost = Tuple.Data[2].b;
	CostString = Tuple.Data[3].s;

	ShouldAddQuantity = (!IsResourceCost || ShouldShowAvailableResources());

	CostString = GetStrategyCostString(ItemTemplateName, Quantity, IsResourceCost, ShouldHighlightSparseResource(), ShouldAddQuantity, GetSparseMultiplier());

	Tuple.Data[3].s = CostString;

	return ELR_NoInterrupt;
}

static function string GetStrategyCostString(name ItemTemplateName, int Quantity, bool IsResourceCost, bool ShouldHightlightSparse, bool ShouldAddStockedQuantity, int SparseMultiplier)
{
	local int QuantityStocked;
	local string QuantityStockedSuffix;
	local bool IsSparse;
	local eUIState Colour;
	local String CostString;

	QuantityStocked = `XCOMHQ.GetResourceAmount(ItemTemplateName);
	QuantityStockedSuffix = ShouldAddStockedQuantity ? " (" $ QuantityStocked $ ")" : "" ;

	IsSparse = QuantityStocked < SparseMultiplier * Quantity;

	if (!`XCOMHQ.CanAffordResourceCost(ItemTemplateName, Quantity))
	{
		Colour = eUIState_Bad;
	}
	else if (IsSparse && ShouldHightlightSparse)
	{
		Colour = eUIState_Warning;
	}
	else
	{
		Colour = eUIState_Good;
	}

	CostString = Quantity @ class'UIUtilities_Strategy'.static.GetResourceDisplayName(ItemTemplateName, Quantity);
	if (QuantityStocked > 0)
	{
		CostString $= QuantityStockedSuffix;
	}

	return class'UIUtilities_Text'.static.GetColoredText(CostString, Colour);
}
