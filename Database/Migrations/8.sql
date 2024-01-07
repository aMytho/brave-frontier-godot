-- Create Zone Completions
CREATE TABLE zones (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    player_id   INTEGER REFERENCES player_state (id) 
                        NOT NULL,
    zone_id     INTEGER UNIQUE
                        NOT NULL,
    is_complete INTEGER DEFAULT (0) 
                        CHECK (is_complete = 0 OR 
                               is_complete = 1) 
);
