unit Infracciones;
{$codepage utf8}
interface
uses
    crt;
Const
     N=100000;
     Ruta2='Infracciones.dat';
type
   T_Dato_Infraccion = record
      ID:string[8];
      DNI:String[8];
      Descontar:1..20;
      Fecha:string[10];
      Tipo:0..20;
      Apelada:char;
end;

   T_Archivo_I = file of T_Dato_Infraccion;

Procedure AbrirInf(Var Arch_I:T_Archivo_I);
procedure cerrarinf(var arch_inf: T_Archivo_I);

implementation

Procedure AbrirInf(Var Arch_I:T_Archivo_I);
begin
     assign(Arch_I, Ruta2);
     {$i-}
     reset(Arch_I);
     {$i+}
     if (IOResult<>0) then
     begin
          Rewrite(Arch_I);
     end;
end;


procedure cerrarinf(var arch_inf: T_Archivo_I);
begin
     close(arch_inf);    // Cierra
end;
end.
end.


