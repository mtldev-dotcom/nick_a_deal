# PostgreSQL Database Migration Guide - Local to Remote

## Overview
This guide covers how to export a PostgreSQL database from your local development environment and import it to a remote production server.

---

## Prerequisites

- PostgreSQL client tools installed locally
- Access to both local and remote databases
- Connection details for both databases

---

## Database Connection Details Template

**Local Database:**
```
Host: localhost
Port: 5432 (default)
User: postgres
Password: [YOUR_LOCAL_PASSWORD]
Database: [YOUR_LOCAL_DB_NAME]
```

**Remote Database:**
```
Host: [REMOTE_IP_ADDRESS]
Port: [REMOTE_PORT]
User: postgres
Password: [YOUR_REMOTE_PASSWORD]
Database: [YOUR_REMOTE_DB_NAME]
```

---

## Method 1: Fresh Import (Clean Database)

Use this when you want to completely replace the remote database with your local data.

### Step 1: Export Local Database

**Windows PowerShell:**
```powershell
pg_dump -h localhost -U postgres -d [LOCAL_DB_NAME] -f database_backup.sql
```

**Mac/Linux Terminal:**
```bash
pg_dump -h localhost -U postgres -d [LOCAL_DB_NAME] -f database_backup.sql
```

Enter your local database password when prompted.

### Step 2: Connect to Remote Database

```powershell
psql -h [REMOTE_IP] -p [REMOTE_PORT] -U postgres -d [REMOTE_DB_NAME]
```

Enter your remote database password when prompted.

### Step 3: Clean Remote Database

Inside the `psql` prompt, run these commands:

```sql
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
\q
```

**Warning:** This will delete ALL data in the remote database!

### Step 4: Import to Remote Database

```powershell
psql -h [REMOTE_IP] -p [REMOTE_PORT] -U postgres -d [REMOTE_DB_NAME] -f database_backup.sql
```

Enter your remote database password when prompted.

### Step 5: Verify Import

Connect to remote database:
```powershell
psql -h [REMOTE_IP] -p [REMOTE_PORT] -U postgres -d [REMOTE_DB_NAME]
```

Check the data:
```sql
-- List all tables
\dt

-- Check record counts
SELECT COUNT(*) FROM [TABLE_NAME];

-- List all databases
\l

-- Exit
\q
```

---

## Method 2: Data-Only Import (Preserve Schema)

Use this when the remote database already has the correct schema/structure and you only want to update the data.

### Step 1: Export Only Data (No Schema)

```powershell
pg_dump -h localhost -U postgres -d [LOCAL_DB_NAME] --data-only --column-inserts -f database_data.sql
```

### Step 2: Import Data to Remote

```powershell
psql -h [REMOTE_IP] -p [REMOTE_PORT] -U postgres -d [REMOTE_DB_NAME] -f database_data.sql
```

---

## Method 3: Direct Pipe (One Command)

Transfer data directly without creating an intermediate file:

```powershell
pg_dump -h localhost -U postgres -d [LOCAL_DB_NAME] | psql -h [REMOTE_IP] -p [REMOTE_PORT] -U postgres -d [REMOTE_DB_NAME]
```

You'll be prompted for both passwords:
1. Local database password first
2. Remote database password second

---

## Method 4: Using Custom Format (Compressed)

For large databases, use compressed custom format:

### Export:
```powershell
pg_dump -h localhost -U postgres -d [LOCAL_DB_NAME] -F c -f database_backup.dump
```

### Import:
```powershell
pg_restore -h [REMOTE_IP] -p [REMOTE_PORT] -U postgres -d [REMOTE_DB_NAME] --no-owner --no-privileges database_backup.dump
```

---

## Common Issues & Solutions

### Issue: "pg_dump: command not found"

**Solution:** Add PostgreSQL to your PATH:

**Windows:**
1. Find PostgreSQL installation (usually `C:\Program Files\PostgreSQL\[VERSION]\bin`)
2. Add to PATH temporarily:
   ```powershell
   $env:Path += ";C:\Program Files\PostgreSQL\18\bin"
   ```
3. For permanent: Add via System Environment Variables

**Mac:**
```bash
brew install postgresql
```

**Linux:**
```bash
sudo apt-get install postgresql-client
```

---

### Issue: "relation already exists" errors

**Solution:** The remote database already has tables. Use one of these approaches:

**Option A:** Clean the database first (see Method 1, Step 3)

**Option B:** Import only data:
```powershell
pg_dump -h localhost -U postgres -d [LOCAL_DB_NAME] --data-only -f database_data.sql
psql -h [REMOTE_IP] -p [REMOTE_PORT] -U postgres -d [REMOTE_DB_NAME] -f database_data.sql
```

---

### Issue: "unrecognized configuration parameter"

**Cause:** Version mismatch between local and remote PostgreSQL.

**Solution:** Ignore these errors - they're harmless. The import will continue successfully. These are just settings that don't exist in older PostgreSQL versions.

---

### Issue: "could not connect to server"

**Solution:** Check:
1. Remote server is running
2. Firewall allows connections on the PostgreSQL port
3. PostgreSQL is configured to accept remote connections
4. IP address and port are correct

Test connection:
```powershell
# Windows
Test-NetConnection -ComputerName [REMOTE_IP] -Port [REMOTE_PORT]

# Mac/Linux
nc -zv [REMOTE_IP] [REMOTE_PORT]
```

---

### Issue: "password authentication failed"

**Solution:** Verify your password. If using special characters, wrap in quotes:
```powershell
psql -h [REMOTE_IP] -p [REMOTE_PORT] -U postgres -d "[REMOTE_DB_NAME]"
```

---

## Avoiding Password Prompts (Optional)

### Create a `.pgpass` file:

**Windows:** `C:\Users\[USERNAME]\AppData\Roaming\postgresql\pgpass.conf`

**Mac/Linux:** `~/.pgpass`

### Format:
```
hostname:port:database:username:password
```

### Example:
```
localhost:5432:mydb:postgres:local_password
192.168.1.100:5433:proddb:postgres:remote_password
```

### Set Permissions (Mac/Linux only):
```bash
chmod 600 ~/.pgpass
```

---

## Best Practices

### Before Migration:
- ✅ **Backup** both databases before starting
- ✅ **Test** the connection to remote database first
- ✅ **Verify** you have enough disk space on remote server
- ✅ **Note down** all connection details
- ✅ **Check** PostgreSQL versions (local vs remote)

### During Migration:
- ✅ **Monitor** the import process for errors
- ✅ **Don't interrupt** the process unless critical errors occur
- ✅ **Save** the backup file until verified successful

### After Migration:
- ✅ **Verify** data integrity (check record counts)
- ✅ **Test** application connectivity to new database
- ✅ **Run** any necessary post-migration scripts
- ✅ **Update** application configuration with new database URL
- ✅ **Delete** sensitive backup files securely

---

## Useful PostgreSQL Commands

### Inside psql prompt:

```sql
-- List all databases
\l

-- Connect to a database
\c database_name

-- List all tables
\dt

-- Describe a table structure
\d table_name

-- List all schemas
\dn

-- Show current database
SELECT current_database();

-- Show database size
SELECT pg_size_pretty(pg_database_size('database_name'));

-- Show table sizes
SELECT 
    table_name,
    pg_size_pretty(pg_total_relation_size(quote_ident(table_name)))
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY pg_total_relation_size(quote_ident(table_name)) DESC;

-- Count records in a table
SELECT COUNT(*) FROM table_name;

-- Get PostgreSQL version
SELECT version();

-- Exit psql
\q
```

---

## Quick Reference Commands

### Export Entire Database:
```powershell
pg_dump -h localhost -U postgres -d [DB_NAME] -f backup.sql
```

### Import to Remote:
```powershell
psql -h [REMOTE_IP] -p [PORT] -U postgres -d [DB_NAME] -f backup.sql
```

### Export Compressed:
```powershell
pg_dump -h localhost -U postgres -d [DB_NAME] -F c -f backup.dump
```

### Import Compressed:
```powershell
pg_restore -h [REMOTE_IP] -p [PORT] -U postgres -d [DB_NAME] backup.dump
```

### Export Only Data:
```powershell
pg_dump -h localhost -U postgres -d [DB_NAME] --data-only -f data.sql
```

### Export Only Schema:
```powershell
pg_dump -h localhost -U postgres -d [DB_NAME] --schema-only -f schema.sql
```

### Export Specific Table:
```powershell
pg_dump -h localhost -U postgres -d [DB_NAME] -t table_name -f table_backup.sql
```

---

## For MedusaJS Deployments

After importing your database to production:

### 1. Update Environment Variables
```env
DATABASE_URL=postgresql://user:password@host:port/database
```

### 2. Run Migrations (if needed)
```bash
yarn medusa db:migrate
```

### 3. Sync Links
```bash
yarn medusa links:sync
```

### 4. Create Admin User (if needed)
```bash
npx medusa user --email admin@example.com --password yourpassword
```

### 5. Restart Application
Restart your MedusaJS server to connect to the new database.

---

## Security Notes

⚠️ **Important Security Practices:**

1. **Never commit** database credentials to version control
2. **Use strong passwords** for production databases
3. **Limit database access** to specific IP addresses when possible
4. **Encrypt connections** - use SSL/TLS for production
5. **Delete backup files** after successful import
6. **Rotate passwords** regularly
7. **Use environment variables** for credentials in production
8. **Enable database backups** on production server
9. **Monitor database logs** for suspicious activity
10. **Keep PostgreSQL updated** to latest stable version

---

## Troubleshooting Checklist

When something goes wrong:

- [ ] Check PostgreSQL service is running on remote server
- [ ] Verify connection details (host, port, username, database name)
- [ ] Test network connectivity to remote server
- [ ] Confirm firewall rules allow PostgreSQL port
- [ ] Check PostgreSQL logs for errors
- [ ] Verify disk space on remote server
- [ ] Ensure PostgreSQL user has necessary permissions
- [ ] Check PostgreSQL version compatibility
- [ ] Review pg_hba.conf for connection permissions
- [ ] Verify SSL/TLS settings if required

---

## Additional Resources

- **PostgreSQL Documentation:** https://www.postgresql.org/docs/
- **pg_dump Manual:** https://www.postgresql.org/docs/current/app-pgdump.html
- **pg_restore Manual:** https://www.postgresql.org/docs/current/app-pgrestore.html
- **psql Manual:** https://www.postgresql.org/docs/current/app-psql.html

---

## Example: Complete Migration Workflow

Here's a real example from start to finish:

```powershell
# 1. Export local database
pg_dump -h localhost -U postgres -d medusa-shop-local -f medusa_backup.sql
# Enter password: myLocalPass123

# 2. Connect to remote database
psql -h 192.168.1.100 -p 5433 -U postgres -d medusa-shop-prod
# Enter password: myRemotePass456

# 3. Clean remote database (in psql)
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
\q

# 4. Import to remote
psql -h 192.168.1.100 -p 5433 -U postgres -d medusa-shop-prod -f medusa_backup.sql
# Enter password: myRemotePass456

# 5. Verify import
psql -h 192.168.1.100 -p 5433 -U postgres -d medusa-shop-prod

# 6. Check data (in psql)
\dt
SELECT COUNT(*) FROM product;
SELECT COUNT(*) FROM "user";
\q

# 7. Update application config
# Update DATABASE_URL in your app's environment variables

# 8. Restart application
# Restart your MedusaJS server or deployment

# 9. Test application
# Visit your app and verify everything works

# 10. Clean up
# Delete the backup file securely
Remove-Item medusa_backup.sql
```

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Compatible with:** PostgreSQL 12+ (tested on 15.x and 18.x)