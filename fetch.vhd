LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.mydefinitions.ALL;

ENTITY fetch IS
	PORT (
		clk : IN STD_LOGIC;
		pc : IN signed (4 DOWNTO 0);
		pc_out : OUT signed (4 DOWNTO 0)
	);
END ENTITY fetch;

ARCHITECTURE fetch_arch OF fetch IS
BEGIN

	fetching : PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			pc_out <= pc + 4;
		END IF;
	END PROCESS fetching;
END ARCHITECTURE fetch_arch;