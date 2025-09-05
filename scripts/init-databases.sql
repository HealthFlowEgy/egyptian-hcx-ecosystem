-- Initialize databases for Egyptian HCX Ecosystem

-- Create databases
CREATE DATABASE IF NOT EXISTS hcx;
CREATE DATABASE IF NOT EXISTS egyptian_hcx;
CREATE DATABASE IF NOT EXISTS kyc_registry;

-- Create user if not exists
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'hcx_user') THEN

      CREATE ROLE hcx_user LOGIN PASSWORD 'hcx_password';
   END IF;
END
$do$;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE hcx TO hcx_user;
GRANT ALL PRIVILEGES ON DATABASE egyptian_hcx TO hcx_user;
GRANT ALL PRIVILEGES ON DATABASE kyc_registry TO hcx_user;

-- Connect to each database and grant schema privileges
\c hcx;
GRANT ALL ON SCHEMA public TO hcx_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO hcx_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO hcx_user;

\c egyptian_hcx;
GRANT ALL ON SCHEMA public TO hcx_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO hcx_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO hcx_user;

\c kyc_registry;
GRANT ALL ON SCHEMA public TO hcx_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO hcx_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO hcx_user;

