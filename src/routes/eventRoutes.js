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

// Create
router.post("/", authMiddleware, createEvent);

// Get All (Support ?page=1&limit=10&status=aktif&search=nama)
router.get("/", authMiddleware, getAllEvents);

// Detail
router.get("/:id", authMiddleware, getEventDetail);

// Update Info
router.put("/:id", authMiddleware, updateEvent);

// Update Status (Aktif/Selesai)
router.patch("/:id/status", authMiddleware, updateEventStatus);

// Close Checkin Manual
router.patch("/:id/close-checkin", authMiddleware, closeCheckinNow);

// Delete (Cascade)
router.delete("/:id", authMiddleware, deleteEvent);

export default router;