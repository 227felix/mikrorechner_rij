library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mydefinitions.all;

entity decode is
  port (
    clk : in std_logic;

    instr : in signed (31 downto 0);

    opC : out integer range 0 to 63;

    -- i-format
    r1_out : buffer signed (4 downto 0);
    r2_out : buffer signed (4 downto 0);
    imm : out signed (15 downto 0);

    -- j-format
    long_imm : out signed (25 downto 0);

    -- r-format
    r3_out : out signed (4 downto 0);
    r4_out : out signed (4 downto 0);
    r5_out : out signed (4 downto 0);

    -- values from register file
    a : out signed (31 downto 0);
    b : out signed (31 downto 0);

    wb : in signed (31 downto 0);
    wb_addr : in signed (4 downto 0);
    writeEn : in std_logic;

    pc : in signed (15 downto 0);
    pc_out : out signed (15 downto 0)

  );

end entity decode;

architecture decode_arch of decode is
  type regTy is array (0 to 31) of signed (31 downto 0);
  signal regBank : regTy := (
    0 => to_signed(0, 32),
    1 => to_signed(1, 32),
    2 => to_signed(2, 32),
    3 => to_signed(3, 32),
    4 => to_signed(4, 32),
    5 => to_signed(5, 32),
    6 => to_signed(6, 32),
    7 => to_signed(7, 32),
    8 => to_signed(8, 32),
    9 => to_signed(9, 32),
    10 => to_signed(10, 32),
    11 => to_signed(11, 32),
    12 => to_signed(12, 32),
    13 => to_signed(13, 32),
    14 => to_signed(14, 32),
    15 => to_signed(15, 32),
    16 => to_signed(16, 32),
    17 => to_signed(17, 32),
    18 => to_signed(18, 32),
    19 => to_signed(19, 32),
    20 => to_signed(20, 32),
    21 => to_signed(21, 32),
    22 => to_signed(22, 32),
    23 => to_signed(23, 32),
    24 => to_signed(24, 32),
    25 => to_signed(25, 32),
    26 => to_signed(26, 32),
    27 => to_signed(27, 32),
    28 => to_signed(28, 32),
    29 => to_signed(29, 32),
    30 => to_signed(30, 32),
    31 => to_signed(31, 32)
  );

begin
  decoding : process (clk) is
  begin
    if rising_edge(clk) then
      opC <= to_integer(unsigned(instr(31 downto 26)));

      r1_out <= instr(25 downto 21);
      r2_out <= instr(20 downto 16);
      imm <= instr(15 downto 0);

      long_imm <= instr(25 downto 0);

      r3_out <= instr(15 downto 11);
      r4_out <= instr(10 downto 6);
      r5_out <= instr(5 downto 1);

      pc_out <= pc + 1;
    end if;
  end process decoding;

  writeBack : process (clk) is
  begin
    if rising_edge(clk) then
      if writeEn = '1' then
        regBank(to_integer(unsigned(wb_addr))) <= wb;
      end if;
    end if;
  end process writeBack;

  read : process (clk) is
  begin
    if rising_edge(clk) then
      a <= regBank(to_integer(unsigned(r1_out)));
      b <= regBank(to_integer(unsigned(r2_out)));
    end if;
  end process read;

end architecture decode_arch;