import pool from "../config/db.js";

export const validateTicket = async (req, res) => {
  try {
    const { token, eventCode } = req.body; // Terima eventCode dari frontend

    if (!token) {
      return res.status(400).json({ message: "Token tiket tidak boleh kosong." });
    }

    const cleanToken = token.split("/").pop();

    // 1. CEK DATA TIKET
    const [rows] = await pool.execute(
      `SELECT 
        ea.ticket_token,
        ea.jam_masuk,
        ea.status_hadir,
        ea.event_id,
        p.nama AS nama_peserta,
        p.alamat AS domisili,
        p.no_hp,
        e.nama_event,
        e.event_code, 
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

    // --- VALIDASI EVENT (BARU) ---
    // Jika eventCode dikirim (dari ScanPage spesifik), validasi kesesuaiannya
    if (eventCode && data.event_code !== eventCode) {
        return res.status(400).json({
            valid: false,
            code: "WRONG_EVENT",
            message: `Tiket ini bukan untuk event ini. (Tiket: ${data.nama_event})`,
            data: { // Tetap kirim data minimal untuk info di modal error
                peserta: { nama: data.nama_peserta },
                event: { nama: data.nama_event } 
            }
        });
    }

    // 2. CEK APAKAH SUDAH PERNAH CHECK-IN SEBELUMNYA
    const sudahCheckin = data.status_hadir === 1;
    let waktuCheckin = data.jam_masuk;

    // 3. JIKA BELUM PERNAH CHECK-IN, BARU UPDATE
    if (!sudahCheckin) {
      await pool.execute(
        "UPDATE event_attendances SET status_hadir = 1, jam_masuk = NOW() WHERE ticket_token = ?",
        [cleanToken]
      );
      
      const [updated] = await pool.execute(
        "SELECT jam_masuk FROM event_attendances WHERE ticket_token = ?",
        [cleanToken]
      );
      waktuCheckin = updated[0].jam_masuk;
    }

    // 4. KIRIM RESPON SUKSES
    return res.json({
      valid: true,
      code: sudahCheckin ? "ALREADY_CHECKED_IN" : "SUCCESS",
      message: sudahCheckin 
        ? "Tiket Valid - Sudah Terdaftar Sebelumnya" 
        : "Tiket Valid - Check-in Berhasil",
      data: {
        token: data.ticket_token,
        sudahCheckin: sudahCheckin, 
        peserta: {
          nama: data.nama_peserta,
          domisili: data.domisili,
          no_hp: data.no_hp
        },
        event: {
          nama: data.nama_event,
          tanggal: data.tanggal_event,
          waktu_scan: waktuCheckin 
        }
      }
    });

  } catch (error) {
    console.error("Validator Error:", error);
    res.status(500).json({ message: "Terjadi kesalahan server." });
  }
};