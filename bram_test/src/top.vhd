library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;
library UNIMACRO;
use unimacro.Vcomponents.all;

entity top is
  port (
    clk100mhz : in std_logic;
    led : out std_logic_vector(3 downto 0)
  );
end top;

architecture Behavioral of top is

  signal heartbeat_counter : unsigned(25 downto 0);

begin

    process(clk100mhz)
    begin
        if rising_edge(clk100mhz) then
            heartbeat_counter <= heartbeat_counter + 1;
        end if;
    end process;

    -- Heartbeat
    led(3) <= heartbeat_counter(25);

end Behavioral;
