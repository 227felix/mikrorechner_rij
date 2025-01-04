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

    wb : in signed (31 downto 0); -- weg glaub
    wb_addr : in signed (4 downto 0); -- weg glaub
    writeEn : in std_logic; -- weg glaub

    pc : in signed (15 downto 0);
    pc_out : out signed (15 downto 0)

  );

end entity decode;

architecture decode_arch of decode is
  type regTy is array (0 to 31) of signed (31 downto 0);
  signal regBank : regTy := (others => (others => '0'));

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