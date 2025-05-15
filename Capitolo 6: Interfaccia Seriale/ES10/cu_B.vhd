library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cu_B is
  Port ( 
        clock: in std_logic;
        reset: in std_logic;
        write: out std_logic; -- per scrivere il dato in memoria
        en_count: out std_logic;
        count: in std_logic_vector(2 downto 0);
        RDA: in std_logic;
        RD: out std_logic
        );
end cu_B;

architecture Behavioral of cu_B is
       type state is (IDLE,AVVIA_LETTURA_UART,AVVIA_SCRITTURA_MEM,INCR_CONT,FINE);
	   signal stato_corrente,stato_prossimo: state;

begin
   
			  
    comb: process(stato_corrente,RDA)
            begin
           
            
            
            case stato_corrente is
                when idle=>
                        en_count<='0';
                        if RDA = '0' then
                            stato_prossimo<=idle;
                        elsif RDA='1' then
                            stato_prossimo<=AVVIA_LETTURA_UART;
                        end if;
                
                when AVVIA_LETTURA_UART=> 
                        RD<='1';
                        stato_prossimo<=AVVIA_SCRITTURA_MEM;
                
                when AVVIA_SCRITTURA_MEM=>
                        RD<='1';
                        write<='1'; 
                        stato_prossimo<=INCR_CONT;

                        
                        
               when INCR_CONT =>
                        RD<='0';
                        write<='0';
                        en_count<='1';
                        if count="111" then
                            stato_prossimo<=FINE;
                         else 
                            stato_prossimo<=IDLE;
                        end if;
                        
                        
               when FINE =>
                        en_count <= '0';
                        RD <= '0';
                        stato_prossimo <= FINE;
                        
                        
                            
               end case;
         end process;
                        
           
           reg_stato: process(clock)
			  begin
			  if(clock'event and clock='1') then
		         if(reset='1') then 
				    stato_corrente <=idle;
			    else 
				    stato_corrente <=stato_prossimo;
			     end if;
			  end if;
			  end process;              
    
    


end Behavioral;
