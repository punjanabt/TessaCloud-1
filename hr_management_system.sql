-- ============================================
-- Database: HR Management System
-- ============================================

CREATE DATABASE hr_management_system;

-- Connect to database
\c hr_management_system;

-- ============================================
-- Table: departments
-- ============================================
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_code VARCHAR(20) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: roles
-- ============================================
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL,
    role_description TEXT
);

-- ============================================
-- Table: employees
-- ============================================
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    employee_code VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(15),
    department_id INT,
    role_id INT,
    date_of_joining DATE NOT NULL,
    employment_status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (employment_status IN ('ACTIVE', 'INACTIVE', 'TERMINATED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_role ON employees(role_id);

-- ============================================
-- Table: hr_staff
-- ============================================
CREATE TABLE hr_staff (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    hr_level VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE INDEX idx_hr_staff_employee ON hr_staff(employee_id);

-- ============================================
-- Table: attendance
-- ============================================
CREATE TABLE attendance (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in_time TIME,
    check_out_time TIME,
    attendance_status VARCHAR(20) CHECK (attendance_status IN ('PRESENT', 'ABSENT', 'HALF_DAY', 'LEAVE')),
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE INDEX idx_attendance_employee ON attendance(employee_id);
CREATE INDEX idx_attendance_date ON attendance(attendance_date);

-- ============================================
-- Table: leave_requests
-- ============================================
CREATE TABLE leave_requests (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    reason TEXT,
    approval_status VARCHAR(20) DEFAULT 'PENDING' CHECK (approval_status IN ('PENDING', 'APPROVED', 'REJECTED')),
    approved_by_hr_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    FOREIGN KEY (approved_by_hr_id) REFERENCES hr_staff(id)
);

CREATE INDEX idx_leave_requests_employee ON leave_requests(employee_id);
CREATE INDEX idx_leave_requests_hr ON leave_requests(approved_by_hr_id);

-- ============================================
-- Table: payroll
-- ============================================
CREATE TABLE payroll (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    basic_salary NUMERIC(10,2),
    allowances NUMERIC(10,2),
    deductions NUMERIC(10,2),
    net_salary NUMERIC(10,2),
    salary_month VARCHAR(20),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE INDEX idx_payroll_employee ON payroll(employee_id);

-- ============================================
-- Table: user_accounts
-- ============================================
CREATE TABLE user_accounts (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    user_type VARCHAR(20) CHECK (user_type IN ('EMPLOYEE', 'HR', 'ADMIN')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE INDEX idx_user_accounts_employee ON user_accounts(employee_id);

-- ============================================
-- Dummy Data Insertion
-- ============================================

-- Departments
INSERT INTO departments (department_name, department_code) VALUES
('Human Resources', 'HR'),
('Engineering', 'ENG'),
('Finance', 'FIN'),
('Marketing', 'MKT'),
('Operations', 'OPS');

-- Roles
INSERT INTO roles (role_name, role_description) VALUES
('Software Engineer', 'Develops and maintains applications'),
('HR Manager', 'Manages HR operations'),
('Accountant', 'Handles financial records'),
('Team Lead', 'Leads engineering teams'),
('Operations Executive', 'Manages daily operations');

-- Employees
INSERT INTO employees (employee_code, first_name, last_name, email, phone, department_id, role_id, date_of_joining) VALUES
('EMP001', 'Amit', 'Sharma', 'amit.sharma@company.com', '9876543210', 2, 1, '2023-01-10'),
('EMP002', 'Priya', 'Verma', 'priya.verma@company.com', '9876543211', 1, 2, '2022-06-15'),
('EMP003', 'Rahul', 'Mehta', 'rahul.mehta@company.com', '9876543212', 3, 3, '2021-03-20'),
('EMP004', 'Sneha', 'Iyer', 'sneha.iyer@company.com', '9876543213', 2, 4, '2023-08-01'),
('EMP005', 'Karan', 'Singh', 'karan.singh@company.com', '9876543214', 5, 5, '2022-11-11');

-- HR Staff
INSERT INTO hr_staff (employee_id, hr_level) VALUES
(2, 'Senior HR');

-- Attendance
INSERT INTO attendance (employee_id, attendance_date, check_in_time, check_out_time, attendance_status) VALUES
(1, '2026-02-01', '09:15', '18:05', 'PRESENT'),
(2, '2026-02-01', '09:00', '18:00', 'PRESENT'),
(3, '2026-02-01', NULL, NULL, 'ABSENT'),
(4, '2026-02-01', '09:30', '17:45', 'PRESENT');

-- Leave Requests
INSERT INTO leave_requests (employee_id, leave_type, start_date, end_date, reason, approval_status, approved_by_hr_id) VALUES
(3, 'Sick Leave', '2026-02-02', '2026-02-03', 'Fever', 'APPROVED', 1),
(5, 'Casual Leave', '2026-02-05', '2026-02-05', 'Personal work', 'PENDING', NULL);

-- Payroll
INSERT INTO payroll (employee_id, basic_salary, allowances, deductions, net_salary, salary_month) VALUES
(1, 50000, 5000, 2000, 53000, 'January 2026'),
(2, 60000, 6000, 3000, 63000, 'January 2026'),
(3, 45000, 4000, 1500, 47500, 'January 2026');

-- User Accounts
INSERT INTO user_accounts (employee_id, username, password_hash, user_type) VALUES
(1, 'amit.sharma', 'hashed_password_1', 'EMPLOYEE'),
(2, 'priya.verma', 'hashed_password_2', 'HR'),
(4, 'sneha.iyer', 'hashed_password_3', 'ADMIN');

-- ============================================
-- Table: assets (AssetTrack System)
-- ============================================
CREATE TABLE assets (
    id SERIAL PRIMARY KEY,
    asset_code VARCHAR(50) UNIQUE NOT NULL,
    asset_name VARCHAR(150) NOT NULL,
    asset_type VARCHAR(100),
    serial_number VARCHAR(100) UNIQUE,
    manufacturer VARCHAR(100),
    purchase_date DATE,
    purchase_cost NUMERIC(12,2),
    depreciation_rate NUMERIC(5,2),
    location VARCHAR(200),
    asset_status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (asset_status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE', 'DISPOSED')),
    condition_status VARCHAR(20) DEFAULT 'GOOD' CHECK (condition_status IN ('NEW', 'GOOD', 'FAIR', 'POOR', 'DAMAGED')),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_assets_updated_at
BEFORE UPDATE ON assets
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- Table: asset_assignments (AssetTrack System)
-- ============================================
CREATE TABLE asset_assignments (
    id SERIAL PRIMARY KEY,
    asset_id INT NOT NULL,
    employee_id INT NOT NULL,
    assignment_date DATE NOT NULL,
    return_date DATE,
    assignment_status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (assignment_status IN ('ACTIVE', 'RETURNED', 'LOST', 'DAMAGED')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(id),
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE INDEX idx_asset_assignments_asset ON asset_assignments(asset_id);
CREATE INDEX idx_asset_assignments_employee ON asset_assignments(employee_id);

-- ============================================
-- Table: asset_history (AssetTrack System)
-- ============================================
CREATE TABLE asset_history (
    id SERIAL PRIMARY KEY,
    asset_id INT NOT NULL,
    employee_id INT,
    action_type VARCHAR(50),
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT,
    FOREIGN KEY (asset_id) REFERENCES assets(id),
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE INDEX idx_asset_history_asset ON asset_history(asset_id);
CREATE INDEX idx_asset_history_employee ON asset_history(employee_id);

-- ============================================
-- Table: asset_maintenance (AssetTrack System)
-- ============================================
CREATE TABLE asset_maintenance (
    id SERIAL PRIMARY KEY,
    asset_id INT NOT NULL,
    maintenance_type VARCHAR(50),
    maintenance_date DATE,
    completion_date DATE,
    cost NUMERIC(10,2),
    notes TEXT,
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(id)
);

CREATE INDEX idx_asset_maintenance_asset ON asset_maintenance(asset_id);

-- ============================================
-- Dummy Data Insertion - AssetTrack System
-- ============================================

-- Assets
INSERT INTO assets (asset_code, asset_name, asset_type, serial_number, manufacturer, purchase_date, purchase_cost, depreciation_rate, location, asset_status, condition_status) VALUES
('AST001', 'Dell Laptop', 'Computer', 'DL123456', 'Dell', '2024-01-15', 75000, 15, 'Engineering Dept', 'ACTIVE', 'GOOD'),
('AST002', 'HP Laptop', 'Computer', 'HP987654', 'HP', '2023-06-20', 65000, 15, 'Finance Dept', 'ACTIVE', 'GOOD'),
('AST003', 'Office Chair', 'Furniture', 'CH555666', 'Herman Miller', '2022-03-10', 12000, 10, 'HR Dept', 'ACTIVE', 'FAIR'),
('AST004', 'Standing Desk', 'Furniture', 'DK111222', 'Steelcase', '2024-02-05', 25000, 8, 'Engineering Dept', 'ACTIVE', 'NEW'),
('AST005', 'Company Vehicle', 'Vehicle', 'VH789456', 'Maruti', '2020-11-01', 800000, 15, 'Operations', 'MAINTENANCE', 'FAIR');

-- Asset Assignments
INSERT INTO asset_assignments (asset_id, employee_id, assignment_date, assignment_status) VALUES
(1, 1, '2024-02-01', 'ACTIVE'),
(2, 2, '2024-01-10', 'ACTIVE'),
(3, 2, '2023-08-15', 'ACTIVE'),
(4, 4, '2024-02-05', 'ACTIVE'),
(5, 5, '2023-12-20', 'ACTIVE');

-- Asset History
INSERT INTO asset_history (asset_id, employee_id, action_type, details) VALUES
(1, 1, 'ASSIGNED', 'Assigned to Amit Sharma'),
(2, 2, 'ASSIGNED', 'Assigned to Priya Verma'),
(3, 2, 'ASSIGNED', 'Assigned to Priya Verma'),
(4, 4, 'ASSIGNED', 'Assigned to Sneha Iyer'),
(5, 5, 'ASSIGNED', 'Assigned to Karan Singh');

-- Asset Maintenance
INSERT INTO asset_maintenance (asset_id, maintenance_type, maintenance_date, cost, status) VALUES
(5, 'Oil Change', '2026-02-05', 3000, 'PENDING'),
(3, 'Upholstery Repair', '2026-01-28', 1500, 'COMPLETED');

-- ============================================
-- END OF DATABASE DUMP
-- ============================================
