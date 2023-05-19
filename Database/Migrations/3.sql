PRAGMA foreign_keys = 0;

CREATE TABLE sqlitestudio_temp_table AS SELECT *
                                          FROM teams;

DROP TABLE teams;

CREATE TABLE teams (
    id         INTEGER PRIMARY KEY AUTOINCREMENT
                       UNIQUE,
    name       TEXT,
    unit1      INTEGER REFERENCES units (id) ON DELETE SET NULL,
    unit2      INTEGER REFERENCES units (id) ON DELETE SET NULL,
    unit3      INTEGER REFERENCES units (id) ON DELETE SET NULL,
    unit4      INTEGER REFERENCES units (id) ON DELETE SET NULL,
    unit5      INTEGER REFERENCES units (id) ON DELETE SET NULL,
    account_id         REFERENCES player_state (id) 
                       NOT NULL,
    leader     INTEGER DEFAULT (2) 
);

INSERT INTO teams (
                      id,
                      name,
                      unit1,
                      unit2,
                      unit3,
                      unit4,
                      unit5,
                      account_id
                  )
                  SELECT id,
                         name,
                         unit1,
                         unit2,
                         unit3,
                         unit4,
                         unit5,
                         account_id
                    FROM sqlitestudio_temp_table;

DROP TABLE sqlitestudio_temp_table;

PRAGMA foreign_keys = 1;
