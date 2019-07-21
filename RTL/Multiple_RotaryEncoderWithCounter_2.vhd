--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Multiple_RotaryEncoderWithCounter_2.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::SmartFusion2> <Die::M2S025> <Package::256 VF>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
library work;
use work.pkg_apb3.all;

entity Multiple_RotaryEncoderWithCounter_2 is
port (

    apb3_master : in apb3;
    apb3_master_Back : out apb3_Back;
    reset : in  std_logic;      -- Reset.
    a_i     : in  std_logic_vector(1 downto 0);            -- A phase of rotary encoder.
    b_i     : in  std_logic_vector(1 downto 0)            -- B phase of rotary encoder.
);
end Multiple_RotaryEncoderWithCounter_2;
architecture architecture_Multiple_RotaryEncoderWithCounter_2 of Multiple_RotaryEncoderWithCounter_2 is
   -- signal, component etc. declarations
	signal signal_name1 : std_logic; -- example
	signal signal_name2 : std_logic_vector(1 downto 0) ; -- example
	signal counter_enc : apb3_Reg_array(1 downto 0); -- example

begin
apb3_reader_sr04 : entity work.apb3_reader 
generic map( 
        Number_Reg => 2,
        REG_DEFINITION =>(R,R)
)
port map(
      reset =>reset,
      apb3_master =>apb3_master,
      apb3_master_Back =>apb3_master_Back,

      Regs_In =>counter_enc,
      Regs_Out=>open

);
  GEN_RotaryEncoderWithCounter_2 : FOR i IN 0 to 1 generate

 RotaryEncoderWithCounter_1 : entity work.RotaryEncoderWithCounter 
    port map(
      clk_i   =>apb3_master.clk,
      reset_i =>reset,    -- Reset.
      a_i    =>a_i(I),          -- A phase of rotary encoder.
      b_i     =>b_i(i),          -- B phase of rotary encoder.
      cnt_o   =>counter_enc(I)    -- counter output.
      );
  end generate GEN_RotaryEncoderWithCounter_2;

 
   -- architecture body
end architecture_Multiple_RotaryEncoderWithCounter_2;
