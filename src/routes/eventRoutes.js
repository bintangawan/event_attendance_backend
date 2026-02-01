import express from "express";
import {
  createEvent,
  getAllEvents,
  getEventDetail,
  updateEvent,
  updateEventStatus,
  deleteEvent,
  closeCheckinNow 
} from "../controllers/eventController.js";

import authMiddleware from "../middlewares/authMiddleware.js";

const router = express.Router();

router.post("/", authMiddleware, createEvent);
router.get("/", authMiddleware, getAllEvents);
router.get("/:id", authMiddleware, getEventDetail);
router.put("/:id", authMiddleware, updateEvent);
router.patch("/:id/status", authMiddleware, updateEventStatus);
router.delete("/:id", authMiddleware, deleteEvent);
router.patch("/:id/close-checkin", authMiddleware, closeCheckinNow);

export default router;
