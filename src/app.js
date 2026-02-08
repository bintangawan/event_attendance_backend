import express from "express";
import cors from "cors";
import path from "path"; // Tambahkan ini untuk path static

import adminRoutes from "./routes/adminRoutes.js";
import eventRoutes from "./routes/eventRoutes.js";
import attendanceRoutes from "./routes/attendanceRoutes.js";
import lotteryRoutes from "./routes/lotteryRoutes.js";
import ticketRoutes from "./routes/ticketRoutes.js";
import publicRoutes from "./routes/publicRoutes.js";
import eventDetailsRoutes from "./routes/eventDetailsRoutes.js";
import ticketValidatorRoutes from "./routes/ticketValidatorRoutes.js";
import eventAttendanceRoutes from "./routes/eventAttendanceRoutes.js";
import consumptionRoutes from "./routes/consumptionRoutes.js";

const app = express();

app.use(cors({ origin: "https://event.bintangin.com" }));
app.use(express.json());

// 2. CONFIG STATIC FOLDER (Agar gambar bisa dibuka di browser)
// Pastikan folder 'public/uploads' ada di root project backend kamu
app.use("/uploads", express.static("public/uploads"));

app.get("/", (req, res) => {
  res.json({ message: "Event Attendance API running 🚀" });
});

// routes
app.use("/api/admin", adminRoutes);
app.use("/api/events", eventRoutes);
app.use("/api/attendance", attendanceRoutes);
app.use("/api/lottery", lotteryRoutes);
app.use("/ticket", ticketRoutes);
app.use("/api", publicRoutes);
app.use("/api/eventdetails", eventDetailsRoutes);
app.use("/api/validator", ticketValidatorRoutes);
app.use("/api/attendance", eventAttendanceRoutes);
app.use("/api/consumption", consumptionRoutes);

export default app;