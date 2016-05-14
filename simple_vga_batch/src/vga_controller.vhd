library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity vga_controller is
  port (
    clk100mhz : in std_logic;
    h_sync : out std_logic;
    v_sync : out std_logic;
    disp_ena : out std_logic;
    row : out unsigned(9 downto 0);
    col : out unsigned(9 downto 0);
    pclk : out std_logic
  );
end vga_controller;

architecture Behavioral of vga_controller is

  signal pix_clk : std_logic;
  signal clkfb : std_logic;
  
  signal h_sync_nxt : std_logic;
  signal v_sync_nxt : std_logic;
  signal disp_ena_nxt : std_logic;

  constant h_display_time : integer := 640;
  constant h_front_porch : integer := 16;
  constant h_sync_time : integer := 96;
  constant h_back_porch : integer := 48;
  
  constant v_display_time : integer := 480;
  constant v_front_porch : integer := 10;
  constant v_sync_time : integer := 2;
  constant v_back_porch : integer := 33;
  
  constant hsync_start : integer := h_display_time + h_front_porch;
  constant hsync_end : integer := hsync_start + h_sync_time;
  constant end_of_line: integer := hsync_end + h_back_porch;
    
  constant vsync_start: integer := v_display_time + v_front_porch;
  constant vsync_end: integer := vsync_start + v_sync_time;
  constant end_of_frame: integer := vsync_start + v_back_porch - 1;

  signal h_counter : unsigned(9 downto 0);
  signal v_counter : unsigned(9 downto 0);

begin
--26892
  clocking : PLLE2_BASE
  generic map (
    BANDWIDTH          => "OPTIMIZED",
    CLKFBOUT_MULT      => 8,
    CLKFBOUT_PHASE     => 0.0,
    CLKIN1_PERIOD      => 10.0,

    CLKOUT0_DIVIDE     => 32,
    CLKOUT0_DUTY_CYCLE => 0.5,
    CLKOUT0_PHASE      => 0.0,

    DIVCLK_DIVIDE      => 1,
    REF_JITTER1        => 0.0,
    STARTUP_WAIT       => "FALSE"
  )
  port map (
    CLKIN1   => clk100mhz,
    CLKOUT0 => pix_clk,
    CLKFBOUT => clkfb,
    CLKFBIN  => clkfb,
    PWRDWN   => '0',
    RST      => '0'
  );
  
  process(pix_clk)
    begin
      if rising_edge(pix_clk) then
      
        -- update all output buffer regs
        h_sync <= h_sync_nxt;
        v_sync <= v_sync_nxt;
        disp_ena <= disp_ena_nxt;

        
        -- update counters
        if h_counter < end_of_line then
          h_counter <= h_counter + 1;
        else
          h_counter <= (others=>'0');
          if v_counter < end_of_frame then
            v_counter <= v_counter + 1;
          else
            v_counter <= (others=>'0');
          end if;
        end if;
      end if;
    end process;
  
  col <= h_counter;
  row <= v_counter;
  h_sync_nxt <= '0' when h_counter > hsync_start and h_counter < hsync_end else '1';
  v_sync_nxt <= '0' when v_counter > vsync_start and v_counter < vsync_end else '1';
  disp_ena_nxt <= '1' when h_counter < h_display_time and v_counter < v_display_time else '0';

  pclk <= pix_clk;
end Behavioral;
