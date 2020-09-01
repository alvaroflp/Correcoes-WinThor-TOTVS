/*finalizar OS e insere lote na PCMOVENDPEND com loop - erro de lote na 1755 e 1402*/
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
  
    update pcmovendpend
       set posicao = 'C', numlote = r1.numlote
     where codprod = r1.codprod
      /* and codprod in
           (select codprod from pcprodut where estoqueporlote = 'S')*/ --finalizava somente OS dos produtos. 
           and &tipo in (&valor); 
  end loop;

end;
