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
`[BetterCostStrings.BetterCostStrings_Defaults]` (Vanilla) or
`[BetterCostStringsWotC.BetterCostStrings_Defaults]` (War of the Chosen) section.

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

## Releasing

Releases are created by the [Release](.github/workflows/release.yml) GitHub Actions workflow, which
runs [semantic-release](https://semantic-release.gitbook.io/). The version is derived from the
[Conventional Commits](https://www.conventionalcommits.org/) since the last release tag: `feat`
bumps the minor version, `fix` and `perf` bump the patch version and a `BREAKING CHANGE:` footer
bumps the major version. The `VERSION_*` constants in both variants' `BetterCostStrings_Settings.uc`
(Vanilla and War of the Chosen) only carry a placeholder development version in between releases,
and must always agree with each other.

The workflow pushes to `master` with the deploy key stored in the `RELEASE_DEPLOY_KEY` secret. The
key needs write access and must be listed as a bypass actor of the ruleset protecting `master` —
deploy keys can only be added as bypass actors on rulesets, not on classic branch protection rules,
so a classic rule needs migrating to a ruleset first if that's what's currently in place.

As the mod cannot be built in GitHub Actions, the release is created as a draft and the built
assets have to be attached by hand:

1. Start the *Release* workflow on `master` from the *Actions* tab. Tick *Dry run* first to see the
   version and release notes that would be produced without changing anything.
2. The workflow sets the version in both `BetterCostStrings_Settings.uc` files, commits them as
   `build: prepare release X.Y.Z`, tags the commit with `vX.Y.Z`, creates a draft release with the
   generated release notes and finally commits the next development version
   (`build: set new development version`).
3. Pull `master`, build both mod variants locally and attach the built assets to the draft release,
   one archive per variant (e.g. `BetterCostStrings-vX.Y.Z.zip` and
   `BetterCostStringsWotC-vX.Y.Z.zip`).
4. Publish the release.

If the workflow fails after tagging but before pushing the development version bump (for example
because of a ruleset/permission issue), the tag and draft release already exist but `master` is
left on the just-released version instead of a new development version. Recover by running
`bash .scripts/set-dev-version.sh <released version> master` locally with push access to `master`,
or by bumping and pushing the version by hand.
