-- the database has just one superuser. Write a query that allows you to determine the name of that role.
SELECT rolname
FROM "pg_catalog"."pg_roles"
WHERE rolsuper = TRUE;

-- What are the names of the other users in the database? What permissions do these roles have (e.g. rolcreaterole, rolcanlogin, rolcreatedb, etc.)?
SELECT *
FROM "pg_catalog"."pg_roles";