library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mydefinitions.all;

entity write_back is
	port (
		clk : in std_logic;

		opC : in integer range 0 to 63;

		r1 : in signed (4 downto 0);

		a : in signed (31 downto 0);
		a_out : out signed (31 downto 0);

		alu : in signed (31 downto 0);
		alu_out : out signed (31 downto 0);

		data : in signed (31 downto 0);
		data_out : out signed (31 downto 0);
		wb_addr : in signed (4 downto 0);
		wb_addr_out : out signed (4 downto 0);
		writeEn : in std_logic;
		writeEn_out : out std_logic
	);
end entity write_back;

architecture write_back_arch of write_back is
begin

end architecture write_back_arch;