import pool from "../config/db.js";

/**
 * GET ELIGIBLE PARTICIPANTS FOR LOTTERY
 * Mengambil semua peserta yang hadir dan belum pernah menang di event tertentu.
 */
export const getEligibleParticipants = async (req, res) => {
  try {
    const { eventId } = req.params;

    // QUERY: Menggabungkan event_attendances dengan participants
    // Mencari yang status_hadir = 1 (TINYINT)
    // Dan attendance_id BELUM ADA di tabel winners untuk event ini
    const [rows] = await pool.execute(
      `
      SELECT 
        ea.attendance_id, 
        p.nama, 
        ea.ticket_token 
      FROM event_attendances ea
      JOIN participants p ON ea.participant_id = p.participant_id
      WHERE ea.event_id = ? 
      AND ea.status_hadir = 1
      AND ea.attendance_id NOT IN (
        SELECT attendance_id FROM winners WHERE event_id = ?
      )
      ORDER BY p.nama ASC
      `,
      [eventId, eventId]
    );

    res.json({
      message: "OK",
      data: rows
    });
  } catch (error) {
    console.error("DEBUG ELIGIBLE ERROR:", error);
    res.status(500).json({ message: "Gagal mengambil peserta", error: error.message });
  }
};

/**
 * DRAW LOTTERY WINNER
 */
export const drawWinner = async (req, res) => {
  try {
    const { eventId } = req.params;
    const jumlah_pemenang = parseInt(req.body.jumlah_pemenang) || 1;

    // AMBIL PESERTA YANG BELUM MENANG SAJA (SAMA DENGAN FILTER RODA)
    const [eligible] = await pool.execute(
      `SELECT attendance_id FROM event_attendances 
       WHERE event_id = ? AND status_hadir = 1
       AND attendance_id NOT IN (SELECT attendance_id FROM winners WHERE event_id = ?)`,
      [eventId, eventId]
    );

    if (eligible.length === 0) {
      return res.status(400).json({ message: "Tidak ada peserta tersedia" });
    }

    // Acak dari daftar yang eligible
    const shuffled = eligible.sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, jumlah_pemenang);

    for (const item of selected) {
      await pool.execute(
        `INSERT INTO winners (event_id, attendance_id, hadiah) VALUES (?, ?, ?)`,
        [eventId, item.attendance_id, req.body.hadiah || null]
      );
    }

    // --- PERBAIKAN DI SINI ---
    // Tambahkan p.alamat di dalam SELECT agar data alamat dikirim ke frontend
    const [winners] = await pool.execute(
      `SELECT 
          w.winner_id, 
          p.nama, 
          p.alamat,  -- <--- TAMBAHKAN INI
          ea.ticket_token, 
          ea.attendance_id, 
          w.hadiah
       FROM winners w
       JOIN event_attendances ea ON w.attendance_id = ea.attendance_id
       JOIN participants p ON ea.participant_id = p.participant_id
       WHERE w.event_id = ? ORDER BY w.created_at DESC LIMIT ${jumlah_pemenang}`,
      [eventId]
    );

    res.json({ winners });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

/**
 * GET WINNER HISTORY
 */
export const getWinnerHistory = async (req, res) => {
  try {
    const { eventId } = req.params;

    const [rows] = await pool.execute(
      `
      SELECT 
        w.winner_id,
        w.hadiah,
        w.created_at AS waktu_menang,
        ea.ticket_token,
        p.nama,
        p.no_hp,
        p.alamat   -- <--- Tambahkan kolom ini di sini
      FROM winners w
      JOIN event_attendances ea ON w.attendance_id = ea.attendance_id
      JOIN participants p ON ea.participant_id = p.participant_id
      WHERE w.event_id = ?
      ORDER BY w.created_at DESC
      `,
      [eventId]
    );

    res.json({
      message: "OK",
      data: rows
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Gagal mengambil histori pemenang" });
  }
};