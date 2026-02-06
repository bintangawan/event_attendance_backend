import express from "express";
import { scanConsumption } from "../controllers/consumptionController.js";

const router = express.Router();

// Update route menerima eventId
router.post("/claim/:eventId", scanConsumption);

export default router;