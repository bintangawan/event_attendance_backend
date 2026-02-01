import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";

// FIX path untuk ES Module
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// arahkan dotenv ke root project
dotenv.config({
  path: path.resolve(__dirname, "../.env")
});

import app from "./app.js";

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
