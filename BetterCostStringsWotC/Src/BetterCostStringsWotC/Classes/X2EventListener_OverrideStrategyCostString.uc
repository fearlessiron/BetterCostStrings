class X2EventListener_OverrideStrategyCostString extends X2EventListener;

`include(BetterCostStringsWotC/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateListenerTemplate_OnOverrideStrategyCostString());

	return Templates;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnOverrideStrategyCostString()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'BCS_OverrideStrategyCostString_Listener');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	`log(">>> BetterCostStringsWotC: Adding event listener for OverrideStrategyCostString");
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

	CostString = GetStrategyCostString(ItemTemplateName, Quantity, IsResourceCost, ShouldHighlightSparseResource(), ShouldAddQuantity, 2);

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
