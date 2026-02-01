import pool from "../config/db.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

export const loginAdmin = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: "Email dan password wajib diisi" });
    }

    const [rows] = await pool.execute(
      "SELECT * FROM admins WHERE email = ? LIMIT 1",
      [email]
    );

    if (rows.length === 0) {
      return res.status(401).json({ message: "Email atau password salah" });
    }

    const admin = rows[0];

    const isMatch = await bcrypt.compare(password, admin.password_hash);
    if (!isMatch) {
      return res.status(401).json({ message: "Email atau password salah" });
    }

    const token = jwt.sign(
      {
        admin_id: admin.admin_id,
        email: admin.email,
        nama: admin.nama
      },
      process.env.JWT_SECRET,
      { expiresIn: "8h" }
    );

    res.json({
      message: "Login berhasil",
      token,
      admin: {
        admin_id: admin.admin_id,
        nama: admin.nama,
        email: admin.email
      }
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Gagal login admin" });
  }
};
