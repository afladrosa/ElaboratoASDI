library ieee;
 use ieee.std_logic_1164.all;
 use ieee.numeric_std.all;
 entity rom is
    port(
        clock: in std_logic;
        read: in std_logic;
        address : in  std_logic_vector(2 downto 0);
        dout    : out std_logic_vector(7 downto 0)
    );
 end entity rom;
 architecture dataflow of rom is
    type MEMORY_8_8 is array (0 to 7) of std_logic_vector(7 downto 0);
    constant ROM_8_8 : MEMORY_8_8 := (
        x"00",
        x"01",
        x"02",
        x"03",
        x"04",
        x"05",
        x"06",
        x"07"
    
    );
 begin
    main : process(clock)
    begin
    if rising_edge(clock) then
        if read='1' then
            dout <= ROM_8_8(to_integer(unsigned(address)));
        end if;
     end if;
    end process main;
 end architecture dataflow;

