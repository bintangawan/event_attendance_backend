import express from "express";
import { 
  getPublicEventsList, 
  getPublicEventDetail,
  updateEventDescription,
  uploadGalleryImage,
  deleteGalleryImage,
  getEventGallery
} from "../controllers/eventDetailsController.js";
import upload from "../middlewares/upload.js"; 

const router = express.Router();

// --- PUBLIC ROUTES (No Auth Middleware needed usually, or loose auth) ---
// URL Akhir: /api/eventdetails/public/events
router.get("/public/events", getPublicEventsList);

// URL Akhir: /api/eventdetails/public/:eventCode
router.get("/public/:eventCode", getPublicEventDetail);


// --- ADMIN ROUTES (Auth Required - handled in controller/middleware check usually) ---
// URL: /api/eventdetails/:eventId/description
router.put("/:eventId/description", updateEventDescription);

// URL: /api/eventdetails/:eventId/gallery
router.post("/:eventId/gallery", upload.single("image"), uploadGalleryImage);

// URL: /api/eventdetails/:eventId/gallery
router.get("/:eventId/gallery", getEventGallery);

// URL: /api/eventdetails/gallery/:galleryId
router.delete("/gallery/:galleryId", deleteGalleryImage);

export default router;