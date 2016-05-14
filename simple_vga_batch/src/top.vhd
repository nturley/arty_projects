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
    sw : in std_logic_vector(3 downto 0);
    led : out std_logic_vector(3 downto 0);
    r1 : out std_logic;
    r2 : out std_logic;
    g1 : out std_logic;
    g2 : out std_logic;
    b1 : out std_logic;
    b2 : out std_logic;
    h_sync : out std_logic;
    v_sync : out std_logic;
    v33 : out std_logic
  );
end top;

architecture Behavioral of top is

  signal heartbeat_counter : unsigned(25 downto 0);
  signal disp_ena : std_logic;
  signal row : unsigned(9 downto 0);
  signal col : unsigned(9 downto 0);
  signal pclk : std_logic;
  signal colblock : unsigned(5 downto 0);
  
  signal r1_nxt : std_logic;
  signal g1_nxt : std_logic;
  signal b1_nxt : std_logic;
  signal r2_nxt : std_logic;
  signal g2_nxt : std_logic;
  signal b2_nxt : std_logic;
begin

  vga_controllerx : entity work.vga_controller(Behavioral)
  port map (
    clk100mhz => clk100mhz,
    h_sync => h_sync,
    v_sync => v_sync,
    disp_ena => disp_ena,
    row => row,
    col => col,
    pclk => pclk
  );
  
  process(pclk)
  begin
    if rising_edge(pclk) then
      r1 <= r1_nxt;
      g1 <= g1_nxt;
      b1 <= b1_nxt;
      r2 <= r2_nxt;
      g2 <= g2_nxt;
      b2 <= b2_nxt;
            
    end if;
  end process;
  colblock <= resize(col / 10, 6);
  r1_nxt <= '1' when colblock(0)='1' and disp_ena='1' else '0';
  g1_nxt <= '1' when colblock(1)='1' and disp_ena='1' else '0';
  b1_nxt <= '1' when colblock(2)='1' and disp_ena='1' else '0';
  r2_nxt <= '1' when colblock(3)='1' and disp_ena='1' else '0';
  g2_nxt <= '1' when colblock(4)='1' and disp_ena='1' else '0';
  b2_nxt <= '1' when colblock(5)='1' and disp_ena='1' else '0';
  
  
  
    process(clk100mhz)
    begin
        if rising_edge(clk100mhz) then
            heartbeat_counter <= heartbeat_counter + 1;
        end if;
    end process;
    -- PWM
    led(0) <= '0' when heartbeat_counter(3 downto 0) > unsigned(sw) else '1';
    -- Heartbeat
    led(3) <= heartbeat_counter(25);
    
    v33 <= '1';
    
end Behavioral;
