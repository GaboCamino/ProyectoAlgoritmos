unit Lista;
interface
uses
    conductores;
type
t_dato_lista=record
      DNI:String[8];
      Apynom:string[80];
      Nacim:string[10];
      Tel:string[11];
      Mail:string[80];
      Score:0..20;
      Hab:char;
      Fecha_hab:string[10];
      Reincidencias:byte;
end;
t_puntero=^t_nodo;
t_nodo=record
    sig:t_puntero;
    info:t_dato_lista;
end;
t_lista=record
    cab,act:t_puntero;
    tam:byte;
end;

procedure crear_lista(var l:t_lista);
procedure iniciar(var l:t_lista);
procedure primero(var l:t_lista);
procedure siguiente(var l:t_lista);
procedure recuperar(l:t_lista;var a:t_Dato_lista);
function lista_Vacia(l:t_lista):boolean;
function lista_llena(l:t_lista):boolean;
function tam_lista(l:t_lista):byte;
function fin_lista(l:t_lista):boolean;

{manejo los contenidos}
procedure agregar(var l:t_lista; a:T_dato_lista);
procedure eliminar(var l:t_lista; buscado:string; var a:t_Dato_lista);
procedure buscar(var l: t_lista; buscado: string; var enc: boolean);

implementation
procedure crear_lista(var l:t_lista);
begin
     l.cab:=nil;
     l.act:=nil;
     l.tam:=0;
end;
procedure iniciar(var l:t_lista);
begin
     fillchar(l,sizeof(l),#0);
end;
procedure primero( var l:t_lista);
begin
     l.act:=l.cab;
end;
procedure siguiente(var l:t_lista);
begin
     l.act:=l.act^.sig;
end;
procedure recuperar(l:t_lista;var a:t_Dato_lista);
begin
     a:=l.act^.info;
end;
function lista_Vacia(l:t_lista):boolean;
begin
     lista_Vacia:=l.tam=0;
end;
function lista_llena(l:t_lista):boolean;
begin
     lista_llena:=getheapstatus.totalfree < sizeof(t_nodo);
end;
function fin_lista(l:t_lista):boolean;
begin
     fin_lista:=l.act=nil;
end;
function tam_lista(l:t_lista):byte;
begin
     tam_lista:=l.tam;
end;

procedure agregar(var l:t_lista; a:T_dato_lista);
var
   nodo,ant:t_puntero;
begin
     new(nodo);
     nodo^.info:=a;
     if (l.cab=nil) or (l.cab^.info.apynom > a.apynom) then
     begin
          nodo^.sig:=l.cab;
          l.cab:=nodo;
     end else
     begin
         ant:=l.cab;
         l.act:=l.cab^.sig;
         while (l.act<>nil) and(l.act^.info.apynom < a.apynom) do
         begin
              ant:=l.act;
              l.act:=l.act^.sig;
         end;
         nodo^.sig:=l.act;
         ant^.sig:=nodo;
     end;
     l.tam:=l.tam+1;
end;

procedure eliminar(var l:t_lista; buscado:string; var a:t_Dato_lista);
var
   nodo,ant:t_puntero;
begin
     if l.cab^.info.apynom =buscado then
     begin
          a:=l.cab^.info;
          nodo:=l.cab;
          l.cab:=nodo^.sig;
          dispose(nodo);
     end else
         ant:=l.cab;
         l.act:=l.cab^.sig;
         while (l.act^.info.apynom <> buscado) do
         begin
              ant:=l.act;
              l.act:=l.act^.sig;
         end;
         ant^.sig:=l.act^.sig;
         dispose(l.act);
l.tam:=l.tam-1;
end;
procedure buscar(var l: t_lista; buscado: string; var enc: boolean); // si busca por otro campo que no sea por el cual está ordenado
var
    a: t_dato_lista;
begin
    primero(l);
    enc := false;
    while (not fin_lista(l)) and (enc=false) do
    begin
        recuperar(l,a);
        if a.apynom=buscado then
        begin
            enc:=true;
        end else
            siguiente(l);
    end;
end;
end.



end.

