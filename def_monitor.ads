with Ada.Text_IO; use Ada.Text_IO;

package def_monitor is
   protected type Monitor_Babuins (Inicial : Natural) is
      entry northLock;
      procedure northUnlock;
      entry southLock;
      procedure southUnlock;
   private
      --Número de babuins a la corda
      nord      : Integer := 0;
      sud       : Integer := 0;

      --Capacitat corda
      MAX_CORDA : Natural := Inicial;
   end Monitor_Babuins;

end def_monitor;
