library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decodeTest is

end entity decodeTest;

architecture decodeTestArch of decodeTest is

    component decode is
        port (
            clk : in std_logic;

            instr : in signed (31 downto 0);

            opC : out integer range 0 to 63;

            -- i-format
            r1_out : buffer signed (4 downto 0);
            r2_out : buffer signed (4 downto 0);
            imm : out signed (15 downto 0);

            -- j-format
            long_imm : out signed (25 downto 0);

            -- r-format
            r3_out : out signed (4 downto 0);
            r4_out : out signed (4 downto 0);
            r5_out : out signed (4 downto 0);

            -- values from register file
            a : out signed (31 downto 0);
            b : out signed (31 downto 0);

            wb : in signed (31 downto 0);
            wb_addr : in signed (4 downto 0);
            writeEn : in std_logic;

            pc : in signed (15 downto 0);
            pc_out : out signed (15 downto 0)

        );

    end component decode;

    signal clk : std_logic;

    signal instr : signed (31 downto 0);

    signal opC : integer range 0 to 63;

    signal r1_out, r2_out : signed (4 downto 0);
    signal imm : signed (15 downto 0);

    signal long_imm : signed (25 downto 0);

    signal r3_out, r4_out, r5_out : signed (4 downto 0);

    signal a, b : signed (31 downto 0);

    signal wb : signed (31 downto 0);
    signal wb_addr : signed (4 downto 0);
    signal writeEn : std_logic;

    signal pc, pc_out : signed (15 downto 0);

begin
    decoderI : decode port map(clk, instr, opC, r1_out, r2_out, imm, long_imm, r3_out, r4_out, r5_out, a, b, wb, wb_addr, writeEn, pc, pc_out);
    process is
    begin
        for j in 1 to 1000 loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;
    wb <= to_signed(25, 32), to_signed(-1, 32) after 32 ns;
    wb_addr <= to_signed(3, 5);
    instr <= to_signed(1364028010, 32);
    pc <= to_signed(1, 16);
    writeEn <= '0';
    a <= to_signed(2, 32);
end architecture decodeTestArch;