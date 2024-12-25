LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.mydefinitions.ALL;

ENTITY decode IS
  PORT (
    clk : IN STD_LOGIC;

    instr : IN signed (31 DOWNTO 0);

    opC : OUT INTEGER range 0 TO 63;

    -- i-format
    r1_out : BUFFER signed (4 DOWNTO 0);
    r2_out : BUFFER signed (4 DOWNTO 0);
    imm : OUT signed (15 DOWNTO 0);

    -- j-format
    long_imm: OUT signed (25 DOWNTO 0);

    -- r-format
    r3_out : OUT signed (4 DOWNTO 0);
    r4_out : OUT signed (4 DOWNTO 0);
    r5_out : OUT signed (4 DOWNTO 0);

    -- values from register file
    a : OUT signed (31 DOWNTO 0);
    b : OUT signed (31 DOWNTO 0);

    wb : IN signed (31 DOWNTO 0); -- weg glaub
    wb_addr : IN signed (4 DOWNTO 0);  -- weg glaub
    writeEn : IN STD_LOGIC; -- weg glaub

    pc : IN signed (15 DOWNTO 0);
    pc_out : OUT signed (15 DOWNTO 0)

  );

END ENTITY decode;

ARCHITECTURE decode_arch OF decode IS
  TYPE regTy IS ARRAY (0 TO 31) OF signed (31 DOWNTO 0);
  SIGNAL regBank : regTy := (others => (others => '0'));


BEGIN
  decoding : PROCESS (clk) IS
  BEGIN
    IF rising_edge(clk) THEN
      opC <= to_integer(unsigned(instr(31 DOWNTO 26)));

      r1_out <= instr(25 DOWNTO 21);
      r2_out <= instr(20 DOWNTO 16);
      imm <= instr(15 DOWNTO 0);

      long_imm <= instr(25 DOWNTO 0);

      r3_out <= instr(15 DOWNTO 11);
      r4_out <= instr(10 DOWNTO 6);
      r5_out <= instr(5 DOWNTO 1);

      pc_out <= pc + 1;
    END IF;
  END PROCESS decoding;

  writeBack : PROCESS (clk) IS
  BEGIN
    IF rising_edge(clk) THEN
      IF writeEn = '1' THEN
        regBank(to_integer(unsigned(wb_addr))) <= wb;
      END IF;
    END IF;
  END PROCESS writeBack;

  read : PROCESS (clk) IS
  BEGIN
    IF rising_edge(clk) THEN
      a <= regBank(to_integer(unsigned(r1_out)));
      b <= regBank(to_integer(unsigned(r2_out)));
    END IF;
  END PROCESS read;

END ARCHITECTURE decode_arch;