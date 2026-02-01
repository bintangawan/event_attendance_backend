import express from "express";
import { 
  getLandingPageDetails, 
  updateEventDescription,
  uploadGalleryImage,
  deleteGalleryImage,
  getEventGallery // <--- JANGAN LUPA IMPORT INI
} from "../controllers/eventDetailsController.js";
import upload from "../middlewares/upload.js"; 

const router = express.Router();

// PUBLIC
router.get("/", getLandingPageDetails);

// ADMIN
router.put("/:eventId/description", updateEventDescription);
router.post("/:eventId/gallery", upload.single("image"), uploadGalleryImage);
router.delete("/gallery/:galleryId", deleteGalleryImage);

// ROUTE BARU KHUSUS ADMIN GALLERY
router.get("/:eventId/gallery", getEventGallery); // <--- TAMBAHKAN INI

export default router;