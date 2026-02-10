# HR Management System Database

## Overview
This is a PostgreSQL database schema for an HR Management System with integrated Asset Tracking functionality.

## ⚠️ Important Notice
This file contains **sample schema with test data only**. All data including employee names, emails, and passwords are dummy/placeholder values for development and testing purposes.

## Features
- Employee management
- Department and role tracking
- Attendance monitoring
- Leave request management
- Payroll processing
- User account management
- Asset tracking and assignment
- Asset maintenance records

## Database Setup
```bash
# Connect to PostgreSQL
psql -U postgres

# Run the schema
\i hr_management_system.sql
```

## Security
- Never commit real credentials or production data
- Use environment variables for database connections
- Replace dummy passwords with proper hashed passwords in production

## Tables
- `departments` - Department information
- `roles` - Job roles
- `employees` - Employee records
- `hr_staff` - HR personnel
- `attendance` - Daily attendance
- `leave_requests` - Leave applications
- `payroll` - Salary information
- `user_accounts` - System login accounts
- `assets` - Company assets
- `asset_assignments` - Asset allocation to employees
- `asset_history` - Asset activity log
- `asset_maintenance` - Maintenance records
