library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity write_backTest is
end entity write_backTest;

architecture write_backTestArch of write_backTest is

    component write_back is
        port (
            clk : in std_logic;
            opC : in integer range 0 to 63;
            r1 : in signed(4 downto 0);
            r1_out : out signed(4 downto 0);
            data : in signed(31 downto 0);
            data_out : out signed(31 downto 0);
            writeEn_out : out std_logic
        );
    end component write_back;

    signal clk : std_logic;
    signal opC : integer range 0 to 63;
    signal r1 : signed(4 downto 0);
    signal r1_out : signed(4 downto 0);
    signal data : signed(31 downto 0);
    signal data_out : signed(31 downto 0);
    signal writeEn_out : std_logic;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut : write_back port map(
        clk => clk,
        opC => opC,
        r1 => r1,
        r1_out => r1_out,
        data => data,
        data_out => data_out,
        writeEn_out => writeEn_out

    );

    clk_process : process
    begin
        for j in 1 to 1000 loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        for i in 0 to 6 loop
            opC <= i;
            r1 <= to_signed(0, 5);
            data <= to_signed(i * 10, 32);
            wait for 10 ns;
        end loop;
        wait;
    end process;

end architecture write_backTestArch;