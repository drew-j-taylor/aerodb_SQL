ALTER TABLE aerodb.wo ADD COLUMN statusID int NOT NULL DEFAULT 1;

DROP TABLE IF EXISTS aerodb.wo_status;
CREATE TABLE aerodb.wo_status 
(
    statusID int NOT NULL AUTO_INCREMENT,
    statusName varchar(20),
    PRIMARY KEY (statusID)
);
INSERT INTO aerodb.wo_status (statusName) VALUES ('New'),('Active'),('Closed');

ALTER TABLE aerodb.wo ADD FOREIGN KEY (statusID) REFERENCES aerodb.wo_status(statusID);
UPDATE aerodb.wo SET statusID = 3 WHERE wo.woID < 100000022; 
UPDATE aerodb.wo SET statusID = 2 WHERE wo.woID BETWEEN 100000022 AND 100000036;
