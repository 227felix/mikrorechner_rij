LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.ALL; -- Import std_logic_textio for image function
USE work.mempkg.ALL;

ENTITY processorTest IS
END ENTITY processorTest;

ARCHITECTURE processorTestArch OF processorTest IS

    COMPONENT fetch IS
        PORT (
            clk : IN STD_LOGIC;
            pc : IN signed(15 DOWNTO 0);
            pc_out : OUT signed(15 DOWNTO 0)
        );
    END COMPONENT fetch;

    COMPONENT decode IS
        PORT (
            clk : IN STD_LOGIC;
            instr : IN signed (31 DOWNTO 0);
            opC : OUT INTEGER RANGE 0 TO 63;

            -- i-format
            r1_out : BUFFER signed (4 DOWNTO 0);
            r2_out : BUFFER signed (4 DOWNTO 0);
            imm : OUT signed (15 DOWNTO 0);

            -- j-format
            long_imm : OUT signed (25 DOWNTO 0);

            -- r-format
            r3_out : OUT signed (4 DOWNTO 0);
            r4_out : OUT signed (4 DOWNTO 0);
            r5_out : OUT signed (4 DOWNTO 0);

            -- values from register file
            a : OUT signed (31 DOWNTO 0);
            b : OUT signed (31 DOWNTO 0);

            wb : IN signed (31 DOWNTO 0);
            wb_addr : IN signed (4 DOWNTO 0);
            writeEn : IN STD_LOGIC;

            pc : IN signed (15 DOWNTO 0);
            pc_out : OUT signed (15 DOWNTO 0)
        );
    END COMPONENT decode;

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

            a : IN signed (31 DOWNTO 0);
            b : IN signed (31 DOWNTO 0);

            a_out : OUT signed (31 DOWNTO 0);
            b_out : OUT signed (31 DOWNTO 0);

            pc : IN signed (15 DOWNTO 0);
            pc_out : OUT signed (15 DOWNTO 0);

            br_flag_out : OUT STD_LOGIC


        );
    END COMPONENT execute;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL pc_fetch : signed(15 DOWNTO 0) := to_signed(0, 16);
    SIGNAL pc_dec : signed(15 DOWNTO 0) := to_signed(0, 16); -- Intermediate signal

    SIGNAL pc_out_dec : signed(15 DOWNTO 0) := to_signed(0, 16);

    SIGNAL iAddr : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL iData : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL iFileIO : fileIoT := none;

    SIGNAL instr : signed (31 DOWNTO 0);

    SIGNAL opC : INTEGER RANGE 0 TO 63;
    SIGNAL r1_out, r2_out : signed (4 DOWNTO 0);
    SIGNAL imm : signed (15 DOWNTO 0);
    SIGNAL long_imm : signed (25 DOWNTO 0);
    SIGNAL r3_out, r4_out, r5_out : signed (4 DOWNTO 0);
    SIGNAL a, b : signed (31 DOWNTO 0);
    SIGNAL wb : signed (31 DOWNTO 0) := to_signed(0, 32);
    SIGNAL wb_addr : signed (4 DOWNTO 0) := to_signed(0, 5);
    SIGNAL writeEn : STD_LOGIC := '0';
    SIGNAL opC_ex_out : INTEGER RANGE 0 TO 63;

    SIGNAL r1_out_ex, r2_out_ex : signed (4 DOWNTO 0);
    SIGNAL imm_out_ex : signed (15 DOWNTO 0);

    SIGNAL long_imm_out_ex : signed (25 DOWNTO 0);

    SIGNAL r3_out_ex, r4_out_ex, r5_out_ex : signed (4 DOWNTO 0);

    SIGNAL a_out_ex, b_out_ex : signed (31 DOWNTO 0);

    SIGNAL pc_out_ex : signed (15 DOWNTO 0);

    SIGNAL alu_out_ex : signed (31 DOWNTO 0);
    SIGNAL br_flag_out_ex : STD_LOGIC;

    SIGNAL wb_addr_out_ex : signed (4 DOWNTO 0);

BEGIN

    instrMemI : rom
    GENERIC MAP(
        addrWd => 16,
        dataWd => 32,
        fileId => "instMem.dat"
    )
    PORT MAP(
        addr => iAddr,
        data => iData,
        fileIO => iFileIO
    );

    fetching : fetch
    PORT MAP(
        clk => clk,
        pc => pc_fetch,
        pc_out => pc_dec
    );

    decoding : decode
    PORT MAP(
        clk => clk,
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
        writeEn => writeEn,
        pc => pc_dec,
        pc_out => pc_out_dec
    );

    executeI : execute PORT MAP(clk, opC, opC_ex_out, r1_out, r2_out, imm, r1_out_ex, r2_out_ex, imm_out_ex, long_imm, long_imm_out_ex, r3_out, r4_out, r5_out, a, b, a_out_ex, b_out_ex, pc_out_dec, pc_out_ex, br_flag_out_ex);
    -- Connect fetch and decode PCs and instr signals
    PROCESS (clk)
        VARIABLE all_x : BOOLEAN := true;
    BEGIN
        IF falling_edge(clk) THEN

            all_x := true;
            FOR i IN pc_out_dec'RANGE LOOP
                IF pc_out_dec(i) = 'X' THEN
                    all_x := false;

                END IF;
            END LOOP;

            IF NOT all_x THEN
                pc_fetch <= (OTHERS => '0');
            ELSE
                pc_fetch <= pc_out_dec;
            END IF;
            instr <= signed(iData);
        END IF;
    END PROCESS;

    PROCESS IS
    BEGIN
        iFileIO <= load, none AFTER 5 ns;

        FOR j IN 1 TO 25 LOOP
            clk <= '0';
            WAIT FOR 5 ns;
            clk <= '1';
            WAIT FOR 5 ns;

            iAddr <= STD_LOGIC_VECTOR(to_unsigned(0, iAddr'length - pc_dec'length)) & STD_LOGIC_VECTOR(pc_dec);
        END LOOP;
        WAIT;
    END PROCESS;

END ARCHITECTURE processorTestArch;