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

SET ROLE postgres;

-- # Granting a Publisher Access to Dataset Listings
-- There is a table named directory.datasets in the database with the following schema. SELECT from this table to see a few sample rows.
SELECT * FROM directory.datasets LIMIT 5;

-- Grant USAGE on directory to publishers. This statement should be almost identical to the way that we granted USAGE on analytics.
GRANT USAGE ON SCHEMA directory TO publishers;

-- Let’s write a statement to GRANT SELECT on all columns in this table (except data_checksum) to publishers.
GRANT SELECT(id, create_date, hosting_path, publisher, src_size)
ON TABLE directory.datasets
TO publishers;

-- Let’s mimic what might happen if a publisher tries to query the dataset directory for all dataset names and paths.
SET ROLE abc_open_data;

SELECT id, publisher, hosting_path, data_checksum 
FROM directory.datasets;

SELECT id, publisher, hosting_path 
FROM directory.datasets;

SET ROLE postgres;

-- # Adding Row Level Security on Downloads Data
-- Although we’re designing a collaborative data environment, we may want to implement some degree of privacy between publishers.
-- Let’s implement row level security on analytics.downloads. Create and enable policy that says that the current_user must be the publisher of the dataset to SELECT.
CREATE POLICY user_downloads_policy
ON analytics.downloads
FOR SELECT TO publishers
USING (current_user = owner);

ALTER TABLE analytics.downloads
ENABLE ROW LEVEL SECURITY;

-- Write a query to SELECT the first few rows of this table. Now SET your role to abc_open_data and re-run the same query, are the results the same?
SELECT * FROM analytics.downloads LIMIT 10;

SET ROLE abc_open_data;
SELECT * FROM analytics.downloads LIMIT 10;

SET ROLE postgres;