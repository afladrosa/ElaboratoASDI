
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;



entity counter is
    generic(
        
        n: integer := 3 ;--numero di bit necessari
        modulo: integer := 8
        
        );
    
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC; --ingresso di reset per azzerare il contatore
		   enable : in STD_LOGIC; 
           umax: out STD_LOGIC; -- si alza quando si raggiunge il valore massimo di conteggio
           counter : out  STD_LOGIC_VECTOR (n-1 downto 0));
           
           
end counter;

architecture Behavioral of counter is

signal c : std_logic_vector (n-1 downto 0) := (others => '0');


signal u : std_logic := '0';

begin

counter <= c; --valore attuale del contatore


counter_process: process(clock)
begin
         
         if rising_edge(clock) then
          if (reset = '1') then  --sia reset che set sono sincroni con il clock.
            c <= (others => '0');
          elsif (enable='1') then
              
              if( c=std_logic_vector(TO_UNSIGNED(modulo-1,n))) then
                c <= (others => '0');
                
               else
                     c <= std_logic_vector(unsigned(c) + 1);

              end if;
           end if;
          end if;
    end process;
    

    
     proc_count_max: process(clock)
     begin
        if rising_edge(clock) then 
            if (reset = '1') then
                u <= '0'; --reset del segnale
            elsif (c= std_logic_vector(TO_UNSIGNED(modulo-1,n))) then --cast per type mismatch
                u <= '1'; --attivo quando raggiungo il massimo
            else
                u <= '0'; --se no rimane basso
            end if;
        end if;
     end process;
    
    
  
   umax<=u;

end Behavioral;
