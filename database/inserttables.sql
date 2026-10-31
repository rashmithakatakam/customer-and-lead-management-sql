

INSERT INTO users (user_name, email, role) VALUES
('Rahul', 'rahul@gmail.com', 'Manager'),
('Priya', 'priya@gmail.com', 'Employee'),
('Kiran', 'kiran@gmail.com', 'Employee'),
('Sneha', 'sneha@gmail.com', 'Employee'),
('Arjun', 'arjun@gmail.com', 'Employee'),
('Anjali', 'anjali@gmail.com', 'Manager'),
('Vijay', 'vijay@gmail.com', 'Employee'),
('Meena', 'meena@gmail.com', 'Employee'),
('Ravi', 'ravi@gmail.com', 'Employee'),
('Divya', 'divya@gmail.com', 'Employee');

INSERT INTO customers
(customer_name, phone, email, segment) VALUES
('Anita Sharma', '9000000001', 'anita@gmail.com', 'Premium'),
('Vijay Kumar', '9000000002', 'vijayk@gmail.com', 'Regular'),
('Meena Reddy', '9000000003', 'meena.r@gmail.com', 'Premium'),
('Arun Kumar', '9000000004', 'arunk@gmail.com', 'Regular'),
('Priya Sharma', '9000000005', 'priyas@gmail.com', 'Premium'),
('Ravi Teja', '9000000006', 'ravit@gmail.com', 'Regular'),
('Sneha Rao', '9000000007', 'sneha.r@gmail.com', 'Premium'),
('Kiran Reddy', '9000000008', 'kiran.r@gmail.com', 'Regular'),
('Divya Singh', '9000000009', 'divyas@gmail.com', 'Premium'),
('Ajay Kumar', '9000000010', 'ajayk@gmail.com', 'Regular');

INSERT INTO leads
(lead_name, phone, email, source, status, assigned_to, customer_id)
VALUES
('Suresh', '9100000001', 'suresh@gmail.com', 'Website', 'New', 2, NULL),
('Lakshmi', '9100000002', 'lakshmi@gmail.com', 'Referral', 'Contacted', 3, NULL),
('Naveen', '9100000003', 'naveen@gmail.com', 'Social Media', 'Qualified', 4, NULL),
('Anita Sharma', '9100000004', 'anita.lead@gmail.com', 'Website', 'Converted', 2, 1),
('Ramesh', '9100000005', 'ramesh@gmail.com', 'Advertisement', 'Lost', 5, NULL),
('Vijay Kumar', '9100000006', 'vijay.lead@gmail.com', 'Referral', 'Converted', 3, 2),
('Pooja', '9100000007', 'pooja@gmail.com', 'Website', 'New', 6, NULL),
('Manoj', '9100000008', 'manoj@gmail.com', 'Social Media', 'Contacted', 7, NULL),
('Meena Reddy', '9100000009', 'meena.lead@gmail.com', 'Email Campaign', 'Converted', 8, 3),
('Harish', '9100000010', 'harish@gmail.com', 'Advertisement', 'Qualified', 9, NULL);

INSERT INTO interactions
(lead_id, user_id, interaction_type, notes, interaction_date)
VALUES
(1, 2, 'Call', 'Initial enquiry discussion', '2026-10-01 10:00:00'),
(2, 3, 'Email', 'Sent product information', '2026-10-01 11:00:00'),
(3, 4, 'Meeting', 'Discussed customer requirements', '2026-10-02 12:00:00'),
(4, 2, 'Call', 'Confirmed successful conversion', '2026-10-02 14:00:00'),
(5, 5, 'Email', 'Sent quotation', '2026-10-03 10:30:00'),
(6, 3, 'Meeting', 'Finalized customer requirements', '2026-10-03 15:00:00'),
(7, 6, 'Call', 'First follow-up call', '2026-10-04 09:30:00'),
(8, 7, 'Email', 'Shared pricing details', '2026-10-04 13:00:00'),
(9, 8, 'Meeting', 'Discussed service agreement', '2026-10-05 11:30:00'),
(10, 9, 'Call', 'Qualified the lead', '2026-10-05 16:00:00');

INSERT INTO lead_status_history
(lead_id, old_status, new_status, changed_by, changed_at)
VALUES
(1, NULL, 'New', 2, '2026-10-01 09:00:00'),
(2, 'New', 'Contacted', 3, '2026-10-01 11:00:00'),
(3, 'Contacted', 'Qualified', 4, '2026-10-02 12:00:00'),
(4, 'Qualified', 'Converted', 2, '2026-10-02 14:00:00'),
(5, 'Contacted', 'Lost', 5, '2026-10-03 10:30:00'),
(6, 'Qualified', 'Converted', 3, '2026-10-03 15:00:00'),
(7, NULL, 'New', 6, '2026-10-04 09:00:00'),
(8, 'New', 'Contacted', 7, '2026-10-04 13:00:00'),
(9, 'Qualified', 'Converted', 8, '2026-10-05 11:30:00'),
(10, 'Contacted', 'Qualified', 9, '2026-10-05 16:00:00');

INSERT INTO follow_ups
(lead_id, assigned_to, due_date, status, notes)
VALUES
(1, 2, '2026-10-15 10:00:00', 'Pending', 'Call about requirements'),
(2, 3, '2026-10-16 11:00:00', 'Completed', 'Product details shared'),
(3, 4, '2026-10-17 12:00:00', 'Pending', 'Arrange product demonstration'),
(4, 2, '2026-10-10 14:00:00', 'Completed', 'Conversion confirmed'),
(5, 5, '2026-10-18 10:30:00', 'Cancelled', 'Lead was lost'),
(6, 3, '2026-10-19 15:00:00', 'Completed', 'Agreement finalized'),
(7, 6, '2026-10-20 09:30:00', 'Pending', 'Contact potential customer'),
(8, 7, '2026-10-21 13:00:00', 'Pending', 'Follow up on pricing'),
(9, 8, '2026-10-11 11:30:00', 'Completed', 'Service agreement discussed'),
(10, 9, '2026-10-22 16:00:00', 'Pending', 'Discuss customer needs');