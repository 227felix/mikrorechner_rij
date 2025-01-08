LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.mydefinitions.ALL;

ENTITY alu IS
	PORT (
		a : IN signed (31 DOWNTO 0);
		b : IN signed (31 DOWNTO 0);
		imm : IN signed (15 DOWNTO 0);
		opC : IN INTEGER RANGE 0 TO 63;
		alu_out : OUT signed (31 DOWNTO 0);
		br_flag : OUT STD_LOGIC
	);
END ENTITY alu;

ARCHITECTURE alu_architecture OF alu IS
	SIGNAL product : signed(63 DOWNTO 0);
BEGIN
	PROCESS (a, b, imm, opC) IS
	BEGIN
		alu_out <= (OTHERS => '-');
		br_flag <= '-';
		CASE opC IS
			WHEN add =>
				alu_out <= a + b;
			WHEN subt =>
				alu_out <= a - b;
			WHEN neg =>
				alu_out <= 0 - a;
			WHEN mul =>
				product <= a * b;
				alu_out <= product(31 DOWNTO 0);
			WHEN div =>
				alu_out <= a / b;
			WHEN modu =>
				alu_out <= a MOD b;
			WHEN nicht =>
				alu_out <= NOT a;
			WHEN und =>
				alu_out <= a AND b;
			WHEN oder =>
				alu_out <= a OR b;
			WHEN beq =>
				IF a = b THEN
					br_flag <= '1';
				ELSE
					br_flag <= '0';
				END IF;
			WHEN bneq =>
				IF a = b THEN
					br_flag <= '0';
				ELSE
					br_flag <= '1';
				END IF;
			WHEN blt =>
				IF a < b THEN
					br_flag <= '1';
				ELSE
					br_flag <= '0';
				END IF;
			WHEN OTHERS =>
				NULL;

		END CASE;

	END PROCESS;

END ARCHITECTURE;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.mydefinitions.ALL;

ENTITY execute IS
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
END ENTITY execute;

ARCHITECTURE execute_architecture OF execute IS

	COMPONENT alu IS
		PORT (
			a : IN signed (31 DOWNTO 0);
			b : IN signed (31 DOWNTO 0);
			imm : IN signed (15 DOWNTO 0);
			opC : IN INTEGER RANGE 0 TO 63;
			alu_out : OUT signed (31 DOWNTO 0);
			br_flag : OUT STD_LOGIC
		);
	END COMPONENT alu;

	SIGNAL alu_signal : signed(31 DOWNTO 0);
	SIGNAL br_signal : STD_LOGIC;
BEGIN

	assign : PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			opC_out <= opC;

			r1_out <= r1;
			r2_out <= r2;
			imm_out <= imm;

			long_imm_out <= long_imm;

			a_out <= a;

			pc_out <= pc;

			br_flag_out <= br_signal;
		IF opC = add OR opC = subt OR opC = neg OR opC = mul OR opC = div OR opC = modu OR opC = nicht OR opC = und OR opC = oder THEN
			b_out <= alu_signal;
		ELSE
			b_out <= b;
		end if;

		END IF;
	END PROCESS assign;
	ALUI : alu
	PORT MAP(
		a => a,
		b => b,
		imm => imm,
		opC => opC,
		alu_out => alu_signal,
		br_flag => br_signal
	);

END ARCHITECTURE execute_architecture;