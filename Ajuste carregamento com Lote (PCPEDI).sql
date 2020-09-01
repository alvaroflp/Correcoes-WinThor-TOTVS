/*insere lote na PCPEDI com loop - erro lote na 1755 e 1402*/
declare
  cursor c1 is
  
    select codprod, numlote
      from pcestendereco
     where codprod in
           (select codprod from pcprodut where estoqueporlote = 'S');
    
     r1 c1%rowtype;

begin

  open c1;

  loop
    fetch c1
      into r1;
  
    exit when c1%notfound;
  
    update pcpedi
       set numlote = r1.numlote
     where codprod = r1.codprod
       and codprod in
           (select codprod from pcprodut where estoqueporlote = 'S')
           and &tipo in (&valor);
  end loop;

end;
