library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mempkg.all;

entity processor is

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
            clk : in std_logic;
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

    component memory_acc is
        port (
            clk : in std_logic;
            opC : in integer range 0 to 63;
            opC_out : out integer range 0 to 63;
            r1 : in signed(4 downto 0);
            imm : in signed(15 downto 0);
            r1_out : out signed(4 downto 0);
            imm_out : out signed(15 downto 0);
            long_imm : in signed(25 downto 0);
            data : in signed(31 downto 0);
            addr : in signed(15 downto 0);
            nwe : out std_logic;
            data_out : out signed(31 downto 0);
            pc : in signed(15 downto 0);
            pc_out : out signed(15 downto 0);
            br_flag : in std_logic
        );
    end component memory_acc;

    component write_back is
        port (
            clk : in std_logic;
            opC : in integer range 0 to 63;
            r1 : in signed(4 downto 0);
            r1_out : out signed(4 downto 0);
            data : in signed(31 downto 0);
            data_out : out signed(31 downto 0);
            writeEn_out : out std_logic
        );
    end component write_back;

    signal clk : std_logic := '0';

    signal fetch_pc_out : signed(15 downto 0) := TO_SIGNED(0, 16);

    signal iAddr : std_logic_vector(15 downto 0) := (others => '0');
    signal iData : std_logic_vector(31 downto 0) := (others => '0');
    signal iFileIO : fileIoT := none;

    signal decode_opC_out : integer range 0 to 63 := 0;
    signal decode_r1_out : signed(4 downto 0) := (others => '0');
    signal decode_r2_out : signed(4 downto 0) := (others => '0');
    signal decode_imm_out : signed(15 downto 0) := (others => '0');
    signal decode_long_imm_out : signed(25 downto 0) := (others => '0');
    signal decode_r3_out : signed(4 downto 0) := (others => '0');
    signal decode_r4_out : signed(4 downto 0) := (others => '0');
    signal decode_r5_out : signed(4 downto 0) := (others => '0');
    signal decode_a_out : signed(31 downto 0) := (others => '0');
    signal decode_b_out : signed(31 downto 0) := (others => '0');
    signal decode_pc_out : signed(15 downto 0) := TO_SIGNED(0, 16);

    signal execute_opC_out : integer range 0 to 63 := 0;
    signal execute_r1_out : signed(4 downto 0) := (others => '0');
    signal execute_r2_out : signed(4 downto 0) := (others => '0');
    signal execute_imm_out : signed(15 downto 0) := (others => '0');
    signal execute_long_imm_out : signed(25 downto 0) := (others => '0');
    signal execute_a_out : signed(31 downto 0) := (others => '0');
    signal execute_b_out : signed(31 downto 0) := (others => '0');
    signal execute_pc_out : signed(15 downto 0) := TO_SIGNED(0, 16);
    signal execute_br_flag_out : std_logic := '0';

    signal memacc_opC_out : integer range 0 to 63 := 0;
    signal memacc_r1_out : signed(4 downto 0) := (others => '0');
    signal memacc_imm_out : signed(15 downto 0) := (others => '0');
    signal memacc_nwe : std_logic := '0';
    signal memacc_data_out : signed(31 downto 0) := (others => '0');
    signal memacc_pc_out : signed(15 downto 0) := TO_SIGNED(0, 16);

    signal wb_r1_out : signed(4 downto 0) := (others => '0');
    signal wb_data_out : signed(31 downto 0) := (others => '0');
    signal wb_writeEn_out : std_logic := '0';

begin

    fetching : fetch
    port map(
        clk => clk,
        pc => memacc_pc_out,
        pc_out => fetch_pc_out
    );

    instrMemI : rom
    generic map(
        addrWd => 16,
        dataWd => 32,
        fileId => "instMem.dat"
    )
    port map(
        addr => iAddr,
        data => iData,
        fileIO => iFileIO
    );

    decoding : decode
    port map(
        clk => clk,
        instr => signed(iData),
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
        wb => wb_data_out,
        wb_addr => wb_r1_out,
        writeEn => wb_writeEn_out,
        pc => fetch_pc_out,
        pc_out => decode_pc_out
    );

    executing : execute
    port map(
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
        br_flag_out => execute_br_flag_out
    );

    memory_accessing : memory_acc
    port map(
        clk => clk,
        opC => execute_opC_out,
        opC_out => memacc_opC_out,
        r1 => execute_r1_out,
        imm => execute_imm_out,
        r1_out => memacc_r1_out,
        imm_out => memacc_imm_out,
        long_imm => execute_long_imm_out,
        data => execute_a_out,
        addr => execute_b_out(15 downto 0), -- b wird als Adresse verwendet; aufgrund des Speichermodells, nur die unteren 16 Bit
        nwe => memacc_nwe,
        data_out => memacc_data_out,
        pc => execute_pc_out,
        pc_out => memacc_pc_out,
        br_flag => execute_br_flag_out
    );

    writing_back : write_back
    port map(
        clk => clk,
        opC => memacc_opC_out,
        r1 => memacc_r1_out,
        r1_out => wb_r1_out,
        data => memacc_data_out,
        data_out => wb_data_out,
        writeEn_out => wb_writeEn_out
    );

    clk_process : process
    begin
        fetch_pc_out <= TO_SIGNED(0, 16);
        decode_pc_out <= TO_SIGNED(0, 16);
        execute_pc_out <= TO_SIGNED(0, 16);
        memacc_pc_out <= TO_SIGNED(0, 16);

        for j in 1 to 10 loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            iAddr <= std_logic_vector(to_unsigned(0, iAddr'length - fetch_pc_out'length)) & std_logic_vector(fetch_pc_out);
        end loop;
        wait;
    end process;

end architecture processorArch;