--- Remove max_exp since we have the levels table, update constraints to match
PRAGMA foreign_keys = 0;

CREATE TABLE sqlitestudio_temp_table AS SELECT *
                                          FROM player_state;

DROP TABLE player_state;

CREATE TABLE player_state (
    id          INTEGER PRIMARY KEY AUTOINCREMENT
                        UNIQUE,
    player_name TEXT    UNIQUE
                        NOT NULL,
    level       INTEGER NOT NULL
                        DEFAULT (1) 
                        CONSTRAINT [Level Check] CHECK (level > 0 AND 
                                                        level < 1000) 
                        REFERENCES player_level (id),
    current_exp REAL    NOT NULL
                        DEFAULT (0.0) 
                        CONSTRAINT [Exp Check] CHECK (current_exp >= 0),
    energy      INTEGER NOT NULL
                        DEFAULT (0) 
                        CHECK (energy > -1),
    gems        INTEGER NOT NULL
                        CHECK (gems > -1),
    zel         INTEGER NOT NULL
                        CHECK (zel > -1),
    karma       INTEGER NOT NULL
                        CHECK (karma > -1),
    arena_orbs  INTEGER DEFAULT (0) 
                        NOT NULL
                        CONSTRAINT [Arena Check] CHECK (arena_orbs > -1 AND 
                                                        arena_orbs < 4) 
);

INSERT INTO player_state (
                             id,
                             player_name,
                             level,
                             current_exp,
                             energy,
                             gems,
                             zel,
                             karma,
                             arena_orbs
                         )
                         SELECT id,
                                player_name,
                                level,
                                current_exp,
                                energy,
                                gems,
                                zel,
                                karma,
                                arena_orbs
                           FROM sqlitestudio_temp_table;

DROP TABLE sqlitestudio_temp_table;

PRAGMA foreign_keys = 1;
