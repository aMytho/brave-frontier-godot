CREATE TABLE player_state (
  id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, 
  player_name TEXT UNIQUE NOT NULL, 
  level INTEGER NOT NULL DEFAULT (1) CONSTRAINT [Level Check] CHECK (
    level > 0 
    AND level < 1000
  ), 
  exp REAL NOT NULL DEFAULT (0.0) CONSTRAINT [Exp Check] CHECK (
    exp > -1.0 
    AND exp <= max_exp
  ), 
  max_exp INTEGER NOT NULL REFERENCES levels (id), 
  energy INTEGER NOT NULL DEFAULT (0) CHECK (energy > -1), 
  gems INTEGER NOT NULL CHECK (gems > -1), 
  zel INTEGER NOT NULL CHECK (zel > -1), 
  karma INTEGER NOT NULL CHECK (karma > -1), 
  arena_orbs INTEGER DEFAULT (0) NOT NULL CONSTRAINT [Arena Check] CHECK (
    arena_orbs > -1 
    AND arena_orbs < 4
  )
);
