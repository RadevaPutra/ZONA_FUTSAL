const express = require('express');
const router = express.Router();
const pool = require('../db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const multer = require('multer');

const storage = multer.diskStorage({

  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },

  filename: (req, file, cb) => {

    cb(
      null,
      Date.now() +
      '-' +
      file.originalname
    );
  },
});

const upload = multer({
  storage: storage,
});

router.post('/register', async (req, res) => {
  const { nama, email, nomor_telepon, password } = req.body;
  try {

    // password minimal 8
if (password.length < 8) {

  return res.status(400).json({
    message: 'Password minimal 8 karakter'
  });
}

// cek email sudah ada atau belum
const emailCheck = await pool.query(
  'SELECT * FROM users WHERE email = $1',
  [email]
);

if (emailCheck.rows.length > 0) {

  return res.status(400).json({
    message: 'Email sudah terdaftar'
  });
}

// cek username / nama
const namaCheck = await pool.query(
  'SELECT * FROM users WHERE nama = $1',
  [nama]
);

if (namaCheck.rows.length > 0) {
  return res.status(400).json({
    message: 'Username sudah digunakan'
  });
}
    // hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // insert ke database
   const result = await pool.query(
  'INSERT INTO users (nama, email, nomor_telepon, password) VALUES ($1, $2, $3, $4) RETURNING *',
  [nama, email, nomor_telepon, hashedPassword]
);

    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

router.put(
  '/upload-photo/:id',

  upload.single('foto'),

  async (req, res) => {

    const { id } = req.params;

    try {

      const fotoPath =
          req.file.filename;

      const result =
          await pool.query(

        `
        UPDATE users
        SET foto_profile = $1
        WHERE id = $2
        RETURNING *
        `,

        [fotoPath, id]
      );

      res.json(result.rows[0]);

    } catch (err) {

      console.log(err);

      res.status(500).send(err.message);
    }
  }
);

router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    // cari user
    const result = await pool.query(
      'SELECT * FROM users WHERE email = $1',
      [email]
    );

    if (result.rows.length === 0) {
      return res.status(400).send('User tidak ditemukan');
    }

    const user = result.rows[0];

    // compare password
    const valid = await bcrypt.compare(password, user.password);

    if (!valid) {
      return res.status(400).send('Password salah');
    }

    // buat token
    const token = jwt.sign(
      { id: user.id },
      'secretkey',
      { expiresIn: '1h' }
    );

res.json({
  message: 'Login berhasil',
  token: token,
  user: {
    id: user.id,
    nama: user.nama,
    email: user.email,
    nomor_telepon: user.nomor_telepon,
    foto_profile: user.foto_profile
  }
});

  } catch (err) {
    res.status(500).send(err.message);
  }
});

router.put('/update-profile/:id', async (req, res) => {

  const { id } = req.params;

  const {
    nama,
    email,
    nomor_telepon
  } = req.body;

  

try {

      const fotoPath = req.file.filename;

      console.log('ID USER:', id);
      console.log('FOTO PATH:', fotoPath);

      const result = await pool.query(
        `
        UPDATE users
        SET foto_profile = $1
        WHERE id = $2
        RETURNING *
        `,
        [fotoPath, id]
      );

      console.log('ROW COUNT:', result.rowCount);
      console.log('RESULT:', result.rows[0]);

      res.json(result.rows[0]);

    } catch (err) {

    console.log(err);

    res.status(500).send(err.message);
  }
});

module.exports = router;

