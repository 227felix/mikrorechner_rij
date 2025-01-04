LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY executeTest IS

END ENTITY executeTest;

ARCHITECTURE testbench OF executeTest IS

    COMPONENT execute IS
        PORT (
            clk : IN STD_LOGIC;

            opC : IN INTEGER RANGE 0 TO 63;
            opC_out : OUT INTEGER RANGE 0 TO 63;

            r1 : IN signed (4 DOWNTO 0);
            r2 : IN signed (4 DOWNTO 0);
            imm : IN signed (15 DOWNTO 0);
            r1_out : OUT signed (4 DOWNTO 0);
            r2_out : OUT signed (4 DOWNTO 0);
            imm_out : OUT signed (15 DOWNTO 0);

            long_imm : IN signed (25 DOWNTO 0);
            long_imm_out : OUT signed (25 DOWNTO 0);

            r3 : IN signed (4 DOWNTO 0);
            r4 : IN signed (4 DOWNTO 0);
            r5 : IN signed (4 DOWNTO 0);
            r3_out : OUT signed (4 DOWNTO 0);
            r4_out : OUT signed (4 DOWNTO 0);
            r5_out : OUT signed (4 DOWNTO 0);

            a : IN signed (31 DOWNTO 0);
            b : IN signed (31 DOWNTO 0);

            a_out : OUT signed (31 DOWNTO 0);
            b_out : OUT signed (31 DOWNTO 0);

            pc : IN signed (15 DOWNTO 0);
            pc_out : OUT signed (15 DOWNTO 0);

            alu_out : OUT signed (31 DOWNTO 0);
            br_flag_out : OUT STD_LOGIC;

            wb_addr : OUT signed (4 DOWNTO 0)

        );
    END COMPONENT execute;

    SIGNAL clk : STD_LOGIC;

    SIGNAL opC : INTEGER RANGE 0 TO 63;
    SIGNAL opC_out : INTEGER RANGE 0 TO 63;

    SIGNAL r1, r2, r1_out, r2_out : signed (4 DOWNTO 0);
    SIGNAL imm, imm_out : signed (15 DOWNTO 0);

    SIGNAL long_imm, long_imm_out : signed (25 DOWNTO 0);

    SIGNAL r3, r4, r5, r3_out, r4_out, r5_out : signed (4 DOWNTO 0);

    SIGNAL a, b, a_out, b_out : signed (31 DOWNTO 0);

    SIGNAL pc, pc_out : signed (15 DOWNTO 0);

    SIGNAL alu_out : signed (31 DOWNTO 0);
    SIGNAL br_flag_out : STD_LOGIC;

    SIGNAL wb_addr : signed (4 DOWNTO 0);

BEGIN
    executeI : execute PORT MAP(clk, opC, opC_out, r1, r2, imm, r1_out, r2_out, imm_out, long_imm, long_imm_out, r3, r4, r5, r3_out, r4_out, r5_out, a, b, a_out, b_out, pc, pc_out, alu_out, br_flag_out, wb_addr);
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
    a <= to_signed(5, 32);
    b <= to_signed(3, 32);

    PROCESS IS
    BEGIN
        FOR j IN 0 TO 14 LOOP
            opC <= j;
            WAIT FOR 20 ns;
        END LOOP;
        WAIT;
    END PROCESS;

END ARCHITECTURE testbench;