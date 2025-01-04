library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all; -- Import std_logic_textio for image function
use work.mempkg.all;

ENTITY memory_accTest IS

END ENTITY memory_accTest;

ARCHITECTURE memory_accTestArch OF memory_accTest IS
    COMPONENT memory_acc IS
        PORT (
            clk : IN STD_LOGIC;
            opC : IN INTEGER RANGE 0 TO 63;
            opC_out : OUT INTEGER RANGE 0 TO 63;
            r1 : IN signed(4 DOWNTO 0);
            imm : IN signed(15 DOWNTO 0);
            r1_out : OUT signed(4 DOWNTO 0);
            imm_out : OUT signed(15 DOWNTO 0);
            long_imm : IN signed(25 DOWNTO 0);
            long_imm_out : OUT signed(25 DOWNTO 0);
            a : IN signed(31 DOWNTO 0);
            a_out : OUT signed(31 DOWNTO 0);
            pc : IN signed(31 DOWNTO 0);
            pc_out : OUT signed(31 DOWNTO 0);
            alu : IN signed(31 DOWNTO 0);
            alu_out : OUT signed(31 DOWNTO 0);
            br_flag : IN STD_LOGIC;
            data : OUT signed(31 DOWNTO 0);
            wb_addr : OUT signed(4 DOWNTO 0);
            writeEn : OUT STD_LOGIC
        );
    END COMPONENT memory_acc;

    SIGNAL clk : STD_LOGIC;
    SIGNAL opC : INTEGER RANGE 0 TO 63;
    SIGNAL opC_out : INTEGER RANGE 0 TO 63;
    SIGNAL r1 : signed(4 DOWNTO 0);
    SIGNAL imm : signed(15 DOWNTO 0);
    SIGNAL r1_out : signed(4 DOWNTO 0);
    SIGNAL imm_out : signed(15 DOWNTO 0);
    SIGNAL long_imm : signed(25 DOWNTO 0);
    SIGNAL long_imm_out : signed(25 DOWNTO 0);
    SIGNAL a : signed(31 DOWNTO 0);
    SIGNAL a_out : signed(31 DOWNTO 0);
    SIGNAL pc : signed(31 DOWNTO 0);
    SIGNAL pc_out : signed(31 DOWNTO 0);
    SIGNAL alu : signed(31 DOWNTO 0);
    SIGNAL alu_out : signed(31 DOWNTO 0);
    SIGNAL br_flag : STD_LOGIC;
    SIGNAL data : signed(31 DOWNTO 0);
    SIGNAL wb_addr : signed(4 DOWNTO 0);
    SIGNAL writeEn : STD_LOGIC;


BEGIN
    mem_accesserI: memory_acc PORT MAP (
        clk => clk,
        opC => opC,
        opC_out => opC_out,
        r1 => r1,
        imm => imm,
        r1_out => r1_out,
        imm_out => imm_out,
        long_imm => long_imm,
        long_imm_out => long_imm_out,
        a => a,
        a_out => a_out,
        pc => pc,
        pc_out => pc_out,
        alu => alu,
        alu_out => alu_out,
        br_flag => br_flag,
        data => data,
        wb_addr => wb_addr,
        writeEn => writeEn
    );

    ramIO_inst: ramIO
     generic map(
        addrWd => 16,
        dataWd => 32,
        fileId => "ram.dat"
    )
     port map(
        nWE => nWE,
        addr => addr,
        dataI => dataI,
        dataO => dataO,
        fileIO => fileIO
    );

    PROCESS IS
    BEGIN
        FOR j IN 1 TO 1000 LOOP
            clk <= '0';
            WAIT FOR 5 ns;
            clk <= '1';
            WAIT FOR 5 ns;
        END LOOP;
        WAIT;
    END PROCESS;

END ARCHITECTURE memory_accTestArch;