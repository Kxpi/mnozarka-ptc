library ieee;
use ieee.std_logic_1164.all;

--- Pojedynczy sumator 1-bitowy
entity Sumator is
        port ( 
            A:      in  std_logic; --- pierwszy bit
            B:      in  std_logic; --- drugi bit
            Cin:    in  std_logic; --- przeniesienie na wejściu
            S:      out std_logic; --- suma dodawania
            Cout:    out std_logic --- przeniesienie na wyjściu
        );
end entity Sumator;

architecture structure of Sumator is
begin
	S<= A XOR B XOR Cin; 							 --- wyliczenie wyniku
	Cout<= (A AND B) OR (A AND Cin) OR (B AND Cin);  --- wyliczenie przeniesienia
end architecture structure;

------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--- Sumator 4-bitowy
entity Sumator4b is
        port ( 
            X:      in  std_logic_vector (3 downto 0); --- pierwszy składnik dodawania
            Y:      in  std_logic_vector (3 downto 0); --- drugi składnik dodawania
            Cin:    in  std_logic;					   --- przeniesienie na wejściu
            S:      out std_logic_vector (3 downto 0); --- suma dodawania
           Cout:    out std_logic					   --- przeniesienie na wyjściu
        );
end entity Sumator4b;


architecture structure of Sumator4b is

component Sumator
Port (A,B,Cin : in STD_LOGIC;
       S,Cout : out STD_LOGIC);
end component;

signal c: STD_LOGIC_VECTOR (2 downto 0); --- wektor przechowujący przeniesienia między sumatorami 1-bitowymi

begin
	--- 4 sumatory jedno-bitowe tworzące sumator 4-bitowy; przekazują między sobą przeniesienie korzystając z wektora c
	S1: Sumator port map( X(0), Y(0), Cin, S(0), c(0));
	S2: Sumator port map( X(1), Y(1), c(0), S(1), c(1));
	S3: Sumator port map( X(2), Y(2), c(1), S(2), c(2));
	S4: Sumator port map( X(3), Y(3), c(2), S(3), Cout);
end architecture structure;

------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--- rejest 4-bitowy
entity register_4b is
    Port ( CLK : in  STD_LOGIC;  --- zegar
		   RST : in STD_LOGIC;   --- reset 
           R : in  STD_LOGIC_VECTOR (3 downto 0); --- wejście
           Q : out  STD_LOGIC_VECTOR (3 downto 0)); --- wyjście
end register_4b;

architecture structure of register_4b is

begin

process(CLK)
begin
    if rising_edge(CLK) then
        if RST='0' then --- warunek dla resetu, 0 ponieważ key[0-3] po naciśnięciu dają stan negatywny
			Q <= "0000"; --- zerowanie rejestru
		else
			Q <= R;   --- przypisanie nowej wartości
		end if;
    end if;
end process;

end structure;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--- rejestr 8-bitowy przeznaczony dla wektora wynikowego
entity register_8b is
    Port ( CLK : in  STD_LOGIC;  --- zegar
		   RST : in STD_LOGIC;  --- reset
           R : in  STD_LOGIC_VECTOR (7 downto 0); --- wejście
           Q : out  STD_LOGIC_VECTOR (7 downto 0)); --- wyjście
end register_8b;

architecture structure of register_8b is

begin

process(CLK)
begin
    if rising_edge(CLK) then
        if RST='0' then -- warunek dla resetu, 0 ponieważ key[0-3] po naciśnięciu dają stan negatywny
			Q <= "00000000"; --- zerowanie rejestru
		else
			Q <= R;  --- przypisanie nowej wartości
		end if;
    end if;
end process;

end structure;

------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

--- instrukcje związane z wyświetlaniem na ekranach 7-segmentowych
entity wyswietlacz is 
    port (
		wejscie1: in std_logic_vector(3 downto 0); --- 1 liczba
		wejscie2: in std_logic_vector(3 downto 0); --- 2 liczba
		wynik: in std_logic_vector(7 downto 0);  --- wyjścia ilustrujące wynik
		h0: out std_logic_vector(0 to 6); --- wyświetlacz 7-segmentowy
		h1: out std_logic_vector(0 to 6); --- wyświetlacz 7-segmentowy
		h2: out std_logic_vector(0 to 6); --- wyświetlacz 7-segmentowy
		h3: out std_logic_vector(0 to 6); --- wyświetlacz 7-segmentowy
		h4: out std_logic_vector(0 to 6); --- wyświetlacz 7-segmentowy
		h5: out std_logic_vector(0 to 6); --- wyświetlacz 7-segmentowy
		h6: out std_logic_vector(0 to 6); --- wyświetlacz 7-segmentowy
		h7: out std_logic_vector(0 to 6) --- wyświetlacz 7-segmentowy
    );
end entity wyswietlacz;

architecture structure of wyswietlacz is 

--- konwersja 8-bit bin na bcd
function bin_bcd ( bin : std_logic_vector(7 downto 0) ) return std_logic_vector is --- funkcja konwerująca 8 bitową liczbę z wynikiem na 12-bitowy BCD
	variable i : integer:=0;
	variable bcd : unsigned(11 downto 0) := (others => '0');
	variable bint : unsigned(7 downto 0) := unsigned(bin);

begin
	for i in 0 to 7 loop  -- repeating 8 times.
	bcd(11 downto 1) := bcd(10 downto 0);  --shifting the bits.
	bcd(0) := bint(7);
	bint(7 downto 1) := bint(6 downto 0);
	bint(0) :='0';


	if(i < 7 and bcd(3 downto 0) > "0100") then --add 3 if BCD digit is greater than 4.
	bcd(3 downto 0) := bcd(3 downto 0) + "0011";
	end if;

	if(i < 7 and bcd(7 downto 4) > "0100") then --add 3 if BCD digit is greater than 4.
	bcd(7 downto 4) := bcd(7 downto 4) + "0011";
	end if;

	if(i < 7 and bcd(11 downto 8) > "0100") then  --add 3 if BCD digit is greater than 4.
	bcd(11 downto 8) := bcd(11 downto 8) + "0011";
	end if;

end loop;
return std_logic_vector(bcd);
end bin_bcd;

--- tabela przeglądowa
function lookup_table( bcd : std_logic_vector(3 downto 0) ) return std_logic_vector is
	variable res : std_logic_vector(6 downto 0);
begin
		if bcd="0000" then
			res := "0000001";
		elsif bcd="0001" then
			res := "1001111";
		elsif bcd="0010" then
			res := "0010010";
		elsif bcd="0011" then
			res := "0000110";
		elsif bcd="0100" then
			res := "1001100";
		elsif bcd="0101" then
			res := "0100100";
		elsif bcd="0110" then
			res := "0100000";
		elsif bcd="0111" then
			res := "0001111";
		elsif bcd="1000" then
			res := "0000000";
		elsif bcd="1001" then
			res := "0000100";
		end if;

return res;
end lookup_table;

signal wynik_bcd1, wynik_bcd2, wynik_bcd3: std_logic_vector(11 downto 0); --- sygnaly wynikowe po konwersji na bcd
signal wejscie1_resized, wejscie2_resized: std_logic_vector(7 downto 0); --- wektory na "rozszerzone" do 8 bitów liczby wejściowe

begin

wynik_bcd1 <= bin_bcd(wynik);
wejscie1_resized <= std_logic_vector(resize(unsigned(wejscie1), 8));
wejscie2_resized <= std_logic_vector(resize(unsigned(wejscie2), 8));
h0 <= lookup_table(wynik_bcd1(3 downto 0));
h1 <= lookup_table(wynik_bcd1(7 downto 4));
h2 <= lookup_table(wynik_bcd1(11 downto 8));
h3 <= "1111111";
wynik_bcd2 <= bin_bcd(wejscie2_resized);
h4 <= lookup_table(wynik_bcd2(3 downto 0));
h5 <= lookup_table(wynik_bcd2(7 downto 4));
wynik_bcd3 <= bin_bcd(wejscie1_resized);
h6 <= lookup_table(wynik_bcd3(3 downto 0));
h7 <= lookup_table(wynik_bcd3(7 downto 4));

end architecture structure;

---------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--- instrukcje związane z operacją mnożenia i rejestrami
entity mnozarka is 
    port (
        A: in std_logic_vector(3 downto 0);   --- pierwsza liczba
		B: in std_logic_vector(3 downto 0);   --- druga liczba
		res: buffer std_logic_vector(7 downto 0)  --- wyjścia z wynikiem
    );
end entity mnozarka;


architecture structure of mnozarka is
    component Sumator4b
        port ( 
            X:      in  std_logic_vector (3 downto 0); 
            Y:      in  std_logic_vector (3 downto 0);
            Cin:    in  std_logic;
            S:      out std_logic_vector (3 downto 0);
            Cout:    out std_logic
        );
    end component;

	signal A_B: std_logic_vector(15 downto 0); --- wektor z wynikami bramek AND

    signal A_B0, A_B1, A_B2:  std_logic_vector (3 downto 0); --- wektory z podzielonymi wynikami bramek dla poszczególnych sumatorów

    signal wejscia0, wejscia1, wejscia2:  std_logic_vector (3 downto 0); --- wektory z kolejnymi wejściami dla poszczególnych "rzędów"
	---A0 - sw4
	---A1 - sw5
	---A2 - sw6
	---A3 - sw7
	---B0 - sw0
	---B1 - sw1
	---B2 - sw2
	---B3 - sw3
	
	begin
		--- przypisanie do wektora wyników bramek AND
		A_B(0)<= A(0) and B(0);
		A_B(1)<= A(1) and B(0);
		A_B(2)<= A(2) and B(0);
		A_B(3)<= A(3) and B(0);
		A_B(4)<= A(0) and B(1);
		A_B(5)<= A(1) and B(1);
		A_B(6)<= A(2) and B(1);
		A_B(7)<= A(3) and B(1);
		A_B(8)<= A(0) and B(2);
		A_B(9)<= A(1) and B(2);
		A_B(10)<= A(2) and B(2);
		A_B(11)<= A(3) and B(2);
		A_B(12)<= A(0) and B(3);
		A_B(13)<= A(1) and B(3);
		A_B(14)<= A(2) and B(3);
		A_B(15)<= A(3) and B(3);

		wejscia0 <= ('0',A_B(3),A_B(2),A_B(1)); --- wejścia początkowe 1 sumatora
		A_B0 <= (A_B(7),A_B(6),A_B(5),A_B(4));		  --- wyniki bramek dla pierwszego sumatora
		A_B1 <= (A_B(11),A_B(10),A_B(9),A_B(8));	  --- wyniki bramek dla drugiego sumatora
		A_B2 <= (A_B(15),A_B(14),A_B(13),A_B(12));	  --- wyniki bramek dla trzeciego sumatora
		
		res(0) <= A_B(0); --- res0 = A0 AND B0
		
		SM4_1: Sumator4b port map ( X => A_B0, Y => wejscia0, Cin => '0', --- X = pierwsze wejscie, wyniki bramek; Y = drugie wejście; Cin = przeniesienie wejściowe 
									   Cout=>wejscia1(3), 			  --- przepisanie poszczególnych bitów przeniesienia oraz wynikowych do wektora z nowymi wejściami
									   S(3)=>wejscia1(2),
									   S(2)=>wejscia1(1),
									   S(1)=>wejscia1(0),
									   S(0)=>res(1));  			  --- ledg1 = ajstarszy bit 1 sumatora
												
		SM4_2: Sumator4b port map ( X => A_B1, Y => wejscia1, Cin => '0', --- X = pierwsze wejscie, wyniki bramek; Y = wyjścia z 1 sumatora; Cin = przeniesienie wejściowe 
									   Cout=>wejscia2(3), 			  --- przepisanie poszczególnych bitów przeniesienia oraz wynikowych do wektora z nowymi wejściami
									   S(3)=>wejscia2(2),
									   S(2)=>wejscia2(1),
									   S(1)=>wejscia2(0),
									   S(0)=>res(2));				  --- ledg2 = najstarszy bit 2 sumatora
												  
		SM4_3: Sumator4b port map ( X => A_B2, Y => wejscia2, Cin => '0', --- X = pierwsze wejscie, wyniki bramek; Y = wyjścia z 2 sumatora; Cin = przeniesienie wejściowe 
									   Cout=>res(7),   			  --- res7 = przeniesienie z ostatniego sumatora
									   S => res(6 downto 3));  	  --- res6 do res3 to bity wynikowe ostatniego sumatora
		
										
end architecture structure;

-----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mnozenie is 
    port (
		CLOCK_50: in std_logic;                --- zegar wbudowany
      	sw: in std_logic_vector(7 downto 0);   --- liczby wejściowe
        key: in std_logic_vector(3 downto 0);  --- przyciski do obsługi układu
		hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector(0 to 6); --- wyswietlacze
		ledg: buffer std_logic_vector(7 downto 0)  --- wyjścia ilustrujące wynik binarnie
    );
end entity mnozenie;

architecture structure of mnozenie is

component mnozarka is 
    port (
        A: in std_logic_vector(3 downto 0);
		B: in std_logic_vector(3 downto 0);
		res: buffer std_logic_vector(7 downto 0)
    );
end component;

component register_4b is
	port (
		CLK : in  STD_LOGIC;
		RST : in STD_LOGIC;
        R : in  STD_LOGIC_VECTOR (3 downto 0);
        Q : out  STD_LOGIC_VECTOR (3 downto 0)
	);
end component;

component register_8b is
	port (
		CLK : in  STD_LOGIC;
		RST : in STD_LOGIC;
        R : in  STD_LOGIC_VECTOR (7 downto 0);
        Q : out  STD_LOGIC_VECTOR (7 downto 0)
	);
end component;

component wyswietlacz is 
    port (
		wejscie1: in std_logic_vector(3 downto 0);
		wejscie2: in std_logic_vector(3 downto 0);
		wynik: in std_logic_vector(7 downto 0); 
		h0: out std_logic_vector(0 to 6); 
		h1: out std_logic_vector(0 to 6); 
		h2: out std_logic_vector(0 to 6); 
		h3: out std_logic_vector(0 to 6); 
		h4: out std_logic_vector(0 to 6); 
		h5: out std_logic_vector(0 to 6); 
		h6: out std_logic_vector(0 to 6); 
		h7: out std_logic_vector(0 to 6)
    );
	end component;

signal liczba1, liczba2 : std_logic_vector(3 downto 0); --- 1 liczba (sw[7-4]) i 2 liczba (sw[3-0])
signal wynik_mnozenia : std_logic_vector(7 downto 0); --- wynik operacji mnozenia

begin

	--- rejest wejściowy A
	REG_A: register_4b port map(
		CLK=>CLOCK_50,
		RST=>key(0),
		R=>sw(7 downto 4),
		Q=>liczba1
	);
	
	--- rejest wejściowy B
	REG_B: register_4b port map(
		CLK=>CLOCK_50,
		RST=>key(0),
		R=>sw(3 downto 0),
		Q=>liczba2
	);

	--- mnożarka
	MNOZARKA_1: mnozarka port map(
		A=>liczba1,
		B=>liczba2,
		res=>wynik_mnozenia
	);

	--- rejestr wyjściowy 8-bit
	REG_W: register_8b port map(
		CLK=>CLOCK_50,
		RST=>key(0),
		R=>wynik_mnozenia,
		Q=>ledg
	);

	--- wyświetlacz
	WYSW: wyswietlacz port map ( wejscie1 => liczba1, wejscie2 => liczba2, wynik => wynik_mnozenia,
	h0=>hex0,
	h1=>hex1,
	h2=>hex2,
	h3=>hex3,
	h4=>hex4,
	h5=>hex5,
	h6=>hex6,
	h7=>hex7);

end architecture;