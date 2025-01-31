library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all; -- Import std_logic_textio for image function
use work.mempkg.all;

entity processorTest is
end entity processorTest;

architecture processorTestArch of processorTest is

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

    component execute is
        port (
            clk : in std_logic;

            opC : in integer range 0 to 63;
            opC_out : out integer range 0 to 63;

            r1 : in signed (4 downto 0);
            r2 : in signed (4 downto 0);
            imm : in signed (15 downto 0);
            r1_out : out signed (4 downto 0);
            r2_out : out signed (4 downto 0);
            imm_out : out signed (15 downto 0);

            long_imm : in signed (25 downto 0);
            long_imm_out : out signed (25 downto 0);

            r3 : in signed (4 downto 0);
            r4 : in signed (4 downto 0);
            r5 : in signed (4 downto 0);

            a : in signed (31 downto 0);
            b : in signed (31 downto 0);

            a_out : out signed (31 downto 0);
            b_out : out signed (31 downto 0);

            pc : in signed (15 downto 0);
            pc_out : out signed (15 downto 0);

            br_flag_out : out std_logic

        );
    end component execute;

    signal clk : std_logic := '0';
    signal pc_fetch : signed(15 downto 0) := to_signed(0, 16);
    signal pc_dec : signed(15 downto 0) := to_signed(0, 16); -- Intermediate signal

    signal pc_out_dec : signed(15 downto 0) := to_signed(0, 16);

    signal iAddr : std_logic_vector(15 downto 0) := (others => '0');
    signal iData : std_logic_vector(31 downto 0) := (others => '0');
    signal iFileIO : fileIoT := none;

    signal instr : signed (31 downto 0);

    signal opC : integer range 0 to 63;
    signal r1_out, r2_out : signed (4 downto 0);
    signal imm : signed (15 downto 0);
    signal long_imm : signed (25 downto 0);
    signal r3_out, r4_out, r5_out : signed (4 downto 0);
    signal a, b : signed (31 downto 0);
    signal wb : signed (31 downto 0) := to_signed(0, 32);
    signal wb_addr : signed (4 downto 0) := to_signed(0, 5);
    signal writeEn : std_logic := '0';
    signal opC_ex_out : integer range 0 to 63;

    signal r1_out_ex, r2_out_ex : signed (4 downto 0);
    signal imm_out_ex : signed (15 downto 0);

    signal long_imm_out_ex : signed (25 downto 0);

    signal r3_out_ex, r4_out_ex, r5_out_ex : signed (4 downto 0);

    signal a_out_ex, b_out_ex : signed (31 downto 0);

    signal pc_out_ex : signed (15 downto 0);

    signal alu_out_ex : signed (31 downto 0);
    signal br_flag_out_ex : std_logic;

    signal wb_addr_out_ex : signed (4 downto 0);

begin

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

    fetching : fetch
    port map(
        clk => clk,
        pc => pc_fetch,
        pc_out => pc_dec
    );

    decoding : decode
    port map(
        clk => clk,
        instr => signed(iData),
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

    executeI : execute port map(clk, opC, opC_ex_out, r1_out, r2_out, imm, r1_out_ex, r2_out_ex, imm_out_ex, long_imm, long_imm_out_ex, r3_out, r4_out, r5_out, a, b, a_out_ex, b_out_ex, pc_out_dec, pc_out_ex, br_flag_out_ex);
    -- Connect fetch and decode PCs and instr signals
    process (clk)
        variable all_x : boolean := true;
    begin
        if falling_edge(clk) then

            all_x := true;
            for i in pc_out_dec'range loop
                if pc_out_dec(i) = 'X' then
                    all_x := false;

                end if;
            end loop;

            if not all_x then
                pc_fetch <= (others => '0');
            else
                pc_fetch <= pc_out_dec;
            end if;
            instr <= signed(iData);
        end if;
    end process;

    process is
    begin
        iFileIO <= load, none after 5 ns;

        for j in 1 to 25 loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;

            iAddr <= std_logic_vector(to_unsigned(0, iAddr'length - pc_dec'length)) & std_logic_vector(pc_dec);
        end loop;
        wait;
    end process;

end architecture processorTestArch;