from pathlib import Path
import sys, json
import pyslang as s
root=Path(__file__).resolve().parent.parent
results=[]
for rtl in sorted(root.glob('*/*/rtl')):
    sources=list(rtl.glob('*.v'))+list(rtl.glob('*.sv'))
    if rtl.parent.name=='06-ripple-carry-adder': sources=[rtl/'RCA_4.v']
    if rtl.parent.name=='09-button-counter': sources=[rtl/'MC_TOP.v']
    d=s.driver.Driver(); d.addStandardArgs()
    cmd='slang --single-unit --timescale 1ns/1ps -I "'+str(rtl)+'" '+' '.join('"'+str(p)+'"' for p in sources)
    if not(d.parseCommandLine(cmd) and d.processOptions() and d.parseAllSources()): raise RuntimeError('Driver failed '+str(rtl))
    c=d.createCompilation(); diags=c.getAllDiagnostics()
    report=s.DiagnosticEngine.reportAll(d.sourceManager,diags)
    # Convert absolute diagnostics into repository-relative paths.
    report=report.replace(str(root)+'\\','').replace(str(root)+'/','').replace('outputs\\fpga-logic-design-portfolio\\','')
    errors=sum(x.isError() for x in diags)
    results.append({'design':rtl.parent.relative_to(root).as_posix(),'errors':errors,'diagnostics':len(diags),'report':report})
    print(results[-1]['design'], 'errors=',errors,'diagnostics=',len(diags))
    print(report[:4500])
(root/'docs/slang-results.json').write_text(json.dumps({'tool':'pyslang 12.1.0','mode':'single compilation unit; SystemVerilog; 1ns/1ps default timescale','results':results},indent=2),encoding='utf-8')

if any(r["errors"] for r in results):
    raise SystemExit(1)
