
-- 
-- Get single level of all parts that go into assembly
-- 
DELIMITER //
CREATE PROCEDURE aerodb.get_bom_children(IN assy_num varchar(20))
BEGIN
    SELECT
        detail.partNum AS Part, 
        assy.partNum AS 'Parent Assembly', 
        assy_bom.quantity, 
        detail.partDescription AS Description, 
        source.sourceCode AS Source, 
        program.programCode AS Program 
    FROM aerodb.assy_bom
    JOIN aerodb.part assy ON assy_bom.parentNumID = assy.partNumID
    JOIN aerodb.part detail ON assy_bom.partNumID = detail.partNumID
    JOIN aerodb.program ON detail.programID = program.programID 
    JOIN aerodb.source ON source.sourceID = detail.sourceID
    WHERE assy.partNum = assy_num;
END //
DELIMITER ;

-- 
-- Get basic info for one single part number
-- 
DELIMITER //
CREATE PROCEDURE aerodb.part_info(IN part_num varchar(20))
BEGIN
    SELECT 
        part.partNum AS Part, 
        part.partDescription AS Description, 
        program.programCode as Program, 
        source.sourceCode AS Source 
    FROM aerodb.part 
    JOIN aerodb.program ON program.programID = part.programID 
    JOIN aerodb.source ON source.sourceID = part.sourceID 
    WHERE part.partNum = part_num;
END //
DELIMITER;

-- 
-- Full list of all parts and subassemblies that make up the assembly
-- 
DELIMITER //
CREATE PROCEDURE aerodb.get_bom_report(IN assy_num varchar(20))
BEGIN
    WITH RECURSIVE
    BOM (Part, parent, quantity, Description, Source, Program)
    AS
    ( 
        SELECT detail.partNum, assy.partNum, assy_bom.quantity, detail.partDescription, source.sourceCode, program.programCode
        FROM aerodb.assy_bom
        JOIN aerodb.part assy ON assy_bom.parentNumID = assy.partNumID
        JOIN aerodb.part detail ON assy_bom.partNumID = detail.partNumID
        JOIN aerodb.program ON detail.programID = program.programID 
        JOIN aerodb.source ON source.sourceID = detail.sourceID
        WHERE assy.partNum = assy_num
        UNION ALL
        SELECT detail.partNum, BOM.part, assy_bom.quantity, detail.partDescription, source.sourceCode, program.programCode
        FROM aerodb.assy_bom
        JOIN aerodb.part assy ON assy_bom.parentNumID = assy.partNumID
        JOIN BOM ON BOM.part = assy.partNum 
        JOIN aerodb.part detail ON assy_bom.partNumID = detail.partNumID
        JOIN aerodb.program ON detail.programID = program.programID 
        JOIN aerodb.source ON source.sourceID = detail.sourceID
    )
    SELECT BOM.Part, BOM.parent AS 'Parent Assembly', quantity, Description, Source, Program
    FROM BOM;
END //
DELIMITER ;
