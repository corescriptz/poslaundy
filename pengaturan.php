<?php
/** Pengaturan — info toko & harga paket layanan */
require __DIR__ . '/inc/app.php';

/* ---------- Aksi form ---------- */
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'POST') {
    $action = (string)($_POST['action'] ?? '');

    if ($action === 'save_store') {
        $name    = trim((string)($_POST['store_name'] ?? ''));
        $phone   = trim((string)($_POST['store_phone'] ?? ''));
        $address = trim((string)($_POST['store_address'] ?? ''));
        if ($name !== '') {
            q($pdo, "UPDATE store_settings SET name = ?, phone = ?, address = ? WHERE id = 'main'", [$name, $phone, $address]);
        }
        redirect('pengaturan.php?ok=' . urlencode('Info toko tersimpan'));
    }

    if ($action === 'save_pkg') {
        $id = (int)($_POST['id'] ?? 0);
        if ($id > 0) {
            q(
                $pdo,
                'UPDATE packages SET price_per_kg = ?, price_per_pcs = ?, express_per_kg = ?, express_per_pcs = ?, active = ? WHERE id = ?',
                [
                    parse_rupiah($_POST['price_per_kg-' . $id] ?? ''),
                    parse_rupiah($_POST['price_per_pcs-' . $id] ?? ''),
                    parse_rupiah($_POST['express_per_kg-' . $id] ?? ''),
                    parse_rupiah($_POST['express_per_pcs-' . $id] ?? ''),
                    !empty($_POST['active']) ? 1 : 0,
                    $id,
                ]
            );
        }
        redirect('pengaturan.php?ok=' . urlencode('Harga paket tersimpan'));
    }

    if ($action === 'add_pkg') {
        $name = trim((string)($_POST['name'] ?? ''));
        if ($name !== '') {
            $maxSort = (int)q($pdo, 'SELECT COALESCE(MAX(sort_order),0) FROM packages')->fetchColumn();
            q(
                $pdo,
                'INSERT INTO packages (name, price_per_kg, price_per_pcs, express_per_kg, express_per_pcs, active, sort_order) VALUES (?, ?, ?, ?, ?, ?, ?)',
                [
                    mb_substr($name, 0, 100),
                    parse_rupiah($_POST['new-ppk'] ?? ''),
                    parse_rupiah($_POST['new-ppp'] ?? ''),
                    parse_rupiah($_POST['new-epk'] ?? ''),
                    parse_rupiah($_POST['new-epp'] ?? ''),
                    !empty($_POST['active']) ? 1 : 0,
                    $maxSort + 1,
                ]
            );
        }
        redirect('pengaturan.php?ok=' . urlencode('Paket baru ditambahkan'));
    }

    if ($action === 'del_pkg') {
        $id = (int)($_POST['id'] ?? 0);
        if ($id > 0) q($pdo, 'DELETE FROM packages WHERE id = ?', [$id]);
        redirect('pengaturan.php?ok=' . urlencode('Paket dihapus'));
    }

    redirect('pengaturan.php');
}

$packages = get_packages($pdo);
$store    = get_store($pdo);
$okMsg    = isset($_GET['ok']) ? (string)$_GET['ok'] : '';

$PAGE = ['id' => 'pengaturan', 'title' => 'Pengaturan', 'sub' => 'Info toko & harga paket layanan'];
require __DIR__ . '/inc/top.php';
?>

<?php if ($okMsg !== ''): ?><div class="flash flash-ok" role="status"><?= e($okMsg) ?></div><?php endif; ?>

<div class="card">
  <div class="icon-title">
    <span class="icon-box"><?= icon('store', 'ic ic-sm ic-primary') ?></span>
    <div>
      <h3 class="card-title">Info Toko</h3>
      <p class="hint">Tampil di header struk &amp; laporan saat dicetak</p>
    </div>
  </div>

  <form method="post" action="pengaturan.php">
    <input type="hidden" name="action" value="save_store">
    <label class="lbl" for="store_name">Nama toko</label>
    <input class="input" id="store_name" name="store_name" value="<?= e($store['name']) ?>" placeholder="cth: Laundry Bersih Cantik" maxlength="40">
    <label class="lbl" for="store_phone">No. telepon</label>
    <input class="input" id="store_phone" name="store_phone" type="tel" inputmode="tel" value="<?= e($store['phone']) ?>" placeholder="cth: 0812-3456-7890" maxlength="25">
    <label class="lbl" for="store_address">Alamat</label>
    <textarea class="input textarea" id="store_address" name="store_address" rows="2" maxlength="120" placeholder="cth: Jl. Merdeka No. 10, Bandung"><?= e($store['address']) ?></textarea>
    <button type="submit" class="btn btn-primary"><?= icon('save', 'ic ic-sm') ?> Simpan info toko</button>
  </form>
</div>

<div class="section-row">
  <h2 class="section-title">Harga Paket</h2>
  <p class="hint">Normal &amp; express, per kg / pcs</p>
</div>

<?php foreach ($packages as $p): ?>
<div class="card">
  <div class="pkg-head">
    <h3 class="card-title trunc"><?= e($p['name']) ?></h3>
    <label class="switch-wrap">
      <span class="switch-state <?= $p['active'] ? 'on' : '' ?>"><?= $p['active'] ? 'aktif' : 'nonaktif' ?></span>
      <span class="switch <?= $p['active'] ? 'on' : '' ?>"><input type="checkbox" class="switch-input" form="form-pkg-<?= (int)$p['id'] ?>" name="active" value="1" <?= $p['active'] ? 'checked' : '' ?> onchange="this.closest('.switch').classList.toggle('on', this.checked); var s=this.closest('.switch-wrap').querySelector('.switch-state'); s.textContent = this.checked ? 'aktif' : 'nonaktif'; s.classList.toggle('on', this.checked);"></span>
    </label>
  </div>

  <form method="post" action="pengaturan.php" id="form-pkg-<?= (int)$p['id'] ?>">
    <input type="hidden" name="action" value="save_pkg">
    <input type="hidden" name="id" value="<?= (int)$p['id'] ?>">
    <div class="grid2">
      <div>
        <label class="lbl" for="price_per_kg-<?= (int)$p['id'] ?>">Harga/kg</label>
        <?= money_input('price_per_kg-' . (int)$p['id'], (int)$p['price_per_kg'], e($p['name']) . ' harga per kg') ?>
      </div>
      <div>
        <label class="lbl" for="price_per_pcs-<?= (int)$p['id'] ?>">Harga/pcs</label>
        <?= money_input('price_per_pcs-' . (int)$p['id'], (int)$p['price_per_pcs'], e($p['name']) . ' harga per pcs') ?>
      </div>
      <div>
        <label class="lbl lbl-amber" for="express_per_kg-<?= (int)$p['id'] ?>">Express/kg</label>
        <?= money_input('express_per_kg-' . (int)$p['id'], (int)$p['express_per_kg'], e($p['name']) . ' express per kg') ?>
      </div>
      <div>
        <label class="lbl lbl-amber" for="express_per_pcs-<?= (int)$p['id'] ?>">Express/pcs</label>
        <?= money_input('express_per_pcs-' . (int)$p['id'], (int)$p['express_per_pcs'], e($p['name']) . ' express per pcs') ?>
      </div>
    </div>
    <div class="pkg-actions">
      <button type="submit" class="btn btn-primary"><?= icon('save', 'ic ic-sm') ?> Simpan perubahan</button>
      <button type="submit" class="btn-del-pkg" name="action" value="del_pkg"
              onclick="return confirm('Hapus paket <?= e($p['name']) ?>?')">Hapus paket</button>
    </div>
  </form>
</div>
<?php endforeach; ?>

<div class="card">
  <h3 class="card-title"><?= icon('plus', 'ic ic-sm ic-primary') ?> Tambah paket baru</h3>
  <form method="post" action="pengaturan.php">
    <input type="hidden" name="action" value="add_pkg">
    <label class="lbl" for="new-name">Nama paket</label>
    <input class="input" id="new-name" name="name" placeholder="cth: Cuci kilat" maxlength="100">
    <div class="grid2">
      <div>
        <label class="lbl" for="new-ppk">Harga/kg</label>
        <?= money_input('new-ppk', 0, 'Paket baru harga per kg') ?>
      </div>
      <div>
        <label class="lbl" for="new-ppp">Harga/pcs</label>
        <?= money_input('new-ppp', 0, 'Paket baru harga per pcs') ?>
      </div>
      <div>
        <label class="lbl lbl-amber" for="new-epk">Express/kg</label>
        <?= money_input('new-epk', 0, 'Paket baru express per kg') ?>
      </div>
      <div>
        <label class="lbl lbl-amber" for="new-epp">Express/pcs</label>
        <?= money_input('new-epp', 0, 'Paket baru express per pcs') ?>
      </div>
    </div>
    <label class="check-line">
      <input type="checkbox" name="active" value="1" checked> Langsung aktif (tampil di halaman transaksi)
    </label>
    <button type="submit" class="btn btn-primary"><?= icon('plus', 'ic ic-sm') ?> Tambah paket</button>
  </form>
</div>

<?php require __DIR__ . '/inc/bottom.php'; ?>
