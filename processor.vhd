library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
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
end entity processor;

architecture processorArch of processor is

    component fetch is
        port (
            clk : in std_logic;
            pc : in signed(15 downto 0);
            pc_out : out signed(15 downto 0)
        );
    end component fetch;

    component decode is
        port (
            clk : in std_logic;
            instr : in signed(31 downto 0);
            opC : out integer range 0 to 63;
            r1_out : buffer signed(4 downto 0);
            r2_out : buffer signed(4 downto 0);
            imm : out signed(15 downto 0);
            long_imm : out signed(25 downto 0);
            r3_out : out signed(4 downto 0);
            r4_out : out signed(4 downto 0);
            r5_out : out signed(4 downto 0);
            a : out signed(31 downto 0);
            b : out signed(31 downto 0);
            wb : in signed(31 downto 0);
            wb_addr : in signed(4 downto 0);
            writeEn : in std_logic;
            pc : in signed(15 downto 0);
            pc_out : out signed(15 downto 0)
        );
    end component decode;

    component execute is
        port (
            clk : in std_logic
            opC : in integer range 0 to 63;
            opC_out : out integer range 0 to 63;
            r1 : in signed(4 downto 0);
            r2 : in signed(4 downto 0);
            imm : in signed(15 downto 0);
            r1_out : out signed(4 downto 0);
            r2_out : out signed(4 downto 0);
            imm_out : out signed(15 downto 0);
            long_imm : in signed(25 downto 0);
            long_imm_out : out signed(25 downto 0);
            r3 : in signed(4 downto 0);
            r4 : in signed(4 downto 0);
            r5 : in signed(4 downto 0);
            a : in signed(31 downto 0);
            b : in signed(31 downto 0);
            a_out : out signed(31 downto 0);
            b_out : out signed(31 downto 0);
            pc : in signed(15 downto 0);
            pc_out : out signed(15 downto 0);
            br_flag_out : out std_logic
        );
    end component execute;

    signal fetch_pc_out : signed(15 downto 0);

    signal rom_instr_out : signed(31 downto 0);
    signal decode_opC_out : integer range 0 to 63;
    signal decode_r1_out : signed(4 downto 0);
    signal decode_r2_out : signed(4 downto 0);
    signal decode_imm_out : signed(15 downto 0);
    signal decode_long_imm_out : signed(25 downto 0);
    signal decode_r3_out : signed(4 downto 0);
    signal decode_r4_out : signed(4 downto 0);
    signal decode_r5_out : signed(4 downto 0);
    signal decode_a_out : signed(31 downto 0);
    signal decode_b_out : signed(31 downto 0);
    signal decode_pc_out : signed(15 downto 0);

    signal execute_opC_out : integer range 0 to 63;
    signal execute_r1_out : signed(4 downto 0);
    signal execute_r2_out : signed(4 downto 0);
    signal execute_imm_out : signed(15 downto 0);
    signal execute_long_imm_out : signed(25 downto 0);
    






begin

    fetching : fetch
    port map(
        clk => clk,
        pc => pc,
        pc_out => pc_internal
    );

    decoding : decode
    port map(
        clk => clk,
        instr => rom_instr_out,
        opC => decode_opC_out,
        r1_out => decode_r1_out,
        r2_out => decode_r2_out,
        imm => decode_imm_out,
        long_imm => decode_long_imm_out,
        r3_out => decode_r3_out,
        r4_out => decode_r4_out,
        r5_out => decode_r5_out,
        a => decode_a_out,
        b => decode_b_out,
        wb => wb,
        wb_addr => wb_addr,
        writeEn => writeEn,
        pc => fetch_pc_out,
        pc_out => decode_pc_out
    );

    executing : execute
    port map (
        clk => clk,
        opC => decode_opC_out,
        opC_out => execute_opC_out,
        r1 => decode_r1_out,
        r2 => decode_r2_out,
        imm => decode_imm_out,
        r1_out => execute_r1_out,
        r2_out => execute_r2_out,
        imm_out => execute_imm_out,
        long_imm => decode_long_imm_out,
        long_imm_out => execute_long_imm_out,
        r3 => decode_r3_out,
        r4 => decode_r4_out,
        r5 => decode_r5_out,
        a => decode_a_out,
        b => decode_b_out,
        a_out => execute_a_out,
        b_out => execute_b_out,
        pc => decode_pc_out,
        pc_out => execute_pc_out,
        br_flag_out => execute_br_flag_out,

    );


end architecture processorArch;