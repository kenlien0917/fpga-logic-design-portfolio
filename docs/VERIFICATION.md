# Verification record — 2026-10-30

## What was actually checked

All seven RTL sets were parsed and elaborated independently using **pyslang 12.1.0**, SystemVerilog mode, a single compilation unit and default `1ns/1ps` timescale. The result was **0 errors in each design**. This checks syntax and module connections; it is not synthesis, timing analysis or functional simulation. Full diagnostic summaries are in [slang-results.json](slang-results.json).

All six XDC files were evaluated as Tcl 8.6.12 in a safe interpreter with `get_ports`, `set_property` and `create_clock` mocked. They have valid Tcl syntax. This does not check physical wiring, Vivado object resolution or electrical suitability.

| Design | RTL errors | Diagnostics | Important limitations |
|---|---:|---:|---|
| Lab06 RCA_4 | 0 | 3 | Missing final-newline warnings only. CLA and malformed RCA_8 omitted. |
| Lab07 marquee | 0 | 0 | Timing constants assume the original board clock. |
| Lab08 breathing RGB | 0 | 1 | `acc_999ms` is an implicit net; `acc_99ms` is declared but unused. Original typo preserved. |
| Lab09 counter | 0 | 0 | Textual includes require only compiling `MC_TOP.v` with its include directory. |
| Snake | 0 | 8 | Missing case defaults, signedness/width warnings, and missing final newlines. Clock-domain and display timing review remains necessary. |
| Vending machine | 0 | 6 | Missing case defaults, signed comparison and final-newline warnings. Original testbench cannot directly elaborate against this top interface. |
| Whack-a-mole | 0 | 3 | Missing case defaults and signed comparison. Supplied stimulus does not wait through debounce/game timing. |

## Testbench snapshots

Testbenches and their relative data fixtures are preserved for context; they are **not presented as passing regressions**. Keep the working directory at the design's `tb/` folder when manually running a data-driven bench. Some fixtures and benches may be course-provided; authorship is not established by the archive.

- Vending: `top_tb.v` connects `disp_coin` and `out_valid`, while the selected board-facing `top.v` keeps them internal. The debounce and RESET counters also make short stimuli inadequate. Reconcile the simulation interface and timing before using it as a regression.
- Whack-a-mole: 8 ns press pulses are shorter than a 65,535-cycle debounce interval, and game waits are hundreds of millions of cycles. This bench is a stimulus snapshot, not evidence of successful hits.
- Snake: `body_map_tb.v` targets the older `head` / `snake_map` interface, and `controller_tb.v` does not match all current controller ports. The full-system `Snake_tb.v` is preserved separately. Component benches require interface review before use.
- Counter: the original stimulus is included, without a claimed automated pass/fail result.

## Reproduction

For RTL compilation checks, install Python 3.11+ and `pyslang==12.1.0`, then run:

```sh
python -m pip install pyslang==12.1.0
python scripts/check_rtl.py
```

For Vivado, follow each design README and `scripts/create_project.tcl`. The recreation script adds only RTL and constraints; it deliberately leaves the preserved benches out of the active simulation fileset until their compatibility has been reviewed.

**Not performed:** Vivado project execution, synthesis, implementation, CDC analysis, full functional simulations, physical pin verification, bitstream generation, FPGA programming, or video capture. No claim is made that a board demonstration has passed during this curation.

## Golden data 還原

貪食蛇的原始測資約 25 MB，以 `.gz` 無損壓縮保存。執行 `python scripts/unpack_fixtures.py` 還原；腳本會核對原始 SHA-256，再放回 testbench 預期的檔名。
