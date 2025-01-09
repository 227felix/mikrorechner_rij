library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mydefinitions.all;

entity alu is
	port (
		a : in signed (31 downto 0);
		b : in signed (31 downto 0);
		imm : in signed (15 downto 0);
		opC : in integer range 0 to 63;
		alu_out : out signed (31 downto 0);
		br_flag : out std_logic
	);
end entity alu;

architecture alu_architecture of alu is
	signal product : signed(63 downto 0);
begin
	process (a, b, imm, opC) is
	begin
		alu_out <= (others => '-');
		br_flag <= '-';
		case opC is
			when add =>
				alu_out <= a + b;
			when subt =>
				alu_out <= a - b;
			when neg =>
				alu_out <= 0 - a;
			when mul =>
				product <= a * b;
				alu_out <= product(31 downto 0);
			when div =>
				alu_out <= a / b;
			when modu =>
				alu_out <= a mod b;
			when nicht =>
				alu_out <= not a;
			when und =>
				alu_out <= a and b;
			when oder =>
				alu_out <= a or b;
			when beq =>
				if a = b then
					br_flag <= '1';
				else
					br_flag <= '0';
				end if;
			when bneq =>
				if a = b then
					br_flag <= '0';
				else
					br_flag <= '1';
				end if;
			when blt =>
				if a < b then
					br_flag <= '1';
				else
					br_flag <= '0';
				end if;
			when others =>
				null;

		end case;

	end process;

end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mydefinitions.all;

entity execute is
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
end entity execute;

architecture execute_architecture of execute is

	component alu is
		port (
			a : in signed (31 downto 0);
			b : in signed (31 downto 0);
			imm : in signed (15 downto 0);
			opC : in integer range 0 to 63;
			alu_out : out signed (31 downto 0);
			br_flag : out std_logic
		);
	end component alu;

	signal alu_signal : signed(31 downto 0);
	signal br_signal : std_logic;
begin

	assign : process (clk) is
	begin
		if rising_edge(clk) then
			opC_out <= opC;

			r1_out <= r1;
			r2_out <= r2;
			imm_out <= imm;

			long_imm_out <= long_imm;

			a_out <= a;

			pc_out <= pc;

			br_flag_out <= br_signal;
			if opC < 6 then
				b_out <= alu_signal;
			else
				b_out <= b;
			end if;

		end if;
	end process assign;
	ALUI : alu
	port map(
		a => a,
		b => b,
		imm => imm,
		opC => opC,
		alu_out => alu_signal,
		br_flag => br_signal
	);

end architecture execute_architecture;