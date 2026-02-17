unit Maneja_arboles;
interface

uses
  crt, Conductores;
type
  t_dato_arbol = record
    clave: string[50];
    pos: integer;
  end;
  t_punt = ^t_nodo_arbol;
  t_nodo_arbol = record
    info: t_dato_arbol;
    sai,sad: t_punt;
  end;

procedure crear_arbol(var raiz: t_punt);
procedure agregar(var raiz: t_punt; x:t_dato_arbol);

function preorden(var raiz: t_punt; buscado:string): t_punt;                     {ordena}
procedure Busqueda(arbol: t_punt; buscado: string; var pos: longint; op:boolean);            {buscado}

procedure Crear_Arboles(var Arch_C: T_Archivo_C; var Arbol_DNI,arbol_Apynom: t_punt);    {procedimiento unificado de creacion de arboles al ejecutar programa}

implementation

procedure crear_arbol(var raiz: t_punt);
begin
     raiz:= nil;
end;

procedure agregar(var raiz: t_punt; x: t_dato_arbol);
begin
  if raiz = nil then
  begin
    new(raiz);
    raiz^.info:= x;
    raiz^.sai:= nil;
    raiz^.sad:= nil;
  end
  else
    if raiz^.info.clave > x.clave then
      agregar(raiz^.sai,x)
    else
      agregar(raiz^.sad,x)
end;
function preorden(var raiz:t_punt; buscado:string): t_punt;
begin
  if (raiz=nil) then
  begin
       preorden:=nil
  end else
    if (raiz^.info.clave = buscado) then
    begin
         preorden:=raiz
    end else
      if raiz^.info.clave > buscado then
      begin
           preorden:=preorden(raiz^.sai,buscado)
           end else
           begin
          preorden:=preorden(raiz^.sad,buscado)
          end;
end;

 procedure Crear_Arboles(var Arch_C: T_Archivo_C; var Arbol_DNI,arbol_Apynom: t_punt);
var
   y,z: t_dato_arbol;
   x1: T_Dato_Conductor;
begin
     crear_arbol(arbol_DNI);
     crear_arbol(arbol_Apynom);
     seek(arch_c,0);
     while filepos(Arch_C) < filesize(Arch_C) do
     begin
          read(Arch_C,x1);
          y.clave:= x1.DNI;
          y.pos:= filepos(Arch_C) - 1;
          z.clave:= x1.DNI;
          z.pos:= filepos(Arch_C) - 1;
          agregar(arbol_DNI,y);
          agregar(arbol_Apynom,z);
     end;
end;


procedure Busqueda(arbol: t_punt; buscado: string; var pos: longint; op:boolean);
var aux: t_punt;
begin
     aux:= preorden(arbol,buscado);
     if aux = nil then
     Begin
        pos:= -1;
        op:=false;
       end else
       begin
            pos:= aux^.info.pos;
            op:=true;
       end;
end;

end.

