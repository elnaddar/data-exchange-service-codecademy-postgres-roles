-- the database has just one superuser. Write a query that allows you to determine the name of that role.
SELECT rolname
FROM "pg_catalog"."pg_roles"
WHERE rolsuper = TRUE;

-- What are the names of the other users in the database? What permissions do these roles have (e.g. rolcreaterole, rolcanlogin, rolcreatedb, etc.)?
SELECT *
FROM "pg_catalog"."pg_roles";

-- Now that you have the name of the superuser, check the name of the role you’re currently using. Is this role the superuser?
SELECT CURRENT_ROLE;
SELECT CURRENT_SCHEMA;

-- # Adding a Publisher
-- In this section we’ll add a role for our first publisher, “ABC Open Data, Inc.”
-- First, let’s create a login role named abc_open_data without superuser permissions.
CREATE ROLE abc_open_data WITH NOSUPERUSER LOGIN;