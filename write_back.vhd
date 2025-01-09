library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mydefinitions.all;

entity write_back is
	port (
		clk : in std_logic;

		opC : in integer range 0 to 63;

		r1 : in signed (4 downto 0); -- write back address
		r1_out : out signed (4 downto 0);

		-- MIPS verwendet auch noch a und a_out (ich glaub damit WB etwas zu tun hat  (mux))

		data : in signed (31 downto 0);
		data_out : out signed (31 downto 0);

		writeEn_out : out std_logic
	);
end entity write_back;

architecture write_back_arch of write_back is
begin

	process (clk)
	begin
		if rising_edge(clk) then
			if opC = ldw or opC < 6 then
				r1_out <= r1;
				data_out <= data;
				writeEn_out <= '1';

			else
				r1_out <= (others => '-');
				data_out <= (others => '-');
				writeEn_out <= '0';
			end if;
		end if;
	end process;

end architecture write_back_arch;