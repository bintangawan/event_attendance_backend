import pool from "../config/db.js";

/**
 * SCAN KONSUMSI (Claim Meal)
 */
export const scanConsumption = async (req, res) => {
  try {
    const { eventId } = req.params; // Ambil eventId dari URL
    const { token } = req.body;

    if (!token) {
      return res.status(400).json({ message: "Token tiket tidak terbaca." });
    }

    const cleanToken = token.split("/").pop();

    // 1. Cek Validitas Tiket & STATUS HADIR
    const [rows] = await pool.execute(
      `SELECT 
        ea.attendance_id, 
        ea.event_id, 
        ea.status_konsumsi, 
        ea.status_hadir,      
        ea.jam_ambil_konsumsi,
        p.nama,
        e.nama_event
       FROM event_attendances ea
       JOIN participants p ON ea.participant_id = p.participant_id
       JOIN events e ON ea.event_id = e.event_id
       WHERE ea.ticket_token = ? 
       LIMIT 1`,
      [cleanToken]
    );

    if (rows.length === 0) {
      return res.status(404).json({ 
        success: false, 
        message: "Tiket tidak ditemukan / Tidak valid." 
      });
    }

    const data = rows[0];

    // --- LOGIKA BARU: CEK KESESUAIAN EVENT ---
    if (Number(data.event_id) !== Number(eventId)) {
        return res.status(400).json({
            success: false,
            code: "WRONG_EVENT",
            message: `Tiket ini bukan untuk event ini. (Tiket Event: ${data.nama_event})`
        });
    }

    // --- LOGIKA BARU: CEK KEHADIRAN DULU ---
    if (Number(data.status_hadir) === 0) {
        return res.status(403).json({
            success: false,
            code: "NOT_PRESENT",
            message: "Peserta BELUM Registrasi Ulang (Check-in). Harap arahkan ke meja registrasi dahulu."
        });
    }

    // 2. Cek Apakah Sudah Mengambil Konsumsi?
    if (data.status_konsumsi === 1) {
      return res.json({
        success: false, 
        code: "DUPLICATE", 
        message: "KONSUMSI SUDAH DIAMBIL!",
        detail: {
          nama: data.nama,
          jam_ambil: data.jam_ambil_konsumsi
        }
      });
    }

    // 3. Update Status Konsumsi Jadi 1
    await pool.execute(
      `UPDATE event_attendances 
       SET status_konsumsi = 1, jam_ambil_konsumsi = NOW() 
       WHERE attendance_id = ?`,
      [data.attendance_id]
    );

    res.json({
      success: true,
      code: "SUCCESS",
      message: "Konsumsi Berhasil Diambil",
      data: {
        nama: data.nama,
        event: data.nama_event,
        jam: new Date()
      }
    });

  } catch (error) {
    console.error("Consumption Error:", error);
    res.status(500).json({ message: "Terjadi kesalahan server." });
  }
};