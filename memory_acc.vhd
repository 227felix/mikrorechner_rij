LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.mydefinitions.ALL;

ENTITY memory_acc IS
	PORT (
		clk : IN STD_LOGIC;

		opC : IN INTEGER RANGE 0 TO 63;
		opC_out : OUT INTEGER RANGE 0 TO 63;

		r1 : IN signed (4 DOWNTO 0); -- durchgereicht
		imm : IN signed (15 DOWNTO 0); 
		r1_out : OUT signed (4 DOWNTO 0); -- durchgereicht
		imm_out : OUT signed (15 DOWNTO 0);

		long_imm : IN signed (25 DOWNTO 0); -- für jmp

		data : IN signed (31 DOWNTO 0); -- vorher a 
		addr : IN signed (15 DOWNTO 0); -- vorher b
		writeEn : OUT STD_LOGIC; -- Für den RAM

		data_out : OUT signed (31 DOWNTO 0); --vorher a_out

		pc : IN signed (31 DOWNTO 0);
		pc_out : OUT signed (31 DOWNTO 0);

		br_flag : IN STD_LOGIC

	);
END ENTITY memory_acc;
ARCHITECTURE memory_acc_arch OF memory_acc IS
BEGIN
	PROCESS (clk)
	BEGIN

		IF rising_edge(clk) THEN
			writeEn <= '-';
			CASE opC IS
				WHEN ldw =>
					writeEn <= '1';
				WHEN stw =>
				WHEN jmp =>
					pc_out <= resize(long_imm, 32);
				WHEN beq =>
					IF br_flag = '1' THEN
						pc_out <= pc + imm;
					END IF;
				WHEN OTHERS =>
					NULL;
			END CASE;
		END IF;
	END PROCESS;
END ARCHITECTURE memory_acc_arch;