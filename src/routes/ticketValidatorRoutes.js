import express from "express";
import { validateTicket } from "../controllers/ticketValidatorController.js";
// Jika ingin memproteksi halaman ini hanya untuk admin, import authMiddleware
// import authMiddleware from "../middlewares/authMiddleware.js";

const router = express.Router();

// Public access (atau tambahkan authMiddleware jika khusus admin)
router.post("/validate", validateTicket);

export default router;