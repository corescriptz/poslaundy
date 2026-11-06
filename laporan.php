<?php
/** Laporan — ringkasan pendapatan & transaksi */
require __DIR__ . '/inc/app.php';

/* ---------- Aksi: hapus transaksi ---------- */
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'POST' && ($_POST['action'] ?? '') === 'hapus') {
    $id = (int)($_POST['id'] ?? 0);
    if ($id > 0) q($pdo, 'DELETE FROM transactions WHERE id = ?', [$id]);
    redirect('laporan.php');
}

$stats = hitung_stats($pdo);
$okMsg = isset($_GET['ok']) ? (string)$_GET['ok'] : '';

$PAGE = ['id' => 'laporan', 'title' => 'Laporan', 'sub' => 'Ringkasan pendapatan & transaksi'];
require __DIR__ . '/inc/top.php';

$max = 1;
foreach ($stats['week'] as $w) $max = max($max, $w['total']);
$pct = $stats['revenueChangePct'];
?>

<div class="flash flash-ok" role="status" hidden id="toast-ok"></div>
<?php if ($okMsg !== ''): ?><div class="flash flash-ok" role="status"><?= e($okMsg) ?></div><?php endif; ?>

<div class="laporan-head">
  <p class="muted small">Ringkasan data hari ini</p>
  <a class="btn btn-outline btn-sm" href="print/laporan.php" target="_blank" rel="noopener">
    <?= icon('printer', 'ic ic-sm') ?> Cetak laporan
  </a>
</div>

<div class="stat-grid">
  <div class="card stat-card">
    <div class="stat-lbl"><?= icon('wallet', 'ic ic-sm') ?> Pendapatan hari ini</div>
    <div class="stat-val"><?= e(rupiah($stats['todayRevenue'])) ?></div>
    <div class="stat-sub <?= $pct === null ? '' : ($pct >= 0 ? 'up' : 'down') ?>">
      <?php if ($pct === null): ?>belum ada pembanding kemarin
      <?php else: ?><?= $pct >= 0 ? '+' : '' ?><?= $pct ?>% vs kemarin<?php endif; ?>
    </div>
  </div>
  <div class="card stat-card">
    <div class="stat-lbl"><?= icon('bag', 'ic ic-sm') ?> Transaksi</div>
    <div class="stat-val"><?= (int)$stats['todayCount'] ?></div>
    <div class="stat-sub"><?= (int)$stats['doneCount'] ?> selesai</div>
  </div>
  <div class="card stat-card">
    <div class="stat-lbl"><?= icon('percent', 'ic ic-sm') ?> Pesanan express</div>
    <div class="stat-val"><?= (int)$stats['expressCount'] ?></div>
    <div class="stat-sub"><?= (int)$stats['expressPct'] ?>% dari transaksi</div>
  </div>
  <div class="card stat-card">
    <div class="stat-lbl"><?= icon('coins', 'ic ic-sm') ?> Rata-rata</div>
    <div class="stat-val"><?= e(rupiah($stats['avgTicket'])) ?></div>
    <div class="stat-sub">per transaksi</div>
  </div>
</div>

<div class="card">
  <h3 class="card-title">Pendapatan 7 hari</h3>
  <div class="chart">
    <?php foreach ($stats['week'] as $w):
        $h = max(6, (int)round($w['total'] / $max * 88)); ?>
    <div class="chart-col">
      <span class="chart-val <?= $w['isToday'] ? 'bold' : '' ?>"><?= $w['total'] > 0 ? e(ringkas($w['total'])) : '&ndash;' ?></span>
      <div class="chart-bar <?= $w['isToday'] ? 'today' : '' ?>" style="height:<?= $h ?>px" aria-hidden="true"></div>
      <span class="chart-lbl <?= $w['isToday'] ? 'bold' : '' ?>"><?= $w['isToday'] ? 'Hari ini' : e($w['label']) ?></span>
    </div>
    <?php endforeach; ?>
  </div>
</div>

<div class="card">
  <div class="card-head-row">
    <h3 class="card-title"><?= icon('receipt', 'ic ic-sm ic-primary') ?> Transaksi terbaru</h3>
    <span class="hint"><?= count($stats['recent']) ?> terakhir</span>
  </div>

  <?php if (count($stats['recent']) === 0): ?>
  <p class="empty">Belum ada transaksi.</p>
  <?php endif; ?>

  <?php foreach ($stats['recent'] as $t): ?>
  <div class="txn-row">
    <div class="txn-left">
      <div class="txn-nota">
        <span class="mono"><?= e($t['invoice_no']) ?></span>
        <?= $t['express'] ? chip_express() : '' ?>
      </div>
      <div class="txn-cust trunc"><?= e($t['customer_name']) ?></div>
      <div class="txn-sub trunc"><?= e($t['package_name']) ?> &bull; <?= e(fmt_qty($t['qty'])) ?> <?= $t['unit'] === 'KG' ? 'kg' : 'pcs' ?> &bull; <?= e(tgl_pendek($t['created_at'])) ?></div>
    </div>
    <div class="txn-right">
      <b class="txn-total"><?= e(rupiah($t['total'])) ?></b>
      <?= badge_selesai() ?>
      <form method="post" action="laporan.php" class="del-form">
        <input type="hidden" name="action" value="hapus">
        <input type="hidden" name="id" value="<?= (int)$t['id'] ?>">
        <button type="button" class="btn-del" aria-label="Hapus <?= e($t['invoice_no']) ?>"><?= icon('trash', 'ic ic-sm') ?></button>
        <button type="submit" class="btn-del-yes" hidden>Hapus?</button>
      </form>
    </div>
  </div>
  <?php endforeach; ?>
</div>

<?php require __DIR__ . '/inc/bottom.php'; ?>
