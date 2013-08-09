
-- VHDL Instantiation Created from source file mt48lc4m16a2.vhd -- 22:01:48 08/05/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT mt48lc4m16a2
	PORT(
		Addr : IN std_logic_vector(11 downto 0);
		Ba : IN std_logic_vector(1 downto 0);
		Clk : IN std_logic;
		Cke : IN std_logic;
		Cs_n : IN std_logic;
		Ras_n : IN std_logic;
		Cas_n : IN std_logic;
		We_n : IN std_logic;
		Dqm : IN std_logic_vector(1 downto 0);       
		Dq : INOUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	Inst_mt48lc4m16a2: mt48lc4m16a2 PORT MAP(
		Dq => ,
		Addr => ,
		Ba => ,
		Clk => ,
		Cke => ,
		Cs_n => ,
		Ras_n => ,
		Cas_n => ,
		We_n => ,
		Dqm => 
	);


