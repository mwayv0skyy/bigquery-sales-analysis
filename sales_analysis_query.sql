SELECT
  ft.transaction_id,
  ft.date,
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  ft.product_id,
  p.product_name,
  ft.price AS actual_price,
  ft.discount_percentage,

  -- Persentase Gross Laba berdasarkan ketentuan harga
  CASE
    WHEN ft.price <= 50000 THEN 0.10
    WHEN ft.price <= 100000 THEN 0.15
    WHEN ft.price <= 300000 THEN 0.20
    WHEN ft.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Harga setelah diskon
  ft.price * (1 - ft.discount_percentage / 100) AS nett_sales,

  -- Keuntungan (nett profit)
  ft.price * (1 - ft.discount_percentage / 100) *
  CASE
    WHEN ft.price <= 50000 THEN 0.10
    WHEN ft.price <= 100000 THEN 0.15
    WHEN ft.price <= 300000 THEN 0.20
    WHEN ft.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  ft.rating AS rating_transaksi

FROM
  `rakamin-kf-analytics-467503.kimia_farma.kf_final_transaction` ft
JOIN
  `rakamin-kf-analytics-467503.kimia_farma.kf_product` p
  ON ft.product_id = p.product_id
JOIN
  `rakamin-kf-analytics-467503.kimia_farma.kf_kantor_cabang` kc
  ON ft.branch_id = kc.branch_id
