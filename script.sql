-- the database has just one superuser. Write a query that allows you to determine the name of that role.
SELECT rolname
FROM "pg_catalog"."pg_roles"
WHERE rolsuper = TRUE;