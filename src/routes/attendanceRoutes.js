import express from "express";
import { checkInParticipant, getAttendanceByEvent } from "../controllers/attendanceController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = express.Router();

router.post("/checkin/:eventCode", checkInParticipant);
router.get("/event/:eventId", authMiddleware, getAttendanceByEvent);


export default router;
