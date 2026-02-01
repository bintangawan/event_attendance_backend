import express from "express";
import { getTicketByToken } from "../controllers/ticketController.js";

const router = express.Router();

router.get("/:token", getTicketByToken);

export default router;
