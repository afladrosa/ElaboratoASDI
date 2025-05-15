library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity sys is
 Port (clock: in std_logic;
        reset: in std_logic;
        start: in std_logic );
end sys;

architecture Structural of sys is
  signal txd_to_rxd: std_logic; -- collego TXD del nodo A con RXD del nodo B.
  
  
  component unita_A is
     Port ( 
            clock: in std_logic;
            reset: in std_logic;
            start: in std_logic;
            TXD: out std_logic
            
            );
    end component;
    
    
     component unita_B is
     Port ( 
            clock: in std_logic;
            reset: in std_logic;
            RXD: in std_logic
            
            
            );
    end component;

begin
    
    A: unita_A 
     Port map( 
            clock=>clock,
            reset=>reset,
            start=>start,
            TXD => txd_to_rxd
            
            );
            
    B: unita_B 
     Port map( 
            clock=>clock,
            reset=> reset,
            RXD=> txd_to_rxd
            
            
            );


end Structural;
