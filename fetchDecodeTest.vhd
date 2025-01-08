library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetchDecodeTest is
end entity fetchDecodeTest;

architecture fetchDecodeTestArch of fetchDecodeTest is

    component fetchDecode is
        port (
            clk : in std_logic;
            pc : in signed(15 downto 0);
            pc_out : out signed(15 downto 0);
            instr : out signed(31 downto 0);
            opC : out integer range 0 to 63;
            r1_out : out signed(4 downto 0);
            r2_out : out signed(4 downto 0);
            imm : out signed(15 downto 0);
            long_imm : out signed(25 downto 0);
            r3_out : out signed(4 downto 0);
            r4_out : out signed(4 downto 0);
            r5_out : out signed(4 downto 0);
            a : out signed(31 downto 0);
            b : out signed(31 downto 0);
            wb : in signed(31 downto 0);
            wb_addr : in signed(4 downto 0);
            writeEn : in std_logic
        );
    end component fetchDecode;

    signal clk : std_logic := '0';
    signal pc : signed(15 downto 0) := to_signed(0, 16);
    signal pc_out : signed(15 downto 0);
    signal instr : signed(31 downto 0);
    signal opC : integer range 0 to 63;
    signal r1_out, r2_out : signed(4 downto 0);
    signal imm : signed(15 downto 0);
    signal long_imm : signed(25 downto 0);
    signal r3_out, r4_out, r5_out : signed(4 downto 0);
    signal a, b : signed(31 downto 0);
    signal wb : signed(31 downto 0) := to_signed(0, 32);
    signal wb_addr : signed(4 downto 0) := to_signed(0, 5);
    signal writeEn : std_logic := '0';

begin

    uut : fetchDecode
        port map (
            clk => clk,
            pc => pc,
            pc_out => pc_out,
            instr => instr,
            opC => opC,
            r1_out => r1_out,
            r2_out => r2_out,
            imm => imm,
            long_imm => long_imm,
            r3_out => r3_out,
            r4_out => r4_out,
            r5_out => r5_out,
            a => a,
            b => b,
            wb => wb,
            wb_addr => wb_addr,
            writeEn => writeEn
        );

    process
    begin
        -- Initialize signals
        wb <= to_signed(25, 32);
        wb_addr <= to_signed(3, 5);
        instr <= to_signed(1364028010, 32);
        pc <= to_signed(1, 16);
        writeEn <= '0';
        a <= to_signed(2, 32);

        -- Clock generation
        for j in 1 to 1000 loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

end architecture fetchDecodeTestArch;