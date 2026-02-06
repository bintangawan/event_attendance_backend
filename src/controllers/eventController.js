import pool from "../config/db.js";
import QRCode from "qrcode";
import { v4 as uuidv4 } from "uuid";

/**
 * CREATE EVENT
 */
export const createEvent = async (req, res) => {
  try {
    const {
      nama_event,
      tanggal_event,
      jam_masuk_mulai,
      jam_masuk_selesai,
      checkin_end_time
    } = req.body;

    if (
      !nama_event ||
      !tanggal_event ||
      !jam_masuk_mulai ||
      !jam_masuk_selesai ||
      !checkin_end_time
    ) {
      return res.status(400).json({
        message: "Semua field event wajib diisi"
      });
    }

    const eventCode = "EVT-" + uuidv4().split("-")[0].toUpperCase();

    const [result] = await pool.execute(
      `INSERT INTO events 
       (event_code, nama_event, tanggal_event, 
        jam_masuk_mulai, jam_masuk_selesai, checkin_end_time, status_event) 
       VALUES (?, ?, ?, ?, ?, ?, 'aktif')`,
      [
        eventCode,
        nama_event,
        tanggal_event,
        jam_masuk_mulai,
        jam_masuk_selesai,
        checkin_end_time
      ]
    );

    const checkinUrl = `${process.env.BASE_URL}/checkin/${eventCode}`;
    const qrImage = await QRCode.toDataURL(checkinUrl);

    res.status(201).json({
      message: "Event berhasil dibuat",
      event: {
        event_id: result.insertId,
        event_code: eventCode,
        nama_event,
        tanggal_event,
        jam_masuk_mulai,
        jam_masuk_selesai,
        checkin_end_time,
        status_event: "aktif",
        qr_checkin_url: checkinUrl,
        qr_image: qrImage
      }
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal membuat event"
    });
  }
};

/**
 * GET ALL EVENTS (WITH PAGINATION & FILTER)
 * Tambahan: filter berdasarkan status
 */
export const getAllEvents = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    
    // Filter berdasarkan status (aktif, selesai, draft)
    const statusFilter = req.query.status; // ?status=aktif

    let query = `
      SELECT *,
      CASE 
        WHEN status_event = 'aktif' AND checkin_end_time <= NOW() THEN 'selesai'
        ELSE status_event
      END AS status_event
      FROM events 
    `;

    let countQuery = "SELECT COUNT(*) as total FROM events";
    const queryParams = [];
    const countParams = [];

    // Tambahkan filter status jika ada
    if (statusFilter && ["aktif", "selesai", "draft"].includes(statusFilter)) {
      if (statusFilter === "selesai") {
        // Untuk status selesai: cek yang manual selesai ATAU yang sudah lewat checkin_end_time
        query += " WHERE (status_event = 'selesai' OR (status_event = 'aktif' AND checkin_end_time <= NOW()))";
        countQuery += " WHERE (status_event = 'selesai' OR (status_event = 'aktif' AND checkin_end_time <= NOW()))";
      } else if (statusFilter === "aktif") {
        // Untuk status aktif: yang aktif DAN belum lewat checkin_end_time
        query += " WHERE status_event = 'aktif' AND checkin_end_time > NOW()";
        countQuery += " WHERE status_event = 'aktif' AND checkin_end_time > NOW()";
      } else {
        // Untuk draft
        query += " WHERE status_event = ?";
        countQuery += " WHERE status_event = ?";
        queryParams.push(statusFilter);
        countParams.push(statusFilter);
      }
    }

    query += " ORDER BY created_at DESC LIMIT ? OFFSET ?";
    queryParams.push(limit.toString(), offset.toString());

    const [rows] = await pool.execute(query, queryParams);
    const [countResult] = await pool.execute(countQuery, countParams);
    
    const totalEvents = countResult[0].total;
    const totalPages = Math.ceil(totalEvents / limit);

    res.json({
      data: rows,
      pagination: {
        totalItems: totalEvents,
        totalPages: totalPages,
        currentPage: page,
        itemsPerPage: limit
      },
      filter: {
        status: statusFilter || "all"
      }
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal mengambil data event"
    });
  }
};

/**
 * GET EVENT DETAIL + QR (WITH ACCURATE STATUS)
 * Perbaikan: Status selesai lebih akurat
 */
export const getEventDetail = async (req, res) => {
  try {
    const { id } = req.params;

    const [rows] = await pool.execute(
      `SELECT *,
       CASE 
         WHEN status_event = 'selesai' THEN 'selesai'
         WHEN status_event = 'aktif' AND checkin_end_time <= NOW() THEN 'selesai'
         ELSE status_event
       END AS computed_status
       FROM events WHERE event_id = ?`,
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: "Event tidak ditemukan"
      });
    }

    const event = rows[0];
    const checkinUrl = `${process.env.BASE_URL}/checkin/${event.event_code}`;
    const qrImage = await QRCode.toDataURL(checkinUrl);

    // Gunakan computed_status untuk status yang akurat
    const actualStatus = event.computed_status;

    res.json({
      ...event,
      status_event: actualStatus, // Override dengan status yang akurat
      qr_checkin_url: checkinUrl,
      qr_image: qrImage,
      is_expired: new Date(event.checkin_end_time) <= new Date(), // Flag tambahan
      can_be_activated: actualStatus !== "selesai" && new Date(event.checkin_end_time) > new Date()
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal mengambil detail event"
    });
  }
};

/**
 * UPDATE EVENT DATA
 */
export const updateEvent = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      nama_event,
      tanggal_event,
      jam_masuk_mulai,
      jam_masuk_selesai,
      checkin_end_time
    } = req.body;

    await pool.execute(
      `UPDATE events SET 
        nama_event = ?, 
        tanggal_event = ?, 
        jam_masuk_mulai = ?, 
        jam_masuk_selesai = ?, 
        checkin_end_time = ? 
       WHERE event_id = ?`,
      [
        nama_event,
        tanggal_event,
        jam_masuk_mulai,
        jam_masuk_selesai,
        checkin_end_time,
        id
      ]
    );

    res.json({
      message: "Event berhasil diperbarui"
    });

  } catch (error) {
    res.status(500).json({
      message: "Gagal update event"
    });
  }
};

/**
 * UPDATE STATUS EVENT (WITH VALIDATION)
 * Validasi: Event yang sudah selesai tidak bisa diaktifkan kembali
 */
export const updateEventStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status_event } = req.body;

    if (!["draft", "aktif", "selesai"].includes(status_event)) {
      return res.status(400).json({
        message: "Status event tidak valid. Pilih: draft, aktif, atau selesai"
      });
    }

    // 1. Cek status event saat ini
    const [rows] = await pool.execute(
      `SELECT status_event, checkin_end_time FROM events WHERE event_id = ?`,
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: "Event tidak ditemukan"
      });
    }

    const currentEvent = rows[0];
    const currentStatus = currentEvent.status_event;
    const checkinEndTime = new Date(currentEvent.checkin_end_time);
    const now = new Date();

    // 2. Validasi: Event yang sudah selesai tidak bisa diaktifkan kembali
    if (currentStatus === "selesai" && status_event === "aktif") {
      return res.status(400).json({
        message: "Event yang sudah selesai tidak dapat diaktifkan kembali. Silakan buat event baru."
      });
    }

    // 3. Validasi: Event yang sudah lewat checkin_end_time tidak bisa diaktifkan
    if (status_event === "aktif" && checkinEndTime <= now) {
      return res.status(400).json({
        message: "Waktu check-in event sudah berakhir. Event tidak dapat diaktifkan kembali."
      });
    }

    // 4. Update status
    await pool.execute(
      "UPDATE events SET status_event = ? WHERE event_id = ?",
      [status_event, id]
    );

    res.json({
      message: `Status event berhasil diubah menjadi "${status_event}"`,
      previous_status: currentStatus,
      new_status: status_event
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal update status event"
    });
  }
};

/**
 * DELETE EVENT (WITH CASCADE DELETE)
 * Menghapus event beserta semua data terkait (attendances, gallery, dll)
 */
export const deleteEvent = async (req, res) => {
  const connection = await pool.getConnection();
  
  try {
    const { id } = req.params;

    // Start transaction
    await connection.beginTransaction();

    // 1. Hapus gallery event
    await connection.execute(
      "DELETE FROM event_gallery WHERE event_id = ?",
      [id]
    );

    // 2. Hapus event attendances
    await connection.execute(
      "DELETE FROM event_attendances WHERE event_id = ?",
      [id]
    );

    // 3. Hapus event
    const [result] = await connection.execute(
      "DELETE FROM events WHERE event_id = ?",
      [id]
    );

    if (result.affectedRows === 0) {
      await connection.rollback();
      return res.status(404).json({
        message: "Event tidak ditemukan"
      });
    }

    // Commit transaction
    await connection.commit();

    res.json({
      message: "Event dan semua data terkait berhasil dihapus"
    });

  } catch (error) {
    await connection.rollback();
    console.error(error);
    res.status(500).json({
      message: "Gagal menghapus event"
    });
  } finally {
    connection.release();
  }
};

/**
 * CLOSE CHECKIN NOW (WITH VALIDATION)
 * Validasi: Hanya bisa menutup event yang aktif
 */
export const closeCheckinNow = async (req, res) => {
  try {
    const { id } = req.params;

    // Cek status event
    const [rows] = await pool.execute(
      "SELECT status_event FROM events WHERE event_id = ?",
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: "Event tidak ditemukan"
      });
    }

    if (rows[0].status_event !== "aktif") {
      return res.status(400).json({
        message: "Hanya event dengan status 'aktif' yang dapat ditutup check-in nya"
      });
    }

    // Update checkin_end_time ke NOW dan ubah status jadi selesai
    await pool.execute(
      "UPDATE events SET checkin_end_time = NOW(), status_event = 'selesai' WHERE event_id = ?",
      [id]
    );

    res.json({ 
      message: "Check-in berhasil ditutup dan event diubah menjadi selesai" 
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ 
      message: "Gagal menutup check-in" 
    });
  }
};