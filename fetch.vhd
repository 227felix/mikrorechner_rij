library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mydefinitions.all;

entity fetch is
	port (
		clk : in std_logic;
		pc : in signed (15 downto 0);
		pc_out : out signed (15 downto 0)
	);
end entity fetch;

architecture fetch_arch of fetch is
begin

	fetching : process (clk) is
	begin
		if rising_edge(clk) then
			pc_out <= pc + 1;
			-- pc_out <= pc + 1;
		end if;
	end process fetching;
end architecture fetch_arch;