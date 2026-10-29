# FPGA Logic Design Portfolio

以 **Verilog / SystemVerilog** 完成的數位邏輯課程作品集，涵蓋 FSM、按鍵介面、PWM 與模組化遊戲控制。主要目標平台為 **PYNQ-Z2 / Zynq-7020**。

## 精選專案

| 作品 | 核心內容 | 原始檔狀態 |
|---|---|---|
| [8×8 貪食蛇](projects/snake) | 蛇身記憶、方向與食物控制、LED 矩陣掃描 | 模組完整；需注意跨時脈與顯示頻率 |
| [販賣機](projects/vending-machine) | 交易 FSM、硬幣與找零、七段顯示 | 實作存在；原 testbench 與頂層介面不一致 |
| [打地鼠](projects/whack-a-mole) | LFSR、去彈跳、四組遊戲 FSM | 採用 Vivado 中的完整實作 |

## 後期 Labs

| Lab | 主題 | 展示重點 |
|---|---|---|
| [06](labs/06-ripple-carry-adder) | 4-bit ripple-carry adder | 組合邏輯與結構式設計 |
| [07](labs/07-led-marquee) | LED 跑馬燈 | FSM、時脈計數 |
| [08](labs/08-rgb-breathing) | RGB 呼吸燈 | PWM、色彩切換 |
| [09](labs/09-button-counter) | 加減計數器 | 去彈跳、邊緣脈衝、循序邏輯 |

## 如何閱讀與重建

各作品以 `rtl/`、`constraints/`、`tb/` 分開保存。請分別建立專案；多個作品使用相同模組名稱，不能全部一起編譯。`scripts/create_project.tcl` 可重建六個含板子接腳的 Vivado 專案；Lab06 是獨立組合邏輯範例。

- [驗證結果與已知限制](docs/VERIFICATION.md)
- [選材、來源與整理紀錄](docs/CURATION.md)
- [相關 C++：K-map](https://github.com/kenlien0917/kmap-solver) · [Quine–McCluskey](https://github.com/kenlien0917/quine-mccluskey-solver)

這些是課程作品的整理版。尚未在此次整理中完成 FPGA 上板、時序收斂或完整功能回歸；請依驗證紀錄判讀完成度。課程提供的架構、testbench 與板子約束可能包含於原始資料，不能推定每個檔案皆為個人獨立創作，因此未新增授權條款。

## Golden data 還原

貪食蛇的原始測資約 25 MB，以 `.gz` 無損壓縮保存。執行 `python scripts/unpack_fixtures.py` 還原；腳本會核對原始 SHA-256，再放回 testbench 預期的檔名。
