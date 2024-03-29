library  ieee;
use ieee.std_logic_1164.all;

entity fsmgcd is
	port(RESET, CLK : in std_logic;
	    A, B : in integer;
	    GCD : out integer);
end fsmgcd;

architecture behavior of fsmgcd is
type state is (start, input, output, check, check1,updatex,  updatey);
signal current_state, next_state: state;
begin
state_register:Process(CLK, RESET)
BEGIN
	IF(RESET = '1') THEN
		current_state <= start;
	ELSIF(rising_edge(CLK)) THEN
		current_state <= next_state;
	END IF;
end process;
compute:Process(A, B, current_state)
variable x, y, r, p : integer;
begin
	case current_state IS 
		WHEN start =>
			next_state <= input;
		WHEN input =>
			x:= A;
			y:= B;
			next_state <= check;
		WHEN check =>
			if(x< y) THEN
				next_state <= updatex;
			else
				next_state <= updatey;
			END IF;
			next_state <= check1;
		WHEN  check1 =>
			while y /= 0 loop
				r:= x mod y;
				x:= y;
				y:= r;
			end loop;
			next_state <= output;
		WHEN updatex =>
			p:=x;
			x:=y;
			y:=p;
		when updatey =>
			x:=x;
			y:=y;
		WHEN output =>
			GCD <= 	x;
			next_state <= start;
		WHEN others =>
			next_state <= start;
	end case;
end process compute;
end behavior;