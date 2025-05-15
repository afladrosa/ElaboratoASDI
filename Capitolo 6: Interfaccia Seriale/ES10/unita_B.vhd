library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity unita_B is
 Port ( 
        clock: in std_logic;
        reset: in std_logic;
       -- TXD: out std_logic;
        RXD: in std_logic
        
        
        );
end unita_B;

architecture Structural of unita_B is
    signal write: std_logic:='0';
    signal count: std_logic_vector(2 downto 0);
    signal byte_received: std_logic_vector (7 downto 0);
    signal en_cont: std_logic;
    signal umax_cont: std_logic;
    signal output: std_logic_vector(7 downto 0); -- contenuto della memoria
    signal RD: std_logic;
    signal RDA_temp: std_logic;
    
    
    component counter is
    generic(
        
        n: integer := 3 ;--numero di bit necessari
        modulo: integer := 8
        );
    port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC; --ingresso di reset per azzerare il contatore
		   enable : in STD_LOGIC; 
           umax: out STD_LOGIC; -- si alza quando si raggiunge il valore massimo di conteggio
           counter : out  STD_LOGIC_VECTOR (n-1 downto 0));
 
    end component;
    
    
    component Rs232RefComp is
    Port ( 
		TXD 	: out std_logic  	:= '1';
    	RXD 	: in  std_logic;					
    	CLK 	: in  std_logic;					--Master Clock
		DBIN 	: in  std_logic_vector (7 downto 0);--Data Bus in
		DBOUT : out std_logic_vector (7 downto 0);	--Data Bus out
		RDA	: inout std_logic;						--Read Data Available(1 quando il dato è disponibile nel registro rdReg)
		TBE	: inout std_logic 	:= '1';				--Transfer Bus Empty(1 quando il dato da inviare è stato caricato nello shift register)
		RD		: in  std_logic;					--Read Strobe(se 1 significa "leggi" --> fa abbassare RDA)
		WR		: in  std_logic;					--Write Strobe(se 1 significa "scrivi" --> fa abbassare TBE)
		PE		: out std_logic;					--Parity Error Flag
		FE		: out std_logic;					--Frame Error Flag
		OE		: out std_logic;					--Overwrite Error Flag
		RST		: in  std_logic	:= '0');			--Master Reset
    end component;
    
    
    component mem is
    port(
        CLK: in std_logic;
        RST: in std_logic;
        write: in std_logic; -- Segnale di scrittura
        ADDR : in std_logic_vector(2 downto 0);
        data_in: in std_logic_vector(7 downto 0);
        data_out: out std_logic_vector(7 downto 0) -- Uscita dati
    );
    end component;
    
    
    component cu_B is
      Port ( 
            clock: in std_logic;
            reset: in std_logic;
            write: out std_logic; -- per scrivere il dato in memoria
            en_count: out std_logic;
            count: in std_logic_vector(2 downto 0);
            RDA: in std_logic;
            RD: out std_logic
            );
    end component;
    

begin

    CONT_A: counter
    generic map(
        
        n => 3 ,--numero di bit necessari
        modulo=> 8
        )
    port map( clock => clock,
           reset => reset,
		   enable => en_cont,
           umax => umax_cont,
           counter =>count
         
         );
         
         
    mem_b: mem 
    port map(
        CLK => clock,
        RST => reset,
        write => write,
        ADDR => count,
        data_in => byte_received,
        data_out  => output
       
    );
    
    
    cu: cu_B 
      Port map( 
            clock=> clock,
            reset=> reset,
            write=> write,
            en_count=>en_cont,
            count => count,
            RDA => RDA_temp,
            RD=>RD
            );
 
 
    uart_b: Rs232RefComp 
    Port map ( 
		--TXD 	=> '1',
    	RXD 	=> RXD,				
    	CLK 	=> clock,					--Master Clock
		DBIN =>	"00000000",--Data Bus in
		DBOUT => byte_received,	--Data Bus out
		RDA	=>RDA_temp,					--Read Data Available(1 quando il dato è disponibile nel registro rdReg)
		--TBE	: inout std_logic 	:= '1';				--Transfer Bus Empty(1 quando il dato da inviare è stato caricato nello shift register)
		RD	=> RD,				--Read Strobe(se 1 significa "leggi" --> fa abbassare RDA)
		WR	=>'0',					--Write Strobe(se 1 significa "scrivi" --> fa abbassare TBE)
		--PE		: out std_logic;					--Parity Error Flag
		--FE		: out std_logic;					--Frame Error Flag
		--OE		: out std_logic;					--Overwrite Error Flag
		RST		=> reset			--Master Reset
        );
  
  
 
  
            


end Structural;
