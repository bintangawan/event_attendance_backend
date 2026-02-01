import pool from "../config/db.js";

export const getPublicEventByCode = async (req, res) => {
  try {
    const { eventCode } = req.params;

    const [rows] = await pool.execute(
      `SELECT event_id, event_code, nama_event, tanggal_event, 
              jam_masuk_mulai, jam_masuk_selesai, checkin_end_time, status_event
       FROM events
       WHERE event_code = ?
       LIMIT 1`,
      [eventCode]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Event tidak ditemukan" });
    }

    const event = rows[0];

    // hitung apakah check-in masih terbuka
    const now = new Date();
    const checkinEnd = event.checkin_end_time ? new Date(event.checkin_end_time) : null;

    const is_checkin_open =
      event.status_event === "aktif" &&
      checkinEnd &&
      now <= checkinEnd;

    return res.json({
      message: "OK",
      event: {
        ...event,
        is_checkin_open
      }
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Gagal mengambil info event" });
  }
};

// Tambahkan ini di publicController.js
export const getPublicActiveEvents = async (req, res) => {
  try {
    const [rows] = await pool.execute(
      `SELECT event_id, event_code, nama_event, status_event 
       FROM events 
       WHERE status_event = 'aktif' AND checkin_end_time > NOW()`
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Gagal mengambil data event publik" });
  }
};
