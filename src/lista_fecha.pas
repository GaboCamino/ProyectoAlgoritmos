unit Lista_fecha;

interface

uses crt,infracciones;
const
  N=10000;
type

 T_punt_F=^T_nodo;

 T_nodo=record
   info:T_Dato_Infraccion;
   sig:T_punt_F;
 end;

 T_lista=record
   cab,act:T_punt_F;
   tam:0..N;
 end;

 Procedure CrearLista(var l:T_lista);
 Procedure siguiente(var l:T_lista);
 Procedure Crear_Lista_Fecha(var l:T_lista;var Arch_I:T_Archivo_I);
 Procedure Agregar_A_Lista(var l:T_lista;x:T_Dato_Infraccion);
// procedure buscar(var l: t_lista; buscado: string; var enc: boolean);
 procedure primero( var l:t_lista);
 procedure recuperar(l:t_lista;var x:T_Dato_Infraccion);
 function fin_lista(l:t_lista):boolean;
implementation

Procedure CrearLista(var l:T_lista);
begin
     l.tam:=0;
     l.cab:=nil;
end;
Procedure siguiente(var l:T_lista);
begin
     l.act:=l.act^.sig;
end;
Procedure Crear_Lista_Fecha(var l:T_lista;var Arch_I:T_Archivo_I);
var
  x:T_Dato_Infraccion;
    begin
         CrearLista(l);
         seek(Arch_I,0);
         while filepos(Arch_I) < filesize(Arch_I) do
               begin
                    read(Arch_I,x);
                    Agregar_A_Lista(l,x);
                    end;
         end;
Procedure Agregar_A_Lista(var l:T_lista;x:T_Dato_Infraccion);
var nodo,ant:T_punt_F;
begin
     new(nodo);
     nodo^.info:=x;
     if (l.cab=nil) or (l.cab^.info.Fecha > x.Fecha) then
     begin
          nodo^.sig:=l.cab;
          l.cab:=nodo;
     end else
     begin
         ant:=l.cab;
         l.act:=l.cab^.sig;
         while (l.act<>nil) and(l.act^.info.Fecha < x.Fecha) do
         begin
              ant:=l.act;
              l.act:=l.act^.sig;
         end;
         nodo^.sig:=l.act;
         ant^.sig:=nodo;
     end;
     l.tam:=l.tam+1;
end;

procedure primero( var l:t_lista);
begin
     l.act:=l.cab;
end;
procedure recuperar(l:t_lista;var x:T_Dato_Infraccion);
begin
     x:=l.act^.info;
end;
function fin_lista(l:t_lista):boolean;
begin
     fin_lista:=l.act=nil;
end;
end.

