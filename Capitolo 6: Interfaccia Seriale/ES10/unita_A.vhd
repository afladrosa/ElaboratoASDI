library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity unita_A is
 Port ( 
        clock: in std_logic;
        reset: in std_logic;
        start: in std_logic;
        TXD: out std_logic
       -- RXD: in std_logic
        
        );
end unita_A;

architecture Structural of unita_A is
    signal count: std_logic_vector(2 downto 0);
    signal byte_to_send: std_logic_vector (7 downto 0);
    signal en_cont: std_logic;
    signal umax_cont: std_logic;
    signal WR: std_logic;
    signal TBE_temp: std_logic;
    signal read: std_logic;
    
    component rom is
    port(
        address : in std_logic_vector(2 downto 0);
        read: in std_logic;
        clock: in std_logic;
        dout    : out std_logic_vector(7 downto 0)
    );
    end component;
    
    
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
    
    
    
    component cu_A is
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
    end component;

begin
    ROM_A: rom 
        port map
        (
        address => count,
        read => read,
        clock=>clock,
        dout  => byte_to_send
        );
    
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
 
  
    cu: cu_A 
      Port map( 
            clock=> clock,
            WR=> WR,
            TBE=> TBE_temp,
            reset=> reset,
            read=> read,
            en_count=> en_cont,
            count=> count,
            start=>start
            );
            
            
    uart: Rs232RefComp
    Port map( 
		TXD  => TXD,
		RXD => '0',				
    	CLK 	=> clock,					--Master Clock
	   DBIN 	=> byte_to_send,              --Data Bus in
	--	DBOUT => dbout,    	         --Data Bus out
	--	RDA	: inout std_logic;						--Read Data Available(1 quando il dato è disponibile nel registro rdReg)
		TBE	=> TBE_temp,				--Transfer Bus Empty(1 quando il dato da inviare è stato caricato nello shift register)
		RD=>'1',					--Read Strobe(se 1 significa "leggi" --> fa abbassare RDA)
		WR	=> WR,					--Write Strobe(se 1 significa "scrivi" --> fa abbassare TBE)
		--PE		: out std_logic;					--Parity Error Flag
		--FE		: out std_logic;					--Frame Error Flag
		--OE		: out std_logic;					--Overwrite Error Flag
		RST		=>reset		--Master Reset
		);


end Structural;
