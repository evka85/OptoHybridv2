----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
-- 
-- Create Date:    15:17:59 07/09/2015 
-- Design Name:    OptoHybrid v2
-- Module Name:    timer - Behavioral 
-- Project Name:   OptoHybrid v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description: 
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity timer is
port(
    ref_clk_i   : in std_logic;
    reset_i     : in std_logic;
    
    start_i     : in std_logic;
    stop_i      : in std_logic;
    
    data_o      : out std_logic_vector(31 downto 0)
    
);
end timer;

architecture Behavioral of timer is

    type state_t is (IDLE, RUN, STOP);
    signal state    : state_t;
    signal data     : unsigned(31 downto 0);

begin

    process(ref_clk_i)
    begin
        if (rising_edge(ref_clk_i)) then
            if (reset_i = '1') then
                state <= IDLE;
                data <= (others => '0');
            else 
                case state is
                    when IDLE =>
                        data <= (others => '0');
                        if (start_i = '1') then
                            state <= RUN;
                        end if;
                    when RUN => 
                        data <= data + 1;
                        if (stop_i = '1') then
                            state <= STOP;
                        end if;
                    when others => 
                        state <= STOP;
                end case;                    
            end if;
        end if;
    end process;
    
    data_o <= std_logic_vector(data);

end Behavioral;