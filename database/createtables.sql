

-- 1. Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    role VARCHAR(30) NOT NULL DEFAULT 'Employee',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    segment ENUM('Premium', 'Regular')
        NOT NULL DEFAULT 'Regular',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Leads table
CREATE TABLE leads (
    lead_id INT PRIMARY KEY AUTO_INCREMENT,
    lead_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    source VARCHAR(50),
    status ENUM(
        'New',
        'Contacted',
        'Qualified',
        'Converted',
        'Lost'
    ) NOT NULL DEFAULT 'New',
    assigned_to INT,
    customer_id INT UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (assigned_to)
        REFERENCES users(user_id),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
-- 4. Interactions table
CREATE TABLE interactions (
    interaction_id INT PRIMARY KEY AUTO_INCREMENT,
    lead_id INT NOT NULL,
    user_id INT NOT NULL,
    interaction_type ENUM('Call', 'Email', 'Meeting')
        NOT NULL,
    notes TEXT,
    interaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (lead_id) REFERENCES leads(lead_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 5. Lead status history table
CREATE TABLE lead_status_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    lead_id INT NOT NULL,
    old_status VARCHAR(30),
    new_status VARCHAR(30) NOT NULL,
    changed_by INT NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (lead_id) REFERENCES leads(lead_id),
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
);

-- 6. Follow-ups table
CREATE TABLE follow_ups (
    follow_up_id INT PRIMARY KEY AUTO_INCREMENT,
    lead_id INT NOT NULL,
    assigned_to INT NOT NULL,
    due_date DATETIME NOT NULL,
    status ENUM('Pending', 'Completed', 'Cancelled')
        NOT NULL DEFAULT 'Pending',
    notes TEXT,

    FOREIGN KEY (lead_id) REFERENCES leads(lead_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id)
);
show tables;