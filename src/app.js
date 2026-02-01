import express from "express";
import cors from "cors";

import adminRoutes from "./routes/adminRoutes.js";
import eventRoutes from "./routes/eventRoutes.js";
import attendanceRoutes from "./routes/attendanceRoutes.js";
import lotteryRoutes from "./routes/lotteryRoutes.js";
import ticketRoutes from "./routes/ticketRoutes.js";
import publicRoutes from "./routes/publicRoutes.js";

const app = express();

app.use(cors({ origin: "http://localhost:5173" }));
app.use(express.json());

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

export default app;
