LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.mydefinitions.ALL;

ENTITY memory_acc IS
	PORT (
		clk : IN STD_LOGIC;

		opC : IN INTEGER RANGE 0 TO 63;
		opC_out : OUT INTEGER RANGE 0 TO 63;

		r1 : IN signed (4 DOWNTO 0);
		imm : IN signed (15 DOWNTO 0);
		r1_out : OUT signed (4 DOWNTO 0);
		imm_out : OUT signed (15 DOWNTO 0);

		long_imm : IN signed (25 DOWNTO 0);
		long_imm_out : OUT signed (25 DOWNTO 0);


		a : IN signed (31 DOWNTO 0);

		a_out : OUT signed (31 DOWNTO 0);

		pc : IN signed (31 DOWNTO 0);
		pc_out : OUT signed (31 DOWNTO 0);

		alu : IN signed (31 DOWNTO 0);
		alu_out : OUT signed (31 DOWNTO 0);
		br_flag : IN STD_LOGIC;

		data : OUT signed (31 DOWNTO 0);
		wb_addr : OUT signed (4 DOWNTO 0);
		writeEn : OUT STD_LOGIC -- Warum mnicht erst im write_back?
	);
END ENTITY memory_acc;
ARCHITECTURE memory_acc_arch OF memory_acc IS
BEGIN
	PROCESS (opC, br_flag, pc, imm)
	BEGIN
		writeEn <= '-';
		CASE opC IS
			WHEN ldw =>
				writeEn <= '1';
				data <= r1;
			WHEN stw =>
			WHEN jmp =>
				pc_out <= long_imm;
			WHEN beq =>
				IF br_flag = '1' THEN
					pc_out <= pc + imm;
				END IF;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS;
END ARCHITECTURE memory_acc_arch;