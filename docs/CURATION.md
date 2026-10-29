# Curation and provenance

## Selection

Projects 1–3 and later labs are retained for their algorithmic or system-integration content. Labs 2, 4 and 5 are omitted because they are introductory mux/encoder/decoder exercises with duplicated project trees. Lab6 retains only the completed 4-bit ripple-carry adder: the carry-lookahead modules are empty and the 8-bit include is malformed.

## Version decisions

- Vending machine: use `project.srcs/sources_1/imports/src`, as referenced by the active Vivado project, including its corresponding testbench/data and XDC.
- Whack-a-mole: the standalone source is an empty module; the active Vivado import contains the implemented LFSR, debounce and mole FSMs. The supplied testbench remains a stimulus example, not a meaningful pass/fail regression (its pulses are shorter than the debounce interval).
- Snake: use the active `snake_main` set from the Vivado manifest. Exclude the inactive duplicate `src` implementations and legacy `body2display.v` so module definitions do not conflict.
- Lab7/8/9: use the active source directories. Exclude Lab8's empty, syntactically invalid `Light switching.v` and duplicate lab9_1.

## Changes

Only repository layout, documentation, recreation scripts and removal of unprofessional comments in `Body2display.sv` were changed. Circuit expressions are preserved. Known functional/interface problems are documented rather than silently rewritten.

`source-manifest.json` records original hashes, source locations relative to the archive and published hashes. Course PDFs, reports, IDE caches, generated netlists/bitstreams and personal absolute paths are omitted. Source locations containing a student identifier are redacted in the C++ repositories.

## Attribution limits

This is coursework. The archive includes course-supplied scaffolding, testbenches, golden data and PYNQ-Z2 pin-map comments. Per-file authorship is not established by directory placement; no claim of exclusive authorship or new third-party license grant is made. Assignment handouts are not republished.

Golden data are losslessly gzip-compressed for distribution. The manifest records compressed file hashes and original hashes; `scripts/unpack_fixtures.py` restores and verifies each fixture.
