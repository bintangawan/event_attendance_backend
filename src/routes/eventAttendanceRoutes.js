import express from "express";
import { 
  createManualAttendance, 
  getEventAttendances, 
  deleteAttendance 
} from "../controllers/eventAttendanceController.js";

const router = express.Router();

// Create Manual Attendance (POST /api/attendance/:eventId)
router.post("/:eventId", createManualAttendance);

// Get List (GET /api/attendance/:eventId)
router.get("/:eventId", getEventAttendances);

// Delete Item (DELETE /api/attendance/item/:attendanceId)
router.delete("/item/:attendanceId", deleteAttendance);

export default router;