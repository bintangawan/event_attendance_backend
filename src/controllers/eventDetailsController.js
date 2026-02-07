import pool from "../config/db.js";
import fs from "fs";
import path from "path";

/**
 * 1. PUBLIC: GET LANDING PAGE DATA
 * Mengambil event aktif + deskripsi + gallery + LIST PESERTA HADIR
 */

export const getPublicEventsList = async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT event_id, event_code, nama_event, tanggal_event, 
              jam_masuk_mulai, jam_masuk_selesai, status_event, description, 
              checkin_end_time  /* <--- TAMBAHKAN INI */
       FROM events 
       WHERE status_event IN ('aktif', 'selesai')
       ORDER BY FIELD(status_event, 'aktif', 'selesai'), tanggal_event DESC`
    );

    res.json({
      message: "Berhasil memuat daftar event",
      data: rows
    });
  } catch (error) {
    console.error("Error Public Events List:", error);
    res.status(500).json({ message: "Gagal memuat daftar event" });
  }
};

/**
 * 2. PUBLIC: GET SPECIFIC EVENT DETAIL (SCAN PAGE)
 * Mengambil detail berdasarkan EVENT CODE (dari URL parameter)
 */
export const getPublicEventDetail = async (req, res) => {
  try {
    const { eventCode } = req.params; // Ambil dari params

    // A. Cari Event berdasarkan CODE
    const [events] = await pool.query(
      `SELECT event_id, event_code, nama_event, tanggal_event, jam_masuk_mulai, 
              jam_masuk_selesai, description, checkin_end_time, status_event
       FROM events 
       WHERE event_code = ? LIMIT 1`,
      [eventCode],
    );

    if (events.length === 0) {
      return res.status(404).json({ message: "Event tidak ditemukan" });
    }

    const activeEvent = events[0];

    // Cek apakah event sebenarnya sudah "selesai" secara waktu meskipun statusnya 'aktif'
    const isExpired = new Date(activeEvent.checkin_end_time) <= new Date();
    if (activeEvent.status_event === "aktif" && isExpired) {
      activeEvent.status_event = "selesai"; // Override status untuk tampilan frontend
    }

    // B. Ambil Gallery
    const [galleryRows] = await pool.query(
      `SELECT gallery_id, image_url, caption FROM event_gallery WHERE event_id = ? ORDER BY created_at DESC`,
      [activeEvent.event_id],
    );

    const gallery = galleryRows.map((item) => ({
      id: item.gallery_id,
      src: `${process.env.BASE_URL || "http://localhost:5000"}${item.image_url}`,
      caption: item.caption || "Event Documentation",
    }));

    // C. Ambil List Peserta Hadir
    const [attendeeRows] = await pool.query(
      `SELECT p.nama, ea.status_konsumsi, ea.jam_masuk
       FROM event_attendances ea
       JOIN participants p ON ea.participant_id = p.participant_id
       WHERE ea.event_id = ? AND ea.status_hadir = 1
       ORDER BY ea.jam_masuk DESC`,
      [activeEvent.event_id],
    );

    res.json({
      message: "Berhasil memuat data",
      data: {
        event: activeEvent,
        description: activeEvent.description || "Selamat datang.",
        gallery: gallery,
        attendees: attendeeRows,
      },
    });
  } catch (error) {
    console.error("Error Event Detail:", error);
    res.status(500).json({ message: "Gagal memuat detail event" });
  }
};
export const getLandingPageDetails = async (req, res) => {
  try {
    // Gunakan pool.query (bukan execute) untuk stabilitas
    const [events] = await pool.query(
      `SELECT event_id, event_code, nama_event, tanggal_event, jam_masuk_mulai, 
              jam_masuk_selesai, description, checkin_end_time 
       FROM events 
       WHERE status_event = 'aktif' 
       ORDER BY created_at DESC LIMIT 1`,
    );

    let activeEvent = null;
    let gallery = [];
    let attendees = [];
    let description = "Selamat datang di sistem absensi event.";

    if (events.length > 0) {
      activeEvent = events[0];
      if (activeEvent.description) {
        description = activeEvent.description;
      }

      // Ambil Gallery
      const [galleryRows] = await pool.query(
        `SELECT gallery_id, image_url, caption FROM event_gallery WHERE event_id = ? ORDER BY created_at DESC`,
        [activeEvent.event_id],
      );

      gallery = galleryRows.map((item) => ({
        id: item.gallery_id,
        src: `${process.env.BASE_URL || "http://localhost:5000"}${item.image_url}`,
        caption: item.caption || "Event Documentation",
      }));

      // Ambil List Peserta Hadir (status_hadir = 1)
      const [attendeeRows] = await pool.query(
        `SELECT p.nama, ea.status_konsumsi, ea.jam_masuk
         FROM event_attendances ea
         JOIN participants p ON ea.participant_id = p.participant_id
         WHERE ea.event_id = ? AND ea.status_hadir = 1
         ORDER BY ea.jam_masuk DESC`,
        [activeEvent.event_id],
      );

      attendees = attendeeRows;
    }

    res.json({
      message: "Berhasil memuat data",
      data: {
        event: activeEvent,
        description: description,
        gallery: gallery,
        attendees: attendees,
      },
    });
  } catch (error) {
    console.error("Error Landing Details:", error);
    // Kirim response error JSON agar frontend tidak hang
    res.status(500).json({ message: "Gagal memuat detail event" });
  }
};

/**
 * 2. ADMIN: UPDATE EVENT DESCRIPTION
 */
export const updateEventDescription = async (req, res) => {
  try {
    const { eventId } = req.params;
    const { description } = req.body;

    await pool.execute("UPDATE events SET description = ? WHERE event_id = ?", [
      description,
      eventId,
    ]);

    res.json({ message: "Deskripsi event berhasil diperbarui" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal update deskripsi" });
  }
};

/**
 * 3. ADMIN: UPLOAD GALLERY IMAGE
 */
export const uploadGalleryImage = async (req, res) => {
  try {
    const { eventId } = req.params;
    const { caption } = req.body;

    if (!req.file) {
      return res.status(400).json({ message: "Tidak ada file yang diupload" });
    }

    // Path yang disimpan di DB: /uploads/namafile.jpg
    const imageUrl = `/uploads/${req.file.filename}`;

    const [result] = await pool.execute(
      "INSERT INTO event_gallery (event_id, image_url, caption) VALUES (?, ?, ?)",
      [eventId, imageUrl, caption || ""],
    );

    res.status(201).json({
      message: "Gambar berhasil diupload",
      data: {
        gallery_id: result.insertId,
        image_url: imageUrl,
        full_url: `${process.env.BASE_URL || "http://localhost:5000"}${imageUrl}`,
        caption: caption,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal upload gambar" });
  }
};

/**
 * 4. ADMIN: DELETE GALLERY IMAGE
 */
export const deleteGalleryImage = async (req, res) => {
  try {
    const { galleryId } = req.params;

    // 1. Cari info file dulu untuk dihapus dari folder
    const [rows] = await pool.execute(
      "SELECT image_url FROM event_gallery WHERE gallery_id = ?",
      [galleryId],
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Gambar tidak ditemukan" });
    }

    const imageUrl = rows[0].image_url; // ex: /uploads/123.jpg

    // 2. Hapus dari Database
    await pool.execute("DELETE FROM event_gallery WHERE gallery_id = ?", [
      galleryId,
    ]);

    // 3. Hapus File Fisik
    // Konversi URL ke Path System: public/uploads/123.jpg
    const filePath = path.join("public", imageUrl);
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }

    res.json({ message: "Gambar berhasil dihapus" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal menghapus gambar" });
  }
};

// ... (kode sebelumnya tetap sama)

/**
 * 5. ADMIN: GET SPECIFIC EVENT GALLERY
 * Mengambil gallery berdasarkan event_id tertentu
 */
export const getEventGallery = async (req, res) => {
  try {
    const { eventId } = req.params;

    const [rows] = await pool.execute(
      "SELECT gallery_id, image_url, caption, created_at FROM event_gallery WHERE event_id = ? ORDER BY created_at DESC",
      [eventId],
    );

    const gallery = rows.map((item) => ({
      id: item.gallery_id,
      src: `${process.env.BASE_URL || "http://localhost:5000"}${item.image_url}`,
      caption: item.caption || "",
    }));

    res.json({
      message: "Berhasil mengambil gallery",
      data: gallery,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal mengambil data gallery" });
  }
};
