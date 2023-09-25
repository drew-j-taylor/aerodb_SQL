
-- History Types
USE aerodb;
DROP TABLE IF EXISTS history_types;
CREATE TABLE history_types
(
    historyID int PRIMARY KEY,
    historyName varchar(50)
);

-- Insert data
INSERT INTO history_types VALUES 
(1, 'Insert'),
(2, 'Update - Old value'),
(3, 'Update - New Value'),
(4, 'Delete');

DROP TABLE IF EXISTS part_history;
CREATE TABLE part_history
(
    partHistoryID int AUTO_INCREMENT PRIMARY KEY,
    partNumID int,
    partNum char(20),
    partDescription varchar(50),
    programID int,
    sourceID int,
    historyDate timestamp,
    modifyingUser varchar(50),
    historyID int REFERENCES history_types(historyID)
);

-- History Trigger - Insert
DROP TRIGGER IF EXISTS ins_part_history;
delimiter //
CREATE TRIGGER ins_part_history BEFORE INSERT ON part
    FOR EACH ROW
    BEGIN
        SET @newID = (SELECT MAX(part.partNumID) from aerodb.part)+1;
        -- Insert new row
        INSERT INTO part_history 
        (partNumID, partNum, partDescription, programID,sourceID,
         historyDate,modifyingUser,historyID)
        VALUES (
            @newID,NEW.partNum,NEW.partDescription,
            NEW.programID,NEW.sourceID,NOW(),CURRENT_USER(),1);
    END;//
delimiter ;

-- History Trigger - Update
DROP TRIGGER IF EXISTS upd_part_history;
delimiter //
CREATE TRIGGER upd_part_history BEFORE UPDATE ON part
    FOR EACH ROW
    BEGIN
        -- Insert old row
        INSERT INTO part_history
        (partNumID, partNum, partDescription, programID,sourceID,
         historyDate,modifyingUser,historyID)
        VALUES (
            OLD.partNumID,OLD.partNum,OLD.partDescription,
            OLD.programID,OLD.sourceID,NOW(),CURRENT_USER(),2);
        
        -- Insert new row
        INSERT INTO part_history
        (partNumID, partNum, partDescription, programID,sourceID,
         historyDate,modifyingUser,historyID)
        VALUES (
            NEW.partNumID,NEW.partNum,NEW.partDescription,
            NEW.programID,NEW.sourceID,NOW(),CURRENT_USER(),3);
    END;//
delimiter ;

-- History Trigger - Update
DROP TRIGGER IF EXISTS del_part_history;
delimiter //
CREATE TRIGGER del_part_history BEFORE DELETE ON part
    FOR EACH ROW
    BEGIN
        -- Insert deleted row
        INSERT INTO part_history
        (partNumID, partNum, partDescription, programID,sourceID,
         historyDate,modifyingUser,historyID)
        VALUES (
            OLD.partNumID,OLD.partNum,OLD.partDescription,
            OLD.programID,OLD.sourceID,NOW(),CURRENT_USER(),4);
   END;//
delimiter ;
