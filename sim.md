
# Fetch + ROM
ghdl -a --std=08 --workdir=build -fsynopsys mydefinitions.vhd
ghdl -a --std=08 --workdir=build -fsynopsys memorySim/memPkg.vhd
ghdl -a --std=08 --workdir=build -fsynopsys memorySim/rom.vhd
ghdl -a --std=08 --workdir=build -fsynopsys fetch.vhd
ghdl -a --std=08 --workdir=build -fsynopsys fetchTest.vhd
ghdl -e --std=08 --workdir=build -fsynopsys fetchTest
ghdl -r --std=08 --workdir=build -fsynopsys fetchTest --vcd=build/fetch.vcd
gtkwave build/fetch.vcd


# Decode
## Regbank nicht sichtbar
ghdl -a --std=08 --workdir=build -fsynopsys mydefinitions.vhd
ghdl -a --std=08 --workdir=build -fsynopsys decode.vhd
ghdl -a --std=08 --workdir=build -fsynopsys decodeTest.vhd
ghdl -e --std=08 --workdir=build -fsynopsys decodeTest
ghdl -r --std=08 --workdir=build -fsynopsys decodeTest --vcd=build/decode.vcd
gtkwave build/decode.vcd


## Reagbank sichtbar

ghdl -a --std=08 --workdir=build -fsynopsys mydefinitions.vhd
ghdl -a --std=08 --workdir=build -fsynopsys decode.vhd
ghdl -a --std=08 --workdir=build -fsynopsys decodeTest.vhd
ghdl -e --std=08 --workdir=build -fsynopsys decodeTest
ghdl -r --std=08 --workdir=build -fsynopsys decodeTest --wave=build/decode.ghw
gtkwave build/decode.ghw


# Execute
ghdl -a --std=08 --workdir=build -fsynopsys mydefinitions.vhd
ghdl -a --std=08 --workdir=build -fsynopsys execute.vhd
ghdl -a --std=08 --workdir=build -fsynopsys executeTest.vhd
ghdl -e --std=08 --workdir=build -fsynopsys executeTest
ghdl -r --std=08 --workdir=build -fsynopsys executeTest --vcd=waveform.vcd
gtkwave waveform.vcd

# Combined Test (Fetch + Decode + Execute)
ghdl -a --std=08 --workdir=build -fsynopsys mydefinitions.vhd
ghdl -a --std=08 --workdir=build -fsynopsys memorySim/memPkg.vhd
ghdl -a --std=08 --workdir=build -fsynopsys memorySim/rom.vhd
ghdl -a --std=08 --workdir=build -fsynopsys fetch.vhd
ghdl -a --std=08 --workdir=build -fsynopsys fetchTest.vhd
ghdl -a --std=08 --workdir=build -fsynopsys decode.vhd
ghdl -a --std=08 --workdir=build -fsynopsys decodeTest.vhd
ghdl -a --std=08 --workdir=build -fsynopsys execute.vhd
ghdl -a --std=08 --workdir=build -fsynopsys executeTest.vhd
ghdl -a --std=08 --workdir=build -fsynopsys processorTest.vhd

ghdl -e --std=08 --workdir=build -fsynopsys processorTest
ghdl -r --std=08 --workdir=build -fsynopsys processorTest --vcd=build/processor.vcd

gtkwave build/processor.vcd






ghdl -a --std=08 --workdir=build -fsynopsys mydefinitions.vhd
ghdl -a --std=08 --workdir=build -fsynopsys memorySim/memPkg.vhd
ghdl -a --std=08 --workdir=build -fsynopsys memorySim/ramIO.vhd
ghdl -a --std=08 --workdir=build -fsynopsys memory_acc.vhd
ghdl -a --std=08 --workdir=build -fsynopsys memory_accTest.vhd
ghdl -e --std=08 --workdir=build -fsynopsys memory_accTest
ghdl -r --std=08 --workdir=build -fsynopsys memory_accTest --vcd=build/memory_acc.vcd
gtkwave build/memory_acc.vcd


// fetch decode
ghdl -a --std=08 --workdir=build -fsynopsys mydefinitions.vhd
ghdl -a --std=08 --workdir=build -fsynopsys memorySim/memPkg.vhd
ghdl -a --std=08 --workdir=build -fsynopsys memorySim/rom.vhd
ghdl -a --std=08 --workdir=build -fsynopsys fetch.vhd
ghdl -a --std=08 --workdir=build -fsynopsys decode.vhd
ghdl -a --std=08 --workdir=build -fsynopsys fetchDecode.vhd
ghdl -a --std=08 --workdir=build -fsynopsys fetchDecodeTest.vhd

ghdl -e --std=08 --workdir=build -fsynopsys fetchDecodeTest
ghdl -r --std=08 --workdir=build -fsynopsys fetchDecodeTest --vcd=build/fetchDecodeTest
gtkwave build/fetchDecodeTest.vcd




