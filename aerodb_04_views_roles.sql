
-- Database Views and User Access to Views
-- View on every table
USE aerodb;
CREATE VIEW view_add_inv AS SELECT * FROM add_inv;
CREATE VIEW view_assy_bom AS SELECT * FROM assy_bom;
CREATE VIEW view_building AS SELECT * FROM building;
CREATE VIEW view_customer AS SELECT * FROM customer;
CREATE VIEW view_history_types AS SELECT * FROM history_types;
CREATE VIEW view_part AS SELECT * FROM part;
CREATE VIEW view_part_history AS SELECT * FROM part_history;
CREATE VIEW view_program AS SELECT * FROM program;
CREATE VIEW view_shelf AS SELECT * FROM shelf;
CREATE VIEW view_source AS SELECT * FROM source;
CREATE VIEW view_wo AS SELECT * FROM wo;
CREATE VIEW view_wo_status AS SELECT * FROM wo_status;

USE aerodb;
CREATE VIEW wo_current_upcoming AS 
SELECT 
    wo.woID AS WO, 
    part.partNum AS Part, 
    wo.quantity, 
    wo_status.statusName AS Status 
FROM aerodb.wo
JOIN aerodb.part ON part.partnumID = wo.partnumID 
JOIN aerodb.wo_status ON wo_status.statusID = wo.statusID
WHERE wo_status.statusName = 'Active' 
OR wo_status.statusName = 'New' 
ORDER BY wo.woID;

-- Role ViewAll, has select on all views, safe 'master' role
CREATE ROLE 'ViewAll';
GRANT SELECT ON view_add_inv TO 'ViewAll';
GRANT SELECT ON view_assy_bom TO 'ViewAll';
GRANT SELECT ON view_building TO 'ViewAll';
GRANT SELECT ON view_customer TO 'ViewAll';
GRANT SELECT ON view_history_types TO 'ViewAll';
GRANT SELECT ON view_part TO 'ViewAll';
GRANT SELECT ON view_part_history TO 'ViewAll';
GRANT SELECT ON view_program TO 'ViewAll';
GRANT SELECT ON view_shelf TO 'ViewAll';
GRANT SELECT ON view_source TO 'ViewAll';
GRANT SELECT ON view_wo TO 'ViewAll';
GRANT SELECT ON view_wo_status TO 'ViewAll';


-- Application Admin role
CREATE ROLE 'AppAdmin';
GRANT REFERENCES, SELECT, INSERT, UPDATE, DELETE ON aerodb.* TO 'AppAdmin';


-- Role for engineer and all permissions necessary for those in that role
CREATE ROLE 'Engineer';
GRANT SELECT ON aerodb.add_inv TO 'Engineer';
GRANT SELECT, INSERT, UPDATE, DELETE ON aerodb.assy_bom TO 'Engineer';
GRANT SELECT ON aerodb.building TO 'Engineer';
GRANT SELECT ON aerodb.customer TO 'Engineer';
GRANT SELECT ON aerodb.history_types TO 'Engineer';
GRANT SELECT, INSERT, UPDATE ON aerodb.part TO 'Engineer';
GRANT SELECT ON aerodb.part_history TO 'Engineer';
GRANT SELECT ON aerodb.program TO 'Engineer';
GRANT SELECT ON aerodb.shelf TO 'Engineer';
GRANT SELECT ON aerodb.source TO 'Engineer';
GRANT SELECT ON aerodb.wo TO 'Engineer';
GRANT SELECT ON aerodb.wo_status TO 'Engineer';
GRANT EXECUTE ON PROCEDURE aerodb.get_bom_children TO 'Engineer';
GRANT EXECUTE ON PROCEDURE aerodb.part_info TO 'Engineer';
GRANT EXECUTE ON PROCEDURE aerodb.get_bom_report TO 'Engineer';


-- Role for materials management and all permissions necessary for those in that role
CREATE ROLE 'Materials';
GRANT SELECT, INSERT, UPDATE, DELETE ON aerodb.add_inv TO 'Materials';
GRANT SELECT ON aerodb.assy_bom TO 'Materials';
GRANT SELECT ON aerodb.building TO 'Materials';
GRANT SELECT ON aerodb.customer TO 'Materials';
GRANT SELECT ON aerodb.history_types TO 'Materials';
GRANT SELECT ON aerodb.part TO 'Materials';
GRANT SELECT ON aerodb.part_history TO 'Materials';
GRANT SELECT ON aerodb.program TO 'Materials';
GRANT SELECT, INSERT, UPDATE, DELETE ON aerodb.shelf TO 'Materials';
GRANT SELECT ON aerodb.source TO 'Materials';
GRANT SELECT, INSERT, UPDATE, DELETE ON aerodb.wo TO 'Materials';
GRANT SELECT, INSERT, UPDATE, DELETE ON aerodb.wo_status TO 'Materials';
GRANT SELECT ON wo_current_upcoming TO 'Materials';


-- Role for shop floor worker and all permissions necessary for those in that role
CREATE ROLE 'ShopFloor';
GRANT SELECT ON aerodb.add_inv TO 'ShopFloor';
GRANT SELECT ON aerodb.assy_bom TO 'ShopFloor';
GRANT SELECT ON aerodb.building TO 'ShopFloor';
GRANT SELECT ON aerodb.customer TO 'ShopFloor';
GRANT SELECT ON aerodb.part TO 'ShopFloor';
GRANT SELECT ON aerodb.program TO 'ShopFloor';
GRANT SELECT ON aerodb.shelf TO 'ShopFloor';
GRANT SELECT ON aerodb.source TO 'ShopFloor';
GRANT SELECT ON aerodb.wo TO 'ShopFloor';
GRANT SELECT ON aerodb.wo_status TO 'ShopFloor';
GRANT EXECUTE ON PROCEDURE aerodb.get_bom_children TO 'Engineer';
GRANT EXECUTE ON PROCEDURE aerodb.part_info TO 'Engineer';
