-- make units table. Only includes overridable props
CREATE TABLE units (
    id         INTEGER PRIMARY KEY AUTOINCREMENT
                       UNIQUE,
    account_id INTEGER REFERENCES player_state (id) 
                       NOT NULL,
    unit_id    INTEGER NOT NULL,
    level      INTEGER NOT NULL,
    hp         INTEGER NOT NULL,
    atk        INTEGER NOT NULL,
    def        INTEGER NOT NULL,
    rec        INTEGER NOT NULL
);

--make team table. Each row is 1 team
CREATE TABLE team (
    id    INTEGER PRIMARY KEY AUTOINCREMENT
                  UNIQUE,
    name  TEXT,
    unit1 INTEGER REFERENCES units (id) ON DELETE SET NULL,
    unit2 INTEGER REFERENCES units (id) ON DELETE SET NULL,
    unit3 INTEGER REFERENCES units (id) ON DELETE SET NULL,
    unit4 INTEGER REFERENCES units (id) ON DELETE SET NULL,
    unit5 INTEGER REFERENCES units (id) ON DELETE SET NULL
);
