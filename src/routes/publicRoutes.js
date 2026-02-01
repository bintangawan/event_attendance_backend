import express from "express";
import { getPublicEventByCode, getPublicActiveEvents } from "../controllers/publicController.js";

const router = express.Router();

// URL Full: /api/active-events
router.get("/active-events", getPublicActiveEvents);

// URL Full: /api/checkin/:eventCode
router.get("/checkin/:eventCode", getPublicEventByCode);

export default router;