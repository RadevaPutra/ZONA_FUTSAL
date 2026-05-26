const { Pool } = require('pg');

const pool = new Pool({
  user: 'anom',
  host: 'localhost',
  database: 'zonafutsal_db',
  password: 'admin123',
  port: 5432,
})

module.exports = pool;