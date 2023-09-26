-- The 'god mode' account, only used to make changes, all other queries 
-- to the database are done in ViewAll mode through 'master' user
DROP USER IF EXISTS 'AppAdminAero'@'localhost';
CREATE USER 'AppAdminAero'@'localhost' IDENTIFIED BY 'password1';
GRANT 'AppAdmin' TO  'AppAdminAero'@'localhost';
SET DEFAULT ROLE ALL TO 'AppAdminAero'@'localhost';

-- 'Master' user, who understands database and aerospace engineering, 
-- can see all, is in charge of approvals, but must send along changes 
-- to AppAdminAero user as an extra layer of safety
DROP USER IF EXISTS 'skaradowski'@'localhost';
CREATE USER 'skaradowski'@'localhost' IDENTIFIED BY 'pw';
GRANT 'ViewAll' TO 'skaradowski'@'localhost';
SET DEFAULT ROLE ALL TO 'skaradowski'@'localhost';

-- A user who is an engineer and has all views and permissions associated 
-- with that position.
DROP USER IF EXISTS 'taylord'@'localhost';
CREATE USER 'taylord'@'localhost' IDENTIFIED BY 'pw9';
GRANT 'Engineer' TO 'taylord'@'localhost';
SET DEFAULT ROLE ALL TO 'taylord'@'localhost';

-- A user who is a Materials Manager and has all views and permissions 
-- associated with that position
DROP USER IF EXISTS 'acconcio'@'localhost';
CREATE USER 'acconcio'@'localhost' IDENTIFIED BY 'pw1';
GRANT 'Materials' TO 'acconcio'@'localhost';
SET DEFAULT ROLE ALL TO 'acconcio'@'localhost';

-- A user who works on the shop floor, needs read only access to information
DROP USER IF EXISTS 'towers'@'localhost';
CREATE USER 'towers'@'localhost' IDENTIFIED BY 'pw1';
GRANT 'ShopFloor' TO 'towers'@'localhost';
SET DEFAULT ROLE ALL TO 'towers'@'localhost';
