import pool from "../config/db.js";
import QRCode from "qrcode"; // Wajib install: npm install qrcode

export const getTicketByToken = async (req, res) => {
  try {
    const { token } = req.params;

    const [rows] = await pool.execute(
      `SELECT 
        ea.ticket_token, ea.jam_masuk, ea.status_hadir,
        p.nama AS participant_nama, p.no_hp, p.alamat,
        e.nama_event, e.tanggal_event
       FROM event_attendances ea
       JOIN participants p ON ea.participant_id = p.participant_id
       JOIN events e ON ea.event_id = e.event_id
       WHERE ea.ticket_token = ? LIMIT 1`,
      [token]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Tiket tidak ditemukan" });
    }

    const ticketData = rows[0];

    // GENERATE QR CODE SECARA REALTIME
    // Ini yang bikin QR muncul di kartu dan bisa didownload
    const qrImageBase64 = await QRCode.toDataURL(ticketData.ticket_token, {
      margin: 2,
      scale: 10
    });

    res.json({
      message: "Tiket valid",
      ticket: {
        token: ticketData.ticket_token,
        jam_masuk: ticketData.jam_masuk,
        qr_image: qrImageBase64 // Data gambar dikirim di sini
      },
      participant: {
        nama: ticketData.participant_nama,
        no_hp: ticketData.no_hp,
        alamat: ticketData.alamat // Sekarang alamat dikirim
      },
      event: {
        nama_event: ticketData.nama_event,
        tanggal_event: ticketData.tanggal_event
      }
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal mengambil data tiket" });
  }
};