library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mydefinitions.all;

entity memory_acc is
	port (
		clk : in std_logic;

		opC : in integer range 0 to 63;
		opC_out : out integer range 0 to 63;

		r1 : in signed (4 downto 0); -- durchgereicht
		imm : in signed (15 downto 0);
		r1_out : out signed (4 downto 0); -- durchgereicht
		imm_out : out signed (15 downto 0);

		long_imm : in signed (25 downto 0); -- für jmp

		data : in signed (31 downto 0); -- vorher a 
		addr : in signed (15 downto 0); -- vorher b
		nwe : out std_logic; -- Für den RAM

		data_out : out signed (31 downto 0); --vorher a_out

		pc : in signed (15 downto 0);
		pc_out : out signed (15 downto 0);

		br_flag : in std_logic

	);
end entity memory_acc;
architecture memory_acc_arch of memory_acc is
begin
	process (clk)
	begin
		if rising_edge(clk) then
			opC_out <= opC;
			pc_out <= pc + 1;
			nwe <= '1';
			case opC is
				when ldw =>
					nwe <= '1'; -- wenn aus dem RAM gelesen wird muss nwe auf 1 gesetzt werden
				when stw =>
					nwe <= '0'; -- wenn in den RAM geschrieben wird muss nwe auf 0 gesetzt werden
				when jmp =>
					pc_out <= resize(long_imm, 16);
				when others =>
					null;
			end case;
			if opC > 5 and opC < 9 then -- Branches
				if br_flag = '1' then
					pc_out <= pc + imm; -- man könnte hier 1 adden
				end if;
			end if;
		end if;
	end process;
end architecture memory_acc_arch;