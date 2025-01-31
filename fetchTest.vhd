library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all; -- Import std_logic_textio for image function
use work.mempkg.all;

entity fetchTest is
end entity fetchTest;

architecture fetchTestArch of fetchTest is

    component fetch is
        port (
            clk : in std_logic;
            pc : in signed(15 downto 0);
            pc_out : out signed(15 downto 0)
        );
    end component fetch;

    signal clk : std_logic := '0';
    signal pc : signed(15 downto 0) := to_signed(0, 16);
    signal pc_out : signed(15 downto 0) := to_signed(0, 16);

    signal iAddr : std_logic_vector(15 downto 0) := (others => '0');
    signal iData : std_logic_vector(31 downto 0) := (others => '0');
    signal iFileIO : fileIoT := none;

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

    clocking : fetch
    port map(
        clk => clk,
        pc => pc,
        pc_out => pc_out
    );

    process is
    begin
        iFileIO <= load, none after 5 ns;

        for j in 1 to 100 loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            pc <= pc_out;
            iAddr <= std_logic_vector(pc_out);

        end loop;
        wait;
    end process;

end architecture fetchTestArch;