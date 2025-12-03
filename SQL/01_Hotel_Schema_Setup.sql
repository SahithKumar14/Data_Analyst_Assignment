CREATE TABLE users (
  user_id VARCHAR PRIMARY KEY,
  name VARCHAR,
  phone_number VARCHAR,
  mail_id VARCHAR,
  billing_address TEXT
);

CREATE TABLE bookings (
  booking_id VARCHAR PRIMARY KEY,
  booking_date TIMESTAMP,
  room_no VARCHAR,
  user_id VARCHAR REFERENCES users(user_id)
);

CREATE TABLE items (
  item_id VARCHAR PRIMARY KEY,
  item_name VARCHAR,
  item_rate NUMERIC(10,2)
);

CREATE TABLE booking_commercials (
  id VARCHAR PRIMARY KEY,
  booking_id VARCHAR REFERENCES bookings(booking_id),
  bill_id VARCHAR,
  bill_date TIMESTAMP,
  item_id VARCHAR REFERENCES items(item_id),
  item_quantity NUMERIC(10,2)
);

-- (Insert sample rows from PDF as needed using INSERT INTO ...)
