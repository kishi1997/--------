const { Pool } = require("pg");

const pool = new Pool({
  host: process.env.POSTGRES_HOST || "127.0.0.1",
  port: Number(process.env.POSTGRES_PORT || 5433),
  user: process.env.POSTGRES_USER || "student",
  password: process.env.POSTGRES_PASSWORD || "student",
  database: process.env.POSTGRES_DB || "database_learning",
});

let queryCount = 0;

async function query(text, params = []) {
  queryCount += 1;
  if (process.env.SHOW_SQL === "1") {
    console.log(`[SQL ${queryCount}] ${text.replace(/\s+/g, " ").trim()}`);
  }
  return pool.query(text, params);
}

function resetQueryCount() {
  queryCount = 0;
}

function getQueryCount() {
  return queryCount;
}

async function close() {
  await pool.end();
}

module.exports = { query, resetQueryCount, getQueryCount, close };
