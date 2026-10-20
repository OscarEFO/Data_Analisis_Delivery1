CREATE TABLE Players (
    PlayerID    INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    Name        VARCHAR(100)     NOT NULL,
    Country     VARCHAR(100)     NULL,
    Age         INT(11)          NULL,
    Gender      FLOAT            NULL,
    CreateDate  DATETIME         NOT NULL,
    PRIMARY KEY (PlayerID),
    INDEX idx_players_createdate (CreateDate),
    INDEX idx_players_country (Country)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Items (
    ItemID    INT(11)       NOT NULL,
    ItemName  VARCHAR(100)  NOT NULL,
    Price     DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ItemID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Sessions (
    SessionID             INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    PlayerID              INT(10) UNSIGNED NOT NULL,
    StartTime             DATETIME         NOT NULL,
    EndTime               DATETIME         NULL,
    SessionLengthSeconds  INT(10) UNSIGNED NULL,
    PRIMARY KEY (SessionID),
    INDEX idx_sessions_player (PlayerID),
    INDEX idx_sessions_start (StartTime),
    CONSTRAINT fk_sessions_player FOREIGN KEY (PlayerID) REFERENCES Players (PlayerID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Purchases (
    PurchaseID    INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    SessionID     INT(10) UNSIGNED NOT NULL,
    ItemID        INT(11)          NOT NULL,
    PurchaseDate  DATETIME         NOT NULL,
    PRIMARY KEY (PurchaseID),
    INDEX idx_purchases_session (SessionID),
    INDEX idx_purchases_item (ItemID),
    INDEX idx_purchases_date (PurchaseDate),
    CONSTRAINT fk_purchases_session FOREIGN KEY (SessionID) REFERENCES Sessions (SessionID),
    CONSTRAINT fk_purchases_item    FOREIGN KEY (ItemID)    REFERENCES Items (ItemID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO Items (ItemID, ItemName, Price) VALUES
    (1, 'Item 1',  0.99),
    (2, 'Item 2',  1.99),
    (3, 'Item 3',  9.99),
    (4, 'Item 4', 49.99),
    (5, 'Item 5', 99.99);
