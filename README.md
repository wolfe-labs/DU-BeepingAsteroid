# BeepingAsteroid (aka Wolfe Labs Asteroid Notification System)

This is a small utility for Dual Universe asteroid mining players that allows you to see and hear a ping whenever a ship gets in radar range.

## Installation and Usage

Install the main script in a Remote Controller and make sure it is connected to a Space Radar (in the "radar" slot).

Activate the Remote Controller before leaving your ship for mining. You will see a HUD showing the following information:

- Status: Initializing (within warm-up period) or Active (pings enabled), along with Safe Zone or PVP Space status;
- Radar: Current count of radar contacts, plus how many have a matching transponder;
- Range: How far you can still go from your ship (out of 2000m) before the system stops working;

### Sound Notifications

For sound notifications, you need to put a file called `radar-ping.wav` in the `My Documents/NQ/DualUniverse/audio` directory.

### Extra Options

You can customize the how long the warm-up period should take, along with whether to notify in Safe Zone or not, by right-clicking the Remote Controller, going into Advanced and selecting "Edit Lua parameters".