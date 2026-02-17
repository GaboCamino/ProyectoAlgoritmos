unit Arboles;
{$codepage utf8}
interface
uses
    crt;
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
 implementation
end.
