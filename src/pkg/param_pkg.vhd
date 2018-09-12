library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package param_pkg is

    constant USE_DEFAULT_GBT_CLK    : boolean := TRUE;
    
    constant MAJOR_VERSION          : std_logic_vector(7 downto 0) := x"02";
    constant MINOR_VERSION          : std_logic_vector(7 downto 0) := x"03";
    constant RELEASE_VERSION        : std_logic_vector(7 downto 0) := x"00";
    
    constant RELEASE_YEAR           : std_logic_vector(15 downto 0) := x"2018";
    constant RELEASE_MONTH          : std_logic_vector(7 downto 0) := x"09";
    constant RELEASE_DAY            : std_logic_vector(7 downto 0) := x"05";
        
end param_pkg;

package body param_pkg is 

  
end param_pkg;
