----------------------------------------------------------------------------------
-- Company:        IIHE - ULB
-- Engineer:       Thomas Lenzi (thomas.lenzi@cern.ch)
-- 
-- Create Date:    15:17:59 07/09/2015 
-- Design Name:    OptoHybrid v2
-- Module Name:    ec_bc - Behavioral 
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

entity ec_bc is
port(

    ref_clk_i   : in std_logic;
    reset_i     : in std_logic;
    
    vfat2_t1_i  : in t1_t;
    
    rd_i        : in std_logic;
    valid_o     : out std_logic;
    error_o     : out std_logic;
    data_o      : out std_logic_vector(31 downto 0)
    
);
end ec_bc;

architecture Behavioral of ec_bc is

    signal bc               : unsigned(11 downto 0);
    signal ec               : unsigned(15 downto 0);
    signal skipped_vfat_bc0 : std_logic;
    
    signal wr               : std_logic;
    
    signal unf              : std_logic;
    signal full             : std_logic;
    
    signal had_unf          : std_logic;
    signal had_ovf          : std_logic;

begin

    error_o <= unf;

    process(ref_clk_i)
    begin
        if (rising_edge(ref_clk_i)) then
            if (reset_i = '1') then
                bc <= (others => '0');
                ec <= (others => '0');
                wr <= '0';
                skipped_vfat_bc0 <= '0';
                had_unf <= '0';
                had_ovf <= '0';
            elsif (vfat2_t1_i.resync = '1') then
                bc <= (others => '0');
                ec <= (others => '0');
                wr <= '0';
                skipped_vfat_bc0 <= '0';
                had_unf <= '0';
                had_ovf <= '0';
            else
                if (vfat2_t1_i.bc0 = '1') then
                    bc <= (others => '0');
                    skipped_vfat_bc0 <= '0';
                else
                    bc <= bc + 1;
                end if;
                
                if (vfat2_t1_i.lv1a = '1') then
                    ec <= ec + 1;
                    wr <= '1';
                    if ((vfat2_t1_i.bc0 = '1') or (bc = x"000") or (bc = x"001")) then
                        skipped_vfat_bc0 <= '1';
                    end if;
                else 
                    wr <= '0';
                end if;
                
                if (unf = '1') then
                    had_unf <= '1';
                else
                    had_unf <= had_unf;
                end if;
                
                if ((full = '1') and (wr = '1')) then
                    had_ovf <= '1';
                else
                    had_ovf <= had_ovf;
                end if;
                
            end if;
        end if;
    end process;
    
    fifo_inst : entity work.fifo_bx
    port map(
        clk         => ref_clk_i,
        rst         => reset_i or vfat2_t1_i.resync,
        wr_en       => wr,
        din         => std_logic_vector(bc) & '0' & had_unf & had_ovf & skipped_vfat_bc0 & std_logic_vector(ec),
        rd_en       => rd_i,
        valid       => valid_o,
        dout        => data_o,
        underflow   => unf,
        full        => full,
        empty       => open
    );    

end Behavioral;