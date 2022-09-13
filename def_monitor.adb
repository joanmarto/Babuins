package body def_monitor is

   protected body Monitor_Babuins is
      entry northLock when nord < MAX_CORDA and sud = 0 is
      begin
         nord := nord + 1;
         Put_Line
           ("***** A la corda hi ha " & Integer'Image (nord) &
            " amb direcció Sud *****");
      end northLock;

      procedure northUnlock is
      begin
         nord := nord - 1;
         Put_Line
           ("***** A la corda hi ha " & Integer'Image (nord) &
            " amb direcció Sud *****");
      end northUnlock;

      entry southLock when sud < MAX_CORDA and nord = 0 is
      begin
         sud := sud + 1;
         Put_Line
           ("+++++ A la corda hi ha " & Integer'Image (sud) &
            " amb direcció Nord +++++");
      end southLock;

      procedure southUnlock is
      begin
         sud := sud - 1;
         Put_Line
           ("+++++ A la corda hi ha " & Integer'Image (sud) &
            " amb direcció Nord +++++");
      end southUnlock;

   end Monitor_Babuins;

end def_monitor;
