CREATE TABLE species (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  genus_id INTEGER,

  FOREIGN KEY(genus_id) REFERENCES genus(id)
);

CREATE TABLE genus (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  family_id INTEGER,

  FOREIGN KEY(family_id) REFERENCES families(id)
);

CREATE TABLE families (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  families (id, name)
VALUES
  (1, "Felidae"), (2, "Canidae");

INSERT INTO
  genus (id, name, family_id)
VALUES
  (1, "Felis", 1),
  (2, "Canis", 2),
  (3, "unknown", NULL);

INSERT INTO
  species (id, name, genus_id)
VALUES
  (1, "catus", 1),
  (2, "silvestris", 1),
  (3, "lupus", 2),
  (4, "adustus", 2),
  (5, "unknown", NULL);
