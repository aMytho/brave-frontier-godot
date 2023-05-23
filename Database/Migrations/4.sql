-- Creates the levels table. Player_state uses this to find the max exp

CREATE TABLE levels (
    id     INTEGER PRIMARY KEY AUTOINCREMENT
                   UNIQUE,
    amount REAL    NOT NULL
);

-- Enter some temporary data

INSERT INTO levels (
                       amount,
                       id
                   )
                   VALUES
                   (10, 1),(15, 2),(20, 3),(30, 4),(40, 5),(50, 6),(65, 7),(80, 8),(90, 9),(100, 10);
