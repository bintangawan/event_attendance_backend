import pool from "../config/db.js";
import { generateToken } from "../utils/generateToken.js";
import { generateQR } from "../utils/generateQR.js";

/**
 * 1. CREATE ATTENDANCE MANUALLY (BY ADMIN)
 * Default status_hadir = 0 (Belum Registrasi Ulang)
 */
export const createManualAttendance = async (req, res) => {
  try {
    const { eventId } = req.params;
    const { nama, no_hp, alamat } = req.body;

    if (!nama || !no_hp) {
      return res.status(400).json({ message: "Nama dan No HP wajib diisi" });
    }

    // A. Cek Event
    const [events] = await pool.execute(
      "SELECT * FROM events WHERE event_id = ?",
      [eventId]
    );
    if (events.length === 0) return res.status(404).json({ message: "Event tidak ditemukan" });
    const event = events[0];

    // B. Cek / Insert Peserta
    let participantId;
    const [existingParticipant] = await pool.execute(
      "SELECT participant_id FROM participants WHERE no_hp = ? LIMIT 1",
      [no_hp]
    );

    if (existingParticipant.length > 0) {
      participantId = existingParticipant[0].participant_id;
      // Update data peserta jika ada perubahan
      await pool.execute(
        "UPDATE participants SET nama = ?, alamat = ? WHERE participant_id = ?",
        [nama, alamat || null, participantId]
      );
    } else {
      const [insertResult] = await pool.execute(
        "INSERT INTO participants (nama, no_hp, alamat) VALUES (?, ?, ?)",
        [nama, no_hp, alamat || null]
      );
      participantId = insertResult.insertId;
    }

    // C. Cek Duplikasi di Event Ini
    const [existingAttendance] = await pool.execute(
      "SELECT * FROM event_attendances WHERE event_id = ? AND participant_id = ?",
      [eventId, participantId]
    );

    if (existingAttendance.length > 0) {
      // Jika sudah ada, ambil tiket lama
      const oldToken = existingAttendance[0].ticket_token;
      const ticketUrl = `${process.env.BASE_URL}/ticket/${oldToken}`;
      const ticketQR = await generateQR(ticketUrl);

      return res.status(200).json({
        message: "Peserta sudah terdaftar sebelumnya.",
        ticket: {
          token: oldToken,
          ticket_url: ticketUrl,
          qr_image: ticketQR,
          nama_peserta: nama,
          nama_event: event.nama_event
        }
      });
    }

    // D. Buat Kehadiran Baru
    // PENTING: status_hadir = 0 (Belum Registrasi Ulang)
    const ticketToken = generateToken();
    
    await pool.execute(
      `INSERT INTO event_attendances 
       (event_id, participant_id, ticket_token, jam_masuk, status_hadir)
       VALUES (?, ?, ?, NOW(), 0)`, 
      [eventId, participantId, ticketToken]
    );

    // E. Generate Output
    const ticketUrl = `${process.env.BASE_URL}/ticket/${ticketToken}`;
    const ticketQR = await generateQR(ticketUrl);

    res.status(201).json({
      message: "Peserta berhasil didaftarkan (Status: Belum Registrasi Ulang)",
      ticket: {
        token: ticketToken,
        ticket_url: ticketUrl,
        qr_image: ticketQR,
        nama_peserta: nama,
        nama_event: event.nama_event
      }
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal membuat data kehadiran" });
  }
};

/**
 * 2. GET LIST PESERTA
 */

export const getEventAttendances = async (req, res) => {
  try {
    const { eventId } = req.params;
    
    // Pastikan semua angka dikonversi ke Integer
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const search = req.query.search || "";
    const offset = (page - 1) * limit;

    const searchCondition = `
      AND (
        p.nama LIKE ? OR 
        ea.ticket_token LIKE ? OR 
        p.no_hp LIKE ?
      )
    `;
    
    const searchParam = `%${search}%`;

    // 1. Query Data (GANTI pool.execute MENJADI pool.query)
    const [rows] = await pool.query(
      `SELECT 
        ea.attendance_id, 
        ea.ticket_token, 
        ea.jam_masuk, 
        ea.status_hadir, 
        ea.status_konsumsi,      
        ea.jam_ambil_konsumsi,   
        p.nama, 
        p.no_hp, 
        p.alamat 
       FROM event_attendances ea
       JOIN participants p ON ea.participant_id = p.participant_id
       WHERE ea.event_id = ? ${search ? searchCondition : ""}
       ORDER BY ea.created_at DESC
       LIMIT ? OFFSET ?`,
      search 
        ? [eventId, searchParam, searchParam, searchParam, limit, offset]
        : [eventId, limit, offset]
    );

    // 2. Query Hitung Total (GANTI pool.execute MENJADI pool.query)
    const [countResult] = await pool.query(
      `SELECT COUNT(*) as total 
       FROM event_attendances ea
       JOIN participants p ON ea.participant_id = p.participant_id
       WHERE ea.event_id = ? ${search ? searchCondition : ""}`,
      search 
        ? [eventId, searchParam, searchParam, searchParam] 
        : [eventId]
    );

    const totalItems = countResult[0].total;
    const totalPages = Math.ceil(totalItems / limit);

    res.json({ 
      data: rows,
      pagination: {
        currentPage: page,
        itemsPerPage: limit,
        totalItems,
        totalPages
      }
    });

  } catch (error) {
    console.error("Error Get Attendance:", error); // Log error agar terlihat di terminal
    res.status(500).json({ message: "Gagal mengambil data" });
  }
};

/**
 * 3. DELETE ATTENDANCE
 */
export const deleteAttendance = async (req, res) => {
  try {
    const { attendanceId } = req.params;
    await pool.execute("DELETE FROM event_attendances WHERE attendance_id = ?", [attendanceId]);
    res.json({ message: "Peserta berhasil dihapus. Tiket tidak lagi valid." });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal menghapus data" });
  }
};