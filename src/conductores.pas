unit Conductores;
{$codepage utf8}
interface
uses
    crt;
Const
     N=100000;
      Ruta1='Conductores.dat';
type
   T_Dato_Conductor= record
      DNI:String[8];
      Apynom:string[80];
      Nacim:string[10];
      Tel:string[11];
      Mail:string[80];
      Score:integer;
      Hab:char;
      Fecha_hab:string[10];
      Reincidencias:byte;
end;

   T_Archivo_C=File OF T_Dato_Conductor;

Procedure AbrirCond(Var Arch_C:T_Archivo_C);
procedure Anterior_Cond(Var Arch_C:T_Archivo_C);

implementation

Procedure AbrirCond(Var Arch_C:T_Archivo_C);
begin
     assign(arch_C,Ruta1);
     {$i-}
     reset(arch_C);
     {$i+};
     if ioresult <> 0 then
     begin
          rewrite(arch_c);
     end;
end;

procedure Anterior_Cond(var arch_c: t_archivo_c);
begin
     seek(arch_c,filepos(arch_C) - 1);
end;

end.
