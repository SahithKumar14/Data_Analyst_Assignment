
CREATE TABLE clinics (
  cid VARCHAR PRIMARY KEY,
  clinic_name TEXT,
  city TEXT,
  state TEXT,
  country TEXT
);

CREATE TABLE customer (
  uid VARCHAR PRIMARY KEY,
  name TEXT,
  mobile VARCHAR
);

CREATE TABLE clinic_sales (
  oid VARCHAR PRIMARY KEY,
  uid VARCHAR REFERENCES customer(uid),
  cid VARCHAR REFERENCES clinics(cid),
  amount NUMERIC(12,2),
  datetime TIMESTAMP,
  sales_channel VARCHAR
);

CREATE TABLE expenses (
  eid VARCHAR PRIMARY KEY,
  cid VARCHAR REFERENCES clinics(cid),
  description TEXT,
  amount NUMERIC(12,2),
  datetime TIMESTAMP
);
