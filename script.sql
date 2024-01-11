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

-- Now let’s create a non-superuser group role named publishers and include abc_open_data as a member.
-- We can add multiple publishers to this group role and then manage their permissions by modifying this role.
CREATE ROLE publishers WITH NOSUPERUSER ROLE abc_open_data;

-- # Granting a Publisher Access to Analytics
-- There’s a schema in the database named analytics. All publishers should have access to this schema. Grant USAGE on this schema to publishers
GRANT USAGE ON SCHEMA analytics To publishers;

--Now that publishers has USAGE, write the query that grants publishers the ability to SELECT on all existing tables in analytics.
GRANT SELECT ON ALL TABLES
IN SCHEMA analytics
TO publishers;

-- Check to see how PostgreSQL has recorded the changes to the schema permissions you just updated.
SELECT *
FROM "information_schema"."table_privileges"
WHERE grantee = 'publishers';

-- Let’s confirm that abc_open_data has the ability to SELECT on analytics.downloads through inheritance from publishers.
-- SET your role to abc_open_data and try the query below:
SET ROLE abc_open_data;

SELECT * FROM analytics.downloads;