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
    btn : in std_logic_vector(3 downto 0);
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
  signal do : std_logic_vector (7 downto 0);

  signal row : unsigned(9 downto 0);
  signal col : unsigned(9 downto 0);
  signal disp_ena : std_logic;

  signal pclk : std_logic;

  signal r1_nxt : std_logic;
  signal g1_nxt : std_logic;
  signal b1_nxt : std_logic;
  signal r2_nxt : std_logic;
  signal g2_nxt : std_logic;
  signal b2_nxt : std_logic;

begin

  process(clk100mhz)
  begin
    if rising_edge(clk100mhz) then
      heartbeat_counter <= heartbeat_counter + 1;
    end if;
  end process;

   process(pclk)
  begin
    if rising_edge(pclk) then
      r1 <= do(0) and disp_ena;
      r2 <= do(1) and disp_ena;
      g1 <= do(2) and disp_ena;
      g2 <= do(3) and disp_ena;
      b1 <= do(4) and disp_ena;
      b2 <= do(5) and disp_ena;
    end if;
  end process;

  -- Heartbeat
  led(3) <= heartbeat_counter(25);
  led(2 downto 0) <= do(2 downto 0);

  BRAM_SDP_MACRO_inst : BRAM_SDP_MACRO
  generic map (
    BRAM_SIZE => "36Kb", -- Target BRAM, "18Kb" or "36Kb"
    DEVICE => "7SERIES", -- Target device: "VIRTEX5", "VIRTEX6", "7SERIES", "SPARTAN6"
    WRITE_WIDTH => 8, -- Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
    READ_WIDTH => 8, -- Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
    DO_REG => 0, -- Optional output register (0 or 1)

    INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000", -- ROW 3
    INIT_3D => X"00000000000000000000000F0F0F0F0F0F0F0F0F0F0F00000000000000000000",
    INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
    INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",

    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000", -- ROW 4
    INIT_51 => X"000000000000000F0F0F0F0F0F000F0F0F0F0F0F000F0F0F0F0F000000000000",
    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",

    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000", -- ROW 5
    INIT_65 => X"0000000000000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0000000000",
    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",

    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000", -- ROW 6
    INIT_79 => X"00000000000F0F0F0F0F0F0F0F0F0F0F000F0F0F0F0F0F0F0F0F0F0F00000000",
    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",

    INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000", -- ROW 7
    INIT_0D => X"00000000000F0F0F00000F0F0F0F0F0F0F0F0F0F0F0F0F00000F0F0F00000000",
    INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
    INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",

    INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000", -- ROW 8
    INIT_21 => X"0000000000000F0F0F0F0000000F0F0F0F0F0F0F0000000F0F0F0F0000000000",
    INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
    INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",

    INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000", -- ROW 9
    INIT_35 => X"000000000000000F0F0F0F0F0F000000000000000F0F0F0F0F0F000000000000",
    INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
    INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",

    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000", --ROW 10
    INIT_49 => X"00000000000000000000000F0F0F0F0F0F0F0F0F0F0F00000000000000000000",
    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000"
  )
  port map (
    DO => do, -- Output read data port, width defined by READ_WIDTH parameter
    DI => "01010101", -- Input write data port, width defined by WRITE_WIDTH parameter
    -- This formula is completely wrong but I made it work anyway
    RDADDR => std_logic_vector(resize((640*(row/15)+col/7),12)), -- Input read address, width defined by read port depth
    RDCLK => pclk, -- 1-bit input read clock
    RDEN => '1', -- 1-bit input read port enable
    REGCE => '1', -- 1-bit input read output register enable
    RST => '0', -- 1-bit input reset
    WE => btn(0 downto 0), -- Input write enable, width defined by write port depth
    WRADDR => "000000000000", -- Input write address, width defined by write port depth
    WRCLK => pclk, -- 1-bit input write clock
    WREN => btn(0) -- 1-bit input write port enable
  );

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

end Behavioral;
