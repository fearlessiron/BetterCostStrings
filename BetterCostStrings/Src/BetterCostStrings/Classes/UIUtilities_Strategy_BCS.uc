class UIUtilities_Strategy_BCS extends UIUtilities_Strategy;

`include(BetterCostStrings/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

`MCM_CH_StaticVersionChecker(class'BetterCostStrings_Settings_Defaults'.default.CONFIG_VERSION, class'BetterCostStrings_Settings'.default.CONFIG_VERSION)

// BCS-1
static function bool ShouldHighlightSparseResource()
{
	return `MCM_CH_GetValue(class'BetterCostStrings_Settings_Defaults'.default.ENABLE_HIGHLIGHT_SPARSE, class'BetterCostStrings_Settings'.default.ENABLE_HIGHLIGHT_SPARSE);
}

static function String GetStrategyCostString(StrategyCost StratCost, array<StrategyCostScalar> CostScalars, optional float DiscountPercent)
{
	local int iResource, iArtifact, Quantity, Available;
	local String strCost, strResourceCost, strArtifactCost, strResourcesRemaining;
	local StrategyCost ScaledStratCost;
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetXComHQ();

	ScaledStratCost = XComHQ.GetScaledStrategyCost(StratCost, CostScalars, DiscountPercent);

	for (iArtifact = 0; iArtifact < ScaledStratCost.ArtifactCosts.Length; iArtifact++)
	{
		Quantity = ScaledStratCost.ArtifactCosts[iArtifact].Quantity;
		strArtifactCost = String(Quantity) @ GetResourceDisplayName(ScaledStratCost.ArtifactCosts[iArtifact].ItemTemplateName, Quantity);

		Available = XComHQ.GetResourceAmount(ScaledStratCost.ArtifactCosts[iArtifact].ItemTemplateName);
		strResourcesRemaining = "(" $ String(Available) $ ")";

		if (!XComHQ.CanAffordResourceCost(ScaledStratCost.ArtifactCosts[iArtifact].ItemTemplateName, ScaledStratCost.ArtifactCosts[iArtifact].Quantity))
		{
			strArtifactCost = class'UIUtilities_Text'.static.GetColoredText(strArtifactCost, eUIState_Bad);
			if (Available > 0)
			{
				strArtifactCost @= class'UIUtilities_Text'.static.GetColoredText(strResourcesRemaining, eUIState_Bad);
			}
		}
		else
		{
			if (ShouldHighlightSparseResource() && Available < 2 * Quantity)
			{
				strArtifactCost = class'UIUtilities_Text'.static.GetColoredText(strArtifactCost, eUIState_Warning);
				strArtifactCost @= class'UIUtilities_Text'.static.GetColoredText(strResourcesRemaining, eUIState_Warning);
			}
			else {
				strArtifactCost = class'UIUtilities_Text'.static.GetColoredText(strArtifactCost, eUIState_Good);
				strArtifactCost @= class'UIUtilities_Text'.static.GetColoredText(strResourcesRemaining, eUIState_Good);
			}
		}

		if (iArtifact < ScaledStratCost.ArtifactCosts.Length - 1)
		{
			strArtifactCost $= ",";
		}
		else if (ScaledStratCost.ResourceCosts.Length > 0)
		{
			strArtifactCost $= ",";
		}

		if (strCost == "")
		{
			strCost $= strArtifactCost; 
		}
		else
		{
			strCost @= strArtifactCost;
		}
	}

	for (iResource = 0; iResource < ScaledStratCost.ResourceCosts.Length; iResource++)
	{
		Quantity = ScaledStratCost.ResourceCosts[iResource].Quantity;
		strResourceCost = String(Quantity) @ GetResourceDisplayName(ScaledStratCost.ResourceCosts[iResource].ItemTemplateName, Quantity);

		Available = XComHQ.GetResourceAmount(ScaledStratCost.ResourceCosts[iResource].ItemTemplateName);

		if (!XComHQ.CanAffordResourceCost(ScaledStratCost.ResourceCosts[iResource].ItemTemplateName, ScaledStratCost.ResourceCosts[iResource].Quantity))
		{
			strResourceCost = class'UIUtilities_Text'.static.GetColoredText(strResourceCost, eUIState_Bad);
		}
		else
		{
			if (ShouldHighlightSparseResource() && Available < 2 * Quantity)
			{
				strResourceCost = class'UIUtilities_Text'.static.GetColoredText(strResourceCost, eUIState_Warning);
			}
			else {
				strResourceCost = class'UIUtilities_Text'.static.GetColoredText(strResourceCost, eUIState_Good);
			}

		}

		if (iResource < ScaledStratCost.ResourceCosts.Length - 1)
		{
			strResourceCost $= ",";
		}

		if (strCost == "")
		{
			strCost $= strResourceCost;
		}
		else
		{
			strCost @= strResourceCost;
		}
	}

	return strCost;
}
