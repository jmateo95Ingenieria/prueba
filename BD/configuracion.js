
const mysql = require('mysql2/promise');
const config = {
    host: 'localhost',
    user: 'root',
    password: '1234',
    database: 'BANK_SYSTEM',
};

// Create a MySQL pool
const pool = mysql.createPool(config);

module.exports = pool;