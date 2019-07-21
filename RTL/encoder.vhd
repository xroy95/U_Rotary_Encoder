library IEEE;
use IEEE.std_logic_1164.all;

package RotaryEncoderPckg is

  component RotaryEncoder is
    port (
      clk_i : in  std_logic;            -- Input clock.
      a_i   : in  std_logic;            -- A phase of rotary encoder.
      b_i   : in  std_logic;            -- B phase of rotary encoder.
      en_o  : out std_logic;            -- True when rotation increment occurs.
      cw_o  : out std_logic  -- True if rotation is clockwise, false if counter-clockwise.
      );
  end component;

  component RotaryEncoderWithCounter is
    generic (
      INITIAL_CNT_G    : integer := 0   -- Initial value of counter.
      );
    port (
      clk_i   : in  std_logic;          -- Input clock.
      reset_i : in  std_logic ;    -- Reset.
      a_i     : in  std_logic;          -- A phase of rotary encoder.
      b_i     : in  std_logic;          -- B phase of rotary encoder.
      cnt_o   : out std_logic_vector(31 downto 0)    -- counter output.
      );
  end component;

end package;
library IEEE;
use IEEE.MATH_REAL.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RotaryEncoderPckg.all;

entity RotaryEncoderWithCounter is
  generic (
    INITIAL_CNT_G    : integer := 0     -- Initial value of counter.
    );
  port (
    clk_i   : in  std_logic;            -- Input clock.
    reset_i : in  std_logic;      -- Reset.
    a_i     : in  std_logic;            -- A phase of rotary encoder.
    b_i     : in  std_logic;            -- B phase of rotary encoder.
    cnt_o   : out std_logic_vector(31 downto 0)      -- counter output.
    );
end entity;

architecture arch of RotaryEncoderWithCounter is
  signal cnt_r       : signed(cnt_o'range) := TO_SIGNED(INITIAL_CNT_G, cnt_o'length);
  signal en_s        : std_logic;
  signal cw_s        : std_logic;
begin
  
  u0 : RotaryEncoder
    port map(
      clk_i => clk_i,
      a_i   => a_i,
      b_i   => b_i,
      en_o  => en_s,
      cw_o  => cw_s
      );

  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if reset_i = '0' then
        cnt_r <= TO_SIGNED(INITIAL_CNT_G, cnt_o'length);
      elsif en_s = '1' then              -- A rotational increment occured.
        if cw_s = '1' then              -- A clockwise movement occured.
          
            cnt_r <= cnt_r + 1;
        else                -- A counter-clockwise movement occured.
          
            cnt_r <= cnt_r - 1;
        end if;
      end if;
    end if;
  end process;

  cnt_o <= std_logic_vector(cnt_r);
  
end architecture;

library IEEE;
use IEEE.MATH_REAL.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity RotaryEncoder is
  port (
    clk_i : in  std_logic;              -- Input clock.
    a_i   : in  std_logic;              -- A phase of rotary encoder.
    b_i   : in  std_logic;              -- B phase of rotary encoder.
    en_o  : out std_logic;              -- True when rotation increment occurs.
    cw_o  : out std_logic  -- True if rotation is clockwise, false if counter-clockwise.
    );
end entity;

architecture arch of RotaryEncoder is
  signal aDelay_r : std_logic_vector(2 downto 0);  -- Delay lines for sync'ing A and B inputs to clock.
  signal bDelay_r : std_logic_vector(aDelay_r'range);
begin
  
  process(clk_i)
  begin
    -- Load A and B inputs into delay lines.
    if rising_edge(clk_i) then
      aDelay_r <= a_i & aDelay_r(aDelay_r'high downto 1);
      bDelay_r <= b_i & bDelay_r(bDelay_r'high downto 1);
    end if;
  end process;

  -- Enable output goes high whenever there is a transition on A or B.
  en_o <= aDelay_r(1) xor aDelay_r(0) xor bDelay_r(1) xor bDelay_r(0);
  -- Direction of rotation is determined by current value of A and previous value of B.
  cw_o <= aDelay_r(1) xor bDelay_r(0);
  
end architecture;