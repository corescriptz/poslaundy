<?php
/** Transaksi POS — catat pesanan laundry */
require __DIR__ . '/inc/app.php';

/* ---------- Aksi: simpan transaksi ---------- */
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'POST' && ($_POST['action'] ?? '') === 'simpan') {
    $customerName = trim((string)($_POST['customer_name'] ?? ''));
    $pkgId        = (string)($_POST['package_id'] ?? '');
    $customName   = trim((string)($_POST['custom_name'] ?? ''));
    $unit         = (($_POST['unit'] ?? 'KG') === 'PCS') ? 'PCS' : 'KG';
    $qty          = parse_angka($_POST['qty'] ?? '0');
    $express      = !empty($_POST['express']);
    $paid         = parse_rupiah($_POST['paid'] ?? '');
    $cashier      = trim((string)($_POST['cashier'] ?? '')) ?: 'Andi';
    $hasTotal     = isset($_POST['total']) && trim((string)$_POST['total']) !== '';
    $totalIn      = parse_rupiah($_POST['total'] ?? '');
    $isCustom     = $pkgId === 'custom';

    $err = '';
    if ($customerName === '') {
        $err = 'Nama pelanggan wajib diisi';
    } elseif ($qty <= 0) {
        $err = 'Jumlah harus lebih dari 0';
    } elseif ($isCustom) {
        if ($customName === '') {
            $err = 'Nama layanan wajib diisi';
        } elseif (mb_strlen($customName) > 40) {
            $err = 'Nama layanan maksimal 40 karakter';
        } elseif (!$hasTotal || $totalIn <= 0) {
            $err = 'Total harga wajib diisi untuk layanan bebas';
        }
    } else {
        $pkg = null;
        if ($pkgId !== '' && ctype_digit($pkgId)) {
            $pkg = q($pdo, 'SELECT * FROM packages WHERE id = ?', [(int)$pkgId])->fetch();
        }
        if (!$pkg || !(int)$pkg['active']) {
            $err = 'Paket tidak tersedia';
        }
    }

    if ($err === '') {
        if ($isCustom) {
            $finalName = $customName;
            $express   = false;
            $total     = $totalIn;
            $unitPrice = (int)round($total / $qty); // tarif efektif per satuan (untuk struk)
        } else {
            $pkgRow = q($pdo, 'SELECT * FROM packages WHERE id = ?', [(int)$pkgId])->fetch();
            $finalName = $pkgRow['name'];
            $unitPrice = tarif_paket($pkgRow, $unit, $express);
            $total     = $hasTotal ? max(0, $totalIn) : (int)round($qty * $unitPrice);
        }

        if ($paid > 0 && $paid < $total) {
            $err = 'Uang bayar kurang dari total';
        } else {
            $nota  = nota_berikutnya($pdo);
            $now   = date('Y-m-d H:i:s');
            $change = $paid > 0 ? $paid - $total : 0;
            q(
                $pdo,
                'INSERT INTO transactions (invoice_no, customer_name, package_name, unit, qty, express, unit_price, total, paid, change_amount, status, cashier, created_at, completed_at)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                [$nota, $customerName, $finalName, $unit, round($qty, 2), $express ? 1 : 0, $unitPrice, $total, $paid, $change, 'DONE', $cashier, $now, $now]
            );
            redirect('index.php?saved=' . $pdo->lastInsertId());
        }
    }

    redirect('index.php?err=' . urlencode($err));
}

$savedId = isset($_GET['saved']) ? (int)$_GET['saved'] : 0;
$saved   = $savedId > 0 ? get_txn($pdo, $savedId) : null;
$errMsg  = isset($_GET['err']) ? (string)$_GET['err'] : '';

$packages = get_packages($pdo, true);
$store    = get_store($pdo);

$PAGE = ['id' => 'transaksi', 'title' => 'Transaksi baru', 'sub' => 'Catat pesanan laundry pelanggan'];
require __DIR__ . '/inc/top.php';
?>

<?php if ($saved): ?>
<div class="flash flash-ok" role="status">
  <div class="flash-title"><?= icon('receipt', 'ic ic-sm') ?> Struk <?= e($saved['invoice_no']) ?></div>
  <p class="flash-sub">Transaksi tersimpan. Struk siap dicetak.</p>
  <div class="flash-detail">
    <div><span>Pelanggan</span><b class="trunc"><?= e($saved['customer_name']) ?></b></div>
    <div><span>Paket</span><b class="trunc"><?= e($saved['package_name']) ?></b></div>
    <div><span>Jumlah</span><b><?= e(fmt_qty($saved['qty'])) ?> <?= $saved['unit'] === 'KG' ? 'kg' : 'pcs' ?></b></div>
    <div><span>Tarif</span><b><?= e(rupiah($saved['unit_price'])) ?><?= $saved['express'] ? ' (express)' : '' ?></b></div>
    <div class="flash-total"><span>Total</span><b><?= e(rupiah($saved['total'])) ?></b></div>
    <div><span>Bayar</span><b><?= e(rupiah($saved['paid'])) ?></b></div>
    <div><span>Kembalian</span><b><?= e(rupiah($saved['change_amount'])) ?></b></div>
  </div>
  <div class="flash-actions">
    <a class="btn btn-outline" href="print/struk.php?id=<?= (int)$saved['id'] ?>" target="_blank" rel="noopener">
      <?= icon('printer', 'ic ic-sm') ?> Cetak Struk
    </a>
    <a class="btn btn-primary" href="index.php">Selesai</a>
  </div>
</div>
<?php endif; ?>

<?php if ($errMsg !== ''): ?>
<div class="flash flash-err" role="alert"><?= e($errMsg) ?></div>
<?php endif; ?>

<form method="post" action="index.php" id="pos-form" autocomplete="off">
  <input type="hidden" name="action" value="simpan">
  <input type="hidden" name="cashier" id="cashier-hidden" value="Andi">

  <div class="card">
    <label class="lbl" for="customer"><?= icon('user', 'ic ic-sm ic-primary') ?> Nama pelanggan</label>
    <input class="input" id="customer" name="customer_name" placeholder="cth: Budi Santoso" maxlength="60">
  </div>

  <section aria-label="Pilih paket layanan">
    <h2 class="section-title">Pilih paket</h2>

    <?php if (count($packages) === 0): ?>
    <div class="card"><p class="muted">Belum ada paket aktif. Atur di menu <b>Pengaturan</b>.</p></div>
    <?php endif; ?>

    <div class="pkg-list">
      <?php foreach ($packages as $p): ?>
      <label class="pkg-opt">
        <input type="radio" name="package_id" value="<?= (int)$p['id'] ?>" data-kg="<?= (int)$p['price_per_kg'] ?>"
               data-pcs="<?= (int)$p['price_per_pcs'] ?>" data-kgx="<?= (int)$p['express_per_kg'] ?>" data-pcsx="<?= (int)$p['express_per_pcs'] ?>">
        <span class="pkg-body">
          <span class="pkg-name"><?= e($p['name']) ?><span class="zap-mini" hidden><?= icon('zap', 'ic ic-xs ic-amber') ?></span></span>
          <span class="pkg-price" data-base="1">Rp <?= e(angka($p['price_per_kg'])) ?>/kg
Rp <?= e(angka($p['price_per_pcs'])) ?>/pcs</span>
        </span>
        <span class="radio-dot" aria-hidden="true"><?= icon('check', 'ic ic-check') ?></span>
      </label>
      <?php endforeach; ?>

      <label class="pkg-opt pkg-opt-wide">
        <input type="radio" name="package_id" value="custom">
        <span class="pkg-body">
          <span class="pkg-name"><?= icon('pen', 'ic ic-sm ic-primary') ?> Lainnya</span>
          <span class="pkg-price">Ketik nama layanan &amp; total harga sendiri</span>
        </span>
        <span class="radio-dot" aria-hidden="true"><?= icon('check', 'ic ic-check') ?></span>
      </label>

      <div class="card" id="custom-card" hidden>
        <label class="lbl" for="custom-name">Nama layanan</label>
        <input class="input" id="custom-name" name="custom_name" placeholder="cth: Cuci sepatu, Bed cover" maxlength="40">
        <p class="hint">Atur jumlah bila perlu, lalu ketik total harganya di ringkasan bawah.</p>
      </div>
    </div>
  </section>

  <div class="card">
    <label class="lbl">Satuan</label>
    <div class="seg" role="tablist" aria-label="Satuan">
      <label class="seg-item"><input type="radio" name="unit" value="KG" checked>Kilogram</label>
      <label class="seg-item"><input type="radio" name="unit" value="PCS">Pieces</label>
    </div>

    <label class="lbl" for="qty">Jumlah</label>
    <div class="qty-row">
      <button type="button" class="btn-step" id="qty-minus" aria-label="Kurangi jumlah"><?= icon('minus', 'ic ic-sm') ?></button>
      <div class="qty-wrap">
        <input class="input qty" id="qty" name="qty" inputmode="decimal" value="1" aria-label="Jumlah">
        <span class="qty-unit" id="qty-unit">kg</span>
      </div>
      <button type="button" class="btn-step" id="qty-plus" aria-label="Tambah jumlah"><?= icon('plus', 'ic ic-sm') ?></button>
    </div>

    <label class="express-box" id="express-wrap">
      <input type="checkbox" name="express" value="1" id="express">
      <span>
        <span class="express-title"><?= icon('zap', 'ic ic-sm ic-amber') ?> Express &mdash; selesai hari ini</span>
        <span class="hint">Pakai tarif express untuk paket yang dipilih</span>
      </span>
    </label>
  </div>

  <div class="card card-summary">
    <div class="hitung-row">
      <span id="hitung" class="muted trunc">Pilih paket untuk melihat total</span>
      <button type="button" id="reset-total" class="link-amber" hidden>Hitung ulang</button>
    </div>

    <div>
      <div class="lbl-row">
        <label class="lbl" for="total">Total harga</label>
        <span class="hint">bisa diubah</span>
      </div>
      <?= money_input('total', 0, 'Total harga') ?>
      <p class="hint" id="hitung-auto" hidden></p>
      <p class="hint" id="hitung-custom" hidden>Ketik total harga untuk layanan ini.</p>
    </div>

    <div class="border-top">
      <label class="lbl" for="paid">Uang bayar</label>
      <?= money_input('paid', 0, 'Uang bayar') ?>
      <div class="chips">
        <button type="button" class="chip" data-paid="pas">Uang pas</button>
        <button type="button" class="chip" data-paid="20000">20.000</button>
        <button type="button" class="chip" data-paid="50000">50.000</button>
        <button type="button" class="chip" data-paid="100000">100.000</button>
      </div>
    </div>

    <div class="kembali-row border-top">
      <span class="muted">Kembalian</span>
      <b id="kembali">Rp 0</b>
    </div>
    <p class="err-text" id="kurang" hidden></p>
  </div>

  <button type="submit" class="btn btn-primary btn-big" id="submit-btn" disabled>
    <?= icon('cart', 'ic ic-sm') ?>
    <span id="submit-label">Simpan Transaksi</span>
  </button>
</form>

<?php require __DIR__ . '/inc/bottom.php'; ?>
