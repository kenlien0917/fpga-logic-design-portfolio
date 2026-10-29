# RGB 呼吸燈

PWM、亮度變化與七色狀態切換。

- 頂層：`Rainbow_Breathing_LED`；板子：PYNQ-Z2，Zynq-7020 (`xc7z020clg400-1`)。
- 原有電路邏輯保留，未以整理過程新增的功能冒充原作。
- `rtl/` 為選定實作，`constraints/board.xdc` 為原始接腳設定。
- 請先閱讀根目錄的 [驗證紀錄](../../docs/VERIFICATION.md) 與 [整理紀錄](../../docs/CURATION.md)。

在安裝 Vivado 的環境，從 repo 根目錄執行：

```sh
vivado -mode batch -source scripts/create_project.tcl -tclargs labs/08-rgb-breathing
```

腳本重建專案，不會自動產生 bitstream 或燒錄硬體。原始 XDC 對應的外接顯示器與接線須先核對。
