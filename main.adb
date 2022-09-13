with Ada.Text_IO;  use Ada.Text_IO;
with def_monitor;  use def_monitor;
with Ada.Numerics.Discrete_Random;
-------------------------------------------------------------------------------
--
--      NOM: Joan Martorell Ferriol
--      LINK: https://youtu.be/xu9ZqTe5Iio
--
-------------------------------------------------------------------------------
procedure Main is
   MAX_BABUINS : constant Integer := 10; --Número de tareas
   MAX_CORDA   : constant Natural := 3; --Máximo de babuinos en la cuerda
   MAX_CAMINS  : constant Natural := 3; --Veces que realizan el recorrido

   type tcardinal is (NORD, SUD); --Procedencia del babui
   type tidentificador is range 1 .. MAX_BABUINS; --Identificador del babui

   --Herramienta de sincronía
   monitor : Monitor_Babuins (3);

   -- Función que genera números aleatorios
   function getRandom return Duration is
      type randRange is new Integer range 1 .. 5_000;
      package Rand_Int is new Ada.Numerics.Discrete_Random (randRange);
      use Rand_Int;
      gen : Generator;
      res : Float;
   begin
      Reset (gen);
      res := Float (Random (gen)) / 1_000.0;
      return Duration (res);
   end getRandom;

   -- Tasks
   task type babui_nord is
      entry Start (n : in tidentificador);
      entry Join;
   end babui_nord;

   task type babui_sud is
      entry Start (n : in tidentificador);
      entry Join;
   end babui_sud;

   -- Definición arrays de tareas
   type array_nord is
     array (Positive range 1 .. MAX_BABUINS / 2) of babui_nord;
   type array_sud is array (Positive range 1 .. MAX_BABUINS / 2) of babui_sud;

   --BABUINOS NORTE
   task body babui_nord is
      procedencia : tcardinal;
      direccio    : tcardinal;
      id          : tidentificador;
      voltes      : Integer := 0;

      procedure creua is
      begin
         Put_Line
           ("NORD " & tidentificador'Image (id) &
            ": es a la corda i travessa cap al SUD");
         delay getRandom;
      end creua;

      procedure torna (voltes : in Integer) is
      begin
         Put_Line
           ("NORD " & tidentificador'Image (id) & ": ha arribat a la vorera ");
         delay getRandom;
         if (voltes = 3) then
            Put_Line
              ("NORD " & tidentificador'Image (id) & ": Fa la volta " &
               Integer'Image (voltes) & " de 3 i acaba!!!!!!!");
         else
            Put_Line
              ("NORD " & tidentificador'Image (id) & ": Fa la volta " &
               Integer'Image (voltes) & " de 3");
         end if;

      end torna;
   begin
      accept Start (n : in tidentificador) do
         id          := n;
         procedencia := NORD;
         direccio    := SUD;
         Put_Line
           ("HOLA, soc el babui " & tidentificador'Image (id) &
            ", venc del NORD y vaig cap al SUD");
      end Start;
      while voltes < MAX_CAMINS loop
         delay getRandom;

         monitor.northLock;
         --SC
         creua;
         monitor.northUnlock;

         voltes := voltes + 1;
         torna (voltes);
      end loop;

      accept Join do
         Put_Line
           ("Soc el babui NORD" & tidentificador'Image (id) &
            " i ja he acabat. Adeu.");
      end Join;
   end babui_nord;

   --BABUINOS SUD
   task body babui_sud is
      procedencia : tcardinal;
      direccio    : tcardinal;
      id          : tidentificador;
      voltes      : Integer := 0;
      procedure creua is
      begin
         Put_Line
           (ASCII.HT & "SUD " & tidentificador'Image (id) &
            ": es a la corda i travessa cap al NORD");
         delay getRandom;
      end creua;

      procedure torna (voltes : in Integer) is
      begin
         Put_Line
           (ASCII.HT & "SUD " & tidentificador'Image (id) &
            ": ha arribat a la vorera ");
         delay getRandom;
         if (voltes = 3) then
            Put_Line
              (ASCII.HT & "SUD " & tidentificador'Image (id) &
               ": Fa la volta " & Integer'Image (voltes) &
               " de 3 i acaba!!!!!!!");
         else
            Put_Line
              (ASCII.HT & "SUD " & tidentificador'Image (id) &
               ": Fa la volta " & Integer'Image (voltes) & " de 3");
         end if;

      end torna;
   begin
      accept Start (n : in tidentificador) do
         id          := n;
         procedencia := SUD;
         direccio    := NORD;
         Put_Line
           (ASCII.HT & "HOLA, soc el babui " & tidentificador'Image (id) &
            ", venc del SUD y vaig cap al NORT");
      end Start;

      while voltes < MAX_CAMINS loop
         delay getRandom;
         monitor.southLock;
         --SC
         creua;
         monitor.southUnlock;

         voltes := voltes + 1;
         torna (voltes);
      end loop;

      accept Join do
         Put_Line
           (ASCII.HT & "Soc el babui SUD" & tidentificador'Image (id) &
            " i ja he acabat. Adeu.");
      end Join;
   end babui_sud;

   hilos_nord : array_nord;
   hilos_sud  : array_sud;

   --Procesos babuinos sur
   task psud;
   task body psud is
   begin
      for i in 1 .. MAX_BABUINS / 2 loop
         hilos_sud (i).Start (tidentificador (i));
      end loop;

      for i in 1 .. MAX_BABUINS / 2 loop
         hilos_sud (i).Join;
      end loop;
   end psud;

begin
   --Procesos babuinos norte
   for i in 1 .. MAX_BABUINS / 2 loop
      hilos_nord (i).Start (tidentificador (i));
   end loop;

   for i in 1 .. MAX_BABUINS / 2 loop
      hilos_nord (i).Join;
   end loop;
end Main;
