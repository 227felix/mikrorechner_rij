library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all; -- Import std_logic_textio for image function
use work.mempkg.all;

entity memory_accTest is

end entity memory_accTest;

architecture memory_accTestArch of memory_accTest is

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

    signal clk : std_logic := '0';
    signal opC : integer range 0 to 63 := 0;
    signal opC_out : integer range 0 to 63 := 0;
    signal r1 : signed(4 downto 0) := (others => '0');
    signal imm : signed(15 downto 0) := to_signed(3, 16);
    signal r1_out : signed(4 downto 0) := (others => '0');
    signal imm_out : signed(15 downto 0) := (others => '0');
    signal long_imm : signed(25 downto 0) := (others => '0');
    signal data : signed(31 downto 0) := (others => '0');
    signal addr : signed(15 downto 0) := (others => '0');
    signal nwe : std_logic := '0';
    signal data_out : signed(31 downto 0) := (others => '0');
    signal pc : signed(15 downto 0) := (others => '0');
    signal pc_out : signed(15 downto 0) := (others => '0');
    signal br_flag : std_logic := '0';

    signal ram_data_out : std_logic_vector(31 downto 0) := (others => '0');
    signal iFileIO : fileIoT := none;

begin

    ramIO_inst : ramIO
    generic map(
        addrWd => 16,
        dataWd => 32,
        fileId => "ram.dat"
    )
    port map(
        nWE => nwe,
        addr => std_logic_vector(addr),
        dataI => std_logic_vector(data),
        dataO => ram_data_out,
        fileIO => iFileIO
    );

    memory_acc_inst : memory_acc
    port map(
        clk => clk,
        opC => opC,
        opC_out => opC_out,
        r1 => r1,
        imm => imm,
        r1_out => r1_out,
        imm_out => imm_out,
        long_imm => long_imm,
        data => data,
        addr => addr, -- kann die addresse gleichzeitig mit dem opc übertragen werden?
        nwe => nwe,
        data_out => data_out,
        pc => pc,
        pc_out => pc_out,
        br_flag => br_flag
    );

    process (clk)
    begin
        if falling_edge(clk) then
            data_out <= signed(ram_data_out);
        end if;
    end process;

    process is
    begin
        iFileIO <= load, none after 5 ns;
        for j in 1 to 1000 loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- process that drives the opc
    process is
    begin
        wait for 5 ns;
        opC <= 11;
        addr <= to_signed(0, 16);
        data <= to_signed(100, 32);
        wait for 10 ns;
        addr <= to_signed(1, 16);
        wait for 10 ns;
        data <= to_signed(10, 32);
        opC <= 10;
        wait for 10 ns;
        addr <= to_signed(0, 16);
        wait for 10 ns;
        addr <= to_signed(1, 16);
        wait for 10 ns;
        addr <= to_signed(2, 16);

        wait;
    end process;

end architecture memory_accTestArch;