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
    led : out std_logic_vector(3 downto 0)
  );
end top;

architecture Behavioral of top is

  signal heartbeat_counter : unsigned(25 downto 0);
  signal do : std_logic_vector (7 downto 0);

begin

  process(clk100mhz)
  begin
    if rising_edge(clk100mhz) then
      heartbeat_counter <= heartbeat_counter + 1;
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
    DO_REG => 0 -- Optional output register (0 or 1)
  )
  port map (
    DO => do, -- Output read data port, width defined by READ_WIDTH parameter
    DI => "01010101", -- Input write data port, width defined by WRITE_WIDTH parameter
    RDADDR => "000000000000", -- Input read address, width defined by read port depth
    RDCLK => clk100mhz, -- 1-bit input read clock
    RDEN => btn(3), -- 1-bit input read port enable
    REGCE => btn(2), -- 1-bit input read output register enable
    RST => '0', -- 1-bit input reset
    WE => btn(0 downto 0), -- Input write enable, width defined by write port depth
    WRADDR => "000000000000", -- Input write address, width defined by write port depth
    WRCLK => clk100mhz, -- 1-bit input write clock
    WREN => btn(0) -- 1-bit input write port enable
  );

end Behavioral;
