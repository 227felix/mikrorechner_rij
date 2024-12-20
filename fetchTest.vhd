library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.memPkg.all;

entity fetchTest is

end entity fetchTest;

architecture fetchTestArch of fetchTest is

    component fetch is
        port (
            clk : in std_logic;
            pc : in signed(4 downto 0);
            pc_out : out signed(4 downto 0)
        );
    end component fetch;

    signal clk : std_logic := '0';
    signal pc : signed(4 downto 0) := to_signed(0, 5);
    signal pc_out : signed(4 downto 0) := to_signed(0, 5);

    signal iAddr : std_logic_vector(4 downto 0) := (others => '0');
    signal iData : std_logic_vector(31 downto 0) := (others => '0');
    signal iFileIO : fileIoT := none;

begin

    instrMemI : rom generic map(addrWd => 5, dataWd => 32, fileId => "instMem.dat")
    port map(addr => iAddr, data => iData, fileIO => iFileIO);

    clocking : fetch port map(clk, pc, pc_out);
    process is
    begin
        for j in 1 to 1000 loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            pc <= pc_out;
            iAddr <= std_logic_vector(to_unsigned(0, iAddr'length - pc_out'length)) & std_logic_vector(pc_out);
        end loop;
        wait;
    end process;

    -- a process, that connects the 5-bit pc_out to the 32-bit iAddr
end architecture fetchTestArch;