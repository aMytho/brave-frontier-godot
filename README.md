# Brave Frontier Godot

This is a small remake of the mobile game Brave Frontier. Brave frontier shutdown within the last year. This project implements many of the same features and structure.

I am **not** remaking the full game. This project solely exists so I can practice with the Godot game engine. If you want to see this game again, have a look at [Brave Frontier Recoded](https://bravefrontierrecoded.com/).

*Side note, if any of the BFR folks want to use this project, they are more than welcome to!

## Tech Stack

Most of the data is stored as Godot resource files. For example, each unit works off of the [unit_base](https://github.com/aMytho/brave-frontier-godot/blob/main/Units/unit_base.gd) and extends it with its own properties. This differs from the JSON and CSV data that the original game used.

Player data is stored in an SQLite database. Rather than keep a full record of all player units, items, and other data, the database only contains what data the player has modified. For example, when the player squires a unit it is added to the DB. The stats from the DB are the "real" stats since the Godot resource only includes the base values. This should be scalable.

Unlike the original game, this is a purely offline implementation. I have no plans to add multiplayer of any kind. As noted above, this project is just practice and I have no wish to expand it beyond the engine.

## Current State

This is in an alpha state. It contains some bugs and many features are not implemented. Some dialogue and other data differs from the game since records of certain events (lucius cutscene) could not be found. While this project can be ran, you may need to modify `GameContent.gd` to get the scene you want. When I am finished I will include an executable file for ease of access.

## Copyright Notice

I do not own any of the assets. They are owned by Gumi / Alim and the Brave Frontier team. This project earns no revenue and is purely for educational purposes.