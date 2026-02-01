import pool from "../config/db.js";
import { generateToken } from "../utils/generateToken.js";
import { generateQR } from "../utils/generateQR.js";

/**
 * CHECK-IN PESERTA (SCAN QR UMUM)
 */
export const checkInParticipant = async (req, res) => {
  try {
    const { eventCode } = req.params;
    const { nama, no_hp, alamat } = req.body;

    if (!nama || !no_hp) {
      return res.status(400).json({
        message: "Nama dan No HP wajib diisi"
      });
    }

    // 1. Cari event
    const [eventRows] = await pool.execute(
      "SELECT * FROM events WHERE event_code = ? AND status_event = 'aktif' LIMIT 1",
      [eventCode]
    );

    if (eventRows.length === 0) {
      return res.status(404).json({
        message: "Event tidak ditemukan atau sudah tidak aktif"
      });
    }

    const event = eventRows[0];

    // 2. Validasi jam masuk
    // CEK STATUS EVENT
    if (event.status_event !== "aktif") {
    return res.status(403).json({
        message: "Event sudah ditutup"
    });
    }

    // CEK CHECK-IN END TIME
    const now = new Date();
    const checkinEnd = new Date(event.checkin_end_time);

    if (now > checkinEnd) {
    return res.status(403).json({
        message: "Check-in sudah ditutup oleh admin"
    });
    }

    // 3. Cek / insert participant
    let participantId;
    const [participantRows] = await pool.execute(
      "SELECT participant_id FROM participants WHERE no_hp = ? LIMIT 1",
      [no_hp]
    );

    if (participantRows.length > 0) {
      participantId = participantRows[0].participant_id;
    } else {
      const [insertParticipant] = await pool.execute(
        "INSERT INTO participants (nama, no_hp, alamat) VALUES (?, ?, ?)",
        [nama, no_hp, alamat || null]
      );
      participantId = insertParticipant.insertId;
    }

    // 4. Cegah double check-in
    const [attendanceRows] = await pool.execute(
      `SELECT * FROM event_attendances 
       WHERE event_id = ? AND participant_id = ? LIMIT 1`,
      [event.event_id, participantId]
    );

    if (attendanceRows.length > 0) {
      return res.status(409).json({
        message: "Peserta sudah melakukan check-in",
        ticket_token: attendanceRows[0].ticket_token
      });
    }

    // 5. Generate token undian
    const ticketToken = generateToken();

    // 6. Simpan kehadiran
    await pool.execute(
      `INSERT INTO event_attendances 
       (event_id, participant_id, ticket_token, jam_masuk, status_hadir)
       VALUES (?, ?, ?, NOW(), 1)`,
      [event.event_id, participantId, ticketToken]
    );

    // 7. Generate QR peserta (tiket undian)
    const ticketUrl = `${process.env.BASE_URL}/ticket/${ticketToken}`;
    const ticketQR = await generateQR(ticketUrl);

    // 8. Response
    res.status(201).json({
      message: "Check-in berhasil",
      event: {
        nama_event: event.nama_event,
        tanggal_event: event.tanggal_event
      },
      participant: {
        nama,
        no_hp,
        alamat
      },
      ticket: {
        token: ticketToken,
        ticket_url: ticketUrl,
        qr_image: ticketQR
      }
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal melakukan check-in"
    });
  }
};

/**
 * GET LIST KEHADIRAN PER EVENT (ADMIN)
 */
export const getAttendanceByEvent = async (req, res) => {
  try {
    const { eventId } = req.params;

    const [rows] = await pool.execute(
      `
      SELECT
        ea.attendance_id,
        ea.ticket_token,
        ea.jam_masuk,
        ea.status_hadir,

        p.nama,
        p.no_hp,
        p.alamat
      FROM event_attendances ea
      JOIN participants p ON ea.participant_id = p.participant_id
      WHERE ea.event_id = ?
      ORDER BY ea.jam_masuk ASC
      `,
      [eventId]
    );

    const totalHadir = rows.length;

    res.json({
      event_id: eventId,
      total_hadir: totalHadir,
      data: rows
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Gagal mengambil data kehadiran"
    });
  }
};

