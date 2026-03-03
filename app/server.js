require("dotenv").config();
const express = require("express");
const mysql = require("mysql2");
const path = require("path");

const app = express();
const port = 3000;

/* ===============================
   DATABASE CONNECTION
================================= */

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

db.connect((err) => {
  if (err) {
    console.error("❌ Database connection failed:", err.message);
  } else {
    console.log("✅ Connected to MySQL database");
  }
});

/* ===============================
   ROUTES
================================= */

// Home Route (Movie Streaming from S3)
app.get("/", (req, res) => {
  res.send(`
    <html>
      <head>
        <title>Netflix DevOps App</title>
      </head>
      <body style="text-align:center; font-family:Arial;">
        <h1>🎬 Netflix DevOps Streaming App</h1>
        <video width="800" controls>
          <source src="${process.env.MOVIE_URL}" type="video/mp4">
          Your browser does not support video playback.
        </video>
        <br/><br/>
        <a href="/health">Health Check</a> |
        <a href="/db-test">Test DB Connection</a>
      </body>
    </html>
  `);
});

// Health Check Route (For ALB)
app.get("/health", (req, res) => {
  res.status(200).send("OK");
});

// Database Test Route
app.get("/db-test", (req, res) => {
  db.query("SELECT 1 + 1 AS result", (err, results) => {
    if (err) {
      return res.status(500).send("❌ Database query failed");
    }
    res.send(`✅ Database working. Result: ${results[0].result}`);
  });
});

/* ===============================
   START SERVER
================================= */

app.listen(port, () => {
  console.log(`🚀 Server running on port ${port}`);
});
