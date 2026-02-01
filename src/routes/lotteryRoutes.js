import express from "express";
import { drawWinner, getWinnerHistory, getEligibleParticipants } from "../controllers/lotteryController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = express.Router();

// POST /api/lottery/:eventId -> Melakukan undian
router.post("/:eventId", authMiddleware, drawWinner);

// GET /api/lottery/:eventId/history -> Melihat history
router.get("/:eventId/history", authMiddleware, getWinnerHistory);

// GET /api/lottery/:eventId/eligible -> UNTUK ROULETTE (Sesuaikan ini!)
router.get("/:eventId/eligible", authMiddleware, getEligibleParticipants);

export default router;