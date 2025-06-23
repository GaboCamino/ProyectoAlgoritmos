unit Infracciones;
{$codepage utf8}
interface
uses
    crt;
Const
     N=100000;
     Ruta2='C:\Users\gabit\OneDrive\Escritorio\ProyectoFinal\Infracciones.dat'; {gabo}
      {Ruta2='C:\Users\User\Desktop\score2\infracciones.dat';}                         {nehue}
type
   T_Dato_Infraccion = record
      DNI:String[8];
      Descontar:1..20;
      Fecha:string[10];
      Tipo:1..27;
      apelada:char;
end;

   T_Archivo_I = file of T_Dato_Infraccion;

Procedure AbrirInf(Var Arch_I:T_Archivo_I);
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

end.


