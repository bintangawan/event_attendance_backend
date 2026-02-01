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
 * GET ALL EVENTS (WITH PAGINATION)
 */
export const getAllEvents = async (req, res) => {
  try {
    // 1. Get page and limit from query params (default: page 1, limit 10)
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;

    // 2. Fetch data with LIMIT and OFFSET
    // We use CAST/String for limit/offset parameters to ensure compatibility with some mysql drivers
    const query = `
      SELECT *,
      CASE 
        WHEN status_event = 'aktif' AND checkin_end_time <= NOW() THEN 'selesai'
        ELSE status_event
      END AS status_event
      FROM events 
      ORDER BY created_at DESC
      LIMIT ? OFFSET ?
    `;
    
    const [rows] = await pool.execute(query, [limit.toString(), offset.toString()]);

    // 3. Count total items for pagination metadata
    const [countResult] = await pool.execute("SELECT COUNT(*) as total FROM events");
    const totalEvents = countResult[0].total;
    const totalPages = Math.ceil(totalEvents / limit);

    // 4. Send response with pagination data
    res.json({
      data: rows,
      pagination: {
        totalItems: totalEvents,
        totalPages: totalPages,
        currentPage: page,
        itemsPerPage: limit
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
 * GET EVENT DETAIL + QR
 */
export const getEventDetail = async (req, res) => {
  try {
    const { id } = req.params;

    const [rows] = await pool.execute(
      `SELECT *,
       CASE 
         WHEN status_event = 'aktif' AND checkin_end_time <= NOW() THEN 'selesai'
         ELSE status_event
       END AS status_event
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

    res.json({
      ...event,
      qr_checkin_url: checkinUrl,
      qr_image: qrImage
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
 * UPDATE STATUS EVENT
 */
export const updateEventStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status_event } = req.body;

    if (!["draft", "aktif", "selesai"].includes(status_event)) {
      return res.status(400).json({
        message: "Status event tidak valid"
      });
    }

    await pool.execute(
      "UPDATE events SET status_event = ? WHERE event_id = ?",
      [status_event, id]
    );

    res.json({
      message: "Status event berhasil diubah"
    });

  } catch (error) {
    res.status(500).json({
      message: "Gagal update status event"
    });
  }
};

/**
 * DELETE EVENT
 */
export const deleteEvent = async (req, res) => {
  try {
    const { id } = req.params;

    await pool.execute(
      "DELETE FROM events WHERE event_id = ?",
      [id]
    );

    res.json({
      message: "Event berhasil dihapus"
    });

  } catch (error) {
    res.status(500).json({
      message: "Gagal menghapus event"
    });
  }
};

export const closeCheckinNow = async (req, res) => {
  try {
    const { id } = req.params;

    await pool.execute(
      "UPDATE events SET checkin_end_time = NOW() WHERE event_id = ?",
      [id]
    );

    res.json({ message: "Check-in berhasil ditutup sekarang" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Gagal menutup check-in" });
  }
};