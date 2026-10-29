# 8×8 貪食蛇

以方向控制、蛇身地圖、食物產生、遊戲控制器與 LED 掃描顯示分工。

- 頂層：`top`；板子：PYNQ-Z2，Zynq-7020 (`xc7z020clg400-1`)。
- 原有電路邏輯保留，未以整理過程新增的功能冒充原作。
- `rtl/` 為選定實作，`constraints/board.xdc` 為原始接腳設定。
- 請先閱讀根目錄的 [驗證紀錄](../../docs/VERIFICATION.md) 與 [整理紀錄](../../docs/CURATION.md)。

在安裝 Vivado 的環境，從 repo 根目錄執行：

```sh
vivado -mode batch -source scripts/create_project.tcl -tclargs projects/snake
```

腳本重建專案，不會自動產生 bitstream 或燒錄硬體。原始 XDC 對應的外接顯示器與接線須先核對。

## Golden data 還原

貪食蛇的原始測資約 25 MB，以 `.gz` 無損壓縮保存。執行 `python scripts/unpack_fixtures.py` 還原；腳本會核對原始 SHA-256，再放回 testbench 預期的檔名。
