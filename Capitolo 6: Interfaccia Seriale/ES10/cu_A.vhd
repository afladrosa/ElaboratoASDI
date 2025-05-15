library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cu_A is
  Port ( 
        clock: in std_logic;
        WR: out std_logic;
        TBE: in std_logic;
        reset: in std_logic;
        read: out std_logic;
        en_count: out std_logic;
        count: in std_logic_vector(2 downto 0);
        start: in std_logic 
        );
end cu_A;

architecture Behavioral of cu_A is
       type state is (idle,AVVIA_LETTURA,AVVIA_TRASFERIMENTO,ATTENDI_TBE,INCR_CONT);
	   signal stato_corrente,stato_prossimo: state;

begin
    
			  
    comb: process(stato_corrente,start,TBE)
            begin
            
            
            case stato_corrente is
                when idle=>
                        WR<='0';
                        en_count<='0';
                        if start = '0' then
                            stato_prossimo<=idle;
                        else
                            stato_prossimo<=AVVIA_LETTURA;
                        end if;
                
                 when AVVIA_LETTURA=>
                    en_count<='0';
                    read<='1';
                    stato_prossimo<=AVVIA_TRASFERIMENTO;
                
                when AVVIA_TRASFERIMENTO=>
                        read<='0';
                        WR<='1'; 
                        stato_prossimo<=ATTENDI_TBE;
                
                when ATTENDI_TBE =>
                        WR<='0';
                        if TBE='1' then 
                            stato_prossimo<=INCR_CONT;
                        else
                            stato_prossimo<=ATTENDI_TBE;
                        end if;
                        
                        
               when INCR_CONT =>
                        en_count<='1';
                        if count="111" then
                            stato_prossimo<=IDLE;
                         else 
                            stato_prossimo<=AVVIA_LETTURA;
                        end if;
                        
                            
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
