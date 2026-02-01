import pool from "../config/db.js";

export const validateTicket = async (req, res) => {
  try {
    const { token } = req.body;

    if (!token) {
      return res.status(400).json({ message: "Token tiket tidak boleh kosong." });
    }

    // Bersihkan token jika hasil scan berupa URL penuh
    // Contoh: "https://web.com/ticket/TCK-123" -> "TCK-123"
    const cleanToken = token.split("/").pop();

    const [rows] = await pool.execute(
      `SELECT 
        ea.ticket_token,
        ea.jam_masuk,
        ea.status_hadir,
        p.nama AS nama_peserta,
        p.alamat AS domisili,
        p.no_hp,
        e.nama_event,
        e.tanggal_event,
        e.jam_masuk_mulai,
        e.jam_masuk_selesai
       FROM event_attendances ea
       JOIN participants p ON ea.participant_id = p.participant_id
       JOIN events e ON ea.event_id = e.event_id
       WHERE ea.ticket_token = ?
       LIMIT 1`,
      [cleanToken]
    );

    if (rows.length === 0) {
      return res.status(404).json({ 
        valid: false, 
        message: "Tiket tidak ditemukan atau tidak valid." 
      });
    }

    const data = rows[0];

    return res.json({
      valid: true,
      message: "Tiket Valid",
      data: {
        token: data.ticket_token,
        peserta: {
          nama: data.nama_peserta,
          domisili: data.domisili,
          no_hp: data.no_hp
        },
        event: {
          nama: data.nama_event,
          tanggal: data.tanggal_event,
          waktu_scan: data.jam_masuk
        }
      }
    });

  } catch (error) {
    console.error("Validator Error:", error);
    res.status(500).json({ message: "Terjadi kesalahan server." });
  }
};