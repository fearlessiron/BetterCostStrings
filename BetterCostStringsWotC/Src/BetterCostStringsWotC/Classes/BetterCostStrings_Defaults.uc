class BetterCostStrings_Defaults extends Object config(BetterCostStrings_Defaults);

// Config version
var config int CONFIG_VERSION;

// BCS-1: Config variable to enable highlighting of sparse resources
var config bool ENABLE_HIGHLIGHT_SPARSE;

// BCS-3: Config variable to display available resources (Supplies, Elerium Crystals, etc.)
var config bool SHOW_AVAILABLE_RESOURCES;

// Factor by which available artifacts and resources are multiplied to determine the threshold
// below which they are considered sparse
var config int SPARSE_WARNING_MULTIPLIER;
