--DORNEANU ALINA-MIHAELA, 241
-----------------------------------------------------


--6.Defini?i un subprogram stocat care sã utilizeze un tip de colec?ie studiat. Apela?i subprogramul.

--Pentru a determina cat de reusita a fost fiecare expozitie, ne dorim sa stim cate tablouri au fost
--expuse in fiecare expozitie si cate dintre acestea au fost vandute. Acest lucru se va realiza prin
--determinarea unui procent care reprezinta cat % din tablourile expuse au fost vandute in cadrul 
--fiecarei expozitii. Retineti intr-un nou tabel al expozitiilor, pe langa informatiile anterioare,
--cate tablouri au fost expuse, cate au fost vandute si care este acel procent.


create table exhibition_ado as
select * from exhibition;

alter table exhibition_ado
add nr_tablouri number(2);

alter table exhibition_ado
add nr_tablouri_vandute number(2);

alter table exhibition_ado
add raport_tab number(5,2);

select * from participate;
select * from exhibition_ado;

--1: 2001: 9p, 4v
--4: building: 10p, 2v
--5: american: 12p, 5v
--3: shape: 8p, 4v
--2: in the: 14p, 7v

create or replace procedure proc_ex6
    
    is
    type tabells is record(titlu exhibition.exhibition_title%type,
                      nrTab number(2), 
                      nrTabV number (2),
                      rap number(5,2));
    type vector_tabl is varray(20) of tabells;
    
    t vector_tabl := vector_tabl();
    nr number(2);
    r number(5,2);
begin
    select e.exhibition_title, count(*), 0, 0
    bulk collect into t
    from exhibition e, participate p
    where p.exhibition_id = e.exhibition_id
    group by e.exhibition_title;

    for i in t.first..t.last
    loop
        select count(b.exhibition_id)
        into nr
        from exhibition e, buying b
        where e.exhibition_id = b.exhibition_id
        and e.exhibition_title = t(i).titlu
        group by e.exhibition_title;
        
        t(i).nrTabV := nr;
        if t(i).nrTab != 0
        then
            r := t(i).nrTabV * 100 / t(i).nrTab;
            t(i).rap := r;
        end if;
    end loop;
    

    for i in 1..t.last
    loop
        dbms_output.put_line('Titlu: ' || t(i).titlu);
        dbms_output.put_line('Nr de tablouri ' || ' ' || t(i).nrTab);
        dbms_output.put_line('Nr de tablouri vandute ' || ' ' || t(i).nrTabV);
        dbms_output.put_line('Au fost vandute ' || t(i).rap || '% din tablourile expuse.');

        dbms_output.new_line();
        
        update exhibition_ado
        set nr_tablouri = t(i).nrTab
        where exhibition_title = t(i).titlu;
        
        update exhibition_ado
        set nr_tablouri_vandute = t(i).nrTabV
        where exhibition_title = t(i).titlu;
        
        update exhibition_ado
        set raport_tab = t(i).rap
        where exhibition_title = t(i).titlu;


    end loop;

end proc_ex6;
/
execute proc_ex6;

select * from exhibition_ado;

-----------------------------------------------

--7. Defini?i un subprogram stocat care sã utilizeze un tip de cursor studiat. Apela?i subprogramul.
--Se doreste o statistica asupra artistilor. Pentru fiecare artist, afisati 
--in ce curente artistice a creat si care sunt cele mai scumpe 3 tablouri 
--ale sale.Tablourile trebuie afisate cu numar de ordine, in ordinea 
--descrescatoarea a preturilor lor.In cazul in care un artist nu figureaza 
--cu cel putin 3 tablouri, sau nu are inregistrat nici macar un tablou, 
--mentionati acest lucru. Pentru artistii care figureaza cu cel putin 3 
--tablouri afisati si cat valoreaza in total aceste 3 tablouri.

create or replace procedure proc_ex7
    is
    type tabel is record(titlu painting.painting_title%type,
                        pret buying.price%type);
    type tabel_tablouri is table of tabel
    index by pls_integer;
    
    
    type tabel_c is record(curent art_movement.movement_name%type);
    type tabel_curente is table of tabel_c
    index by pls_integer;
    

    cursor c is
    select a.a_last_name nume_artist, a_first_name prenume_artist
    from artist a;

    nrCurente number(3);
    nrTablouri number(3);
    sumaTablouri number(6,2);
    
    tablouri tabel_tablouri;
    curente tabel_curente;
    nr number(4);

begin
    
    for k in c 
    loop
        dbms_output.new_line();
        dbms_output.put_line('-------------------------------');
        dbms_output.put_line(k.prenume_artist || ' ' || k.nume_artist || ': ');
        nrTablouri := 0;
        sumaTablouri := 0;
        
        select p.painting_title, b.price
        bulk collect into tablouri
        from (select pa.painting_title, pa.painting_id, b.price, pa.artist_id
              from painting pa, buying b
              where pa.painting_id = b.painting_id 
              order by b.price desc) p, artist a, buying b
        where lower(a.a_last_name) = lower(k.nume_artist) and p.artist_id = a.artist_id and b.painting_id = p.painting_id and rownum <= 3
        order by b.price desc;
        
        select am.movement_name
        bulk collect into curente
        from belongs b, artist a, art_movement am
        where lower(k.nume_artist) = lower(a.a_last_name) and b.artist_id = a.artist_id
        and am.movement_id = b.movement_id;
        
        
        nrTablouri := tablouri.count();
        if nrTablouri = 0 then
            dbms_output.put_line('Acest artist nu are inregistrat niciun tablou!');
        else
            if nrTablouri < 3
                then
                    dbms_output.put_line('Acest artist are mai putin de 3 tablouri inregistrate: ');
                else
                    dbms_output.put_line('Top cele mai scumpe tablouri: ');
                    
            end if;
            for i in 1..nrTablouri
            loop
                dbms_output.put_line(i || ': ' || tablouri(i).titlu  || ' ' || tablouri(i).pret || ' mil. $');
                sumaTablouri := sumaTablouri + tablouri(i).pret;
            end loop;
            if nrTablouri >= 3
                then
                    
                    dbms_output.put_line('Suma: ' || sumaTablouri || ' mil. $');
                    dbms_output.new_line();
            end if;
        end if;
        
        dbms_output.new_line();
        
        nrCurente := curente.count();
        if nrCurente = 0 then
            dbms_output.put_line('Acest artist nu a activat in niciun curent!');
        else
            dbms_output.put_line('Miscari artistice:');
            for i in 1..nrCurente
            loop
                dbms_output.put_line(curente(i).curent);
            end loop;
            dbms_output.new_line();
            
        end if;
        
    end loop;

end proc_ex7;
/

execute proc_ex7;
/


-----------------------------------------------------


--8.Defini?i un subprogram stocat de tip func?ie care sã utilizeze 3 dintre tabelele definite. 

--Se da numele unui vanzator si numele unei expozitii. Dorim sa aflam cat comision
--a luat casa de vanzari prin care a fost vandut un tablou de catre acel vanzator 
--in cadrul acelei expozitii. Atentie! Unele tablouri au fost vandute prin 
--achizitii private, insemnand ca nu este mentionata casa de vanzari, iar altele au 
--fost vandute de mai multe ori.


create or replace function function_ex8
     (nume_seller seller.s_last_name%type default 'Gioconda',
     expozitie exhibition.exhibition_title%type default 'Shape Lab') 
return number is
     comision auction_house.commission_pct%type; 
     idSeller number;
begin
     select s.seller_id
     into idSeller
     from seller s
     where lower(s.s_last_name) = lower(nume_seller);
     
     select a.commission_pct
     into comision
     from buying b, auction_house a, exhibition e
     where b.seller_id = idSeller and b.exhibition_id = e.exhibition_id
     and lower(e.exhibition_title) = lower(expozitie)
     and b.house_id = a.house_id;
     return comision;
 
     exception
     WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20000,
     'Nu exista casa de vanzari.');
     
     WHEN TOO_MANY_ROWS THEN
     RAISE_APPLICATION_ERROR(-20001,
     'Exista prea multe case de vanzari.');
     
     WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
     
end function_ex8; 
/

begin
     dbms_output.put_line('Numarul este '|| function_ex8('Altmann', 'Building Collections'));
end;
/


begin
     dbms_output.put_line('Numarul este '|| function_ex8('Altmann', 'In the Making'));
end;
/

begin
     dbms_output.put_line('Numarul este '|| function_ex8('Altmann', 'Shape Lab'));
end;
/

------------------------------------------
--9. 
--Defini?i un subprogram stocat de tip procedurã care sã utilizeze 5 dintre 
--tabelele definite. Trata?i toate excep?iile care pot apãrea. Apela?i subprogramul astfel 
--încât sã eviden?ia?i toate cazurile tratate. 

--Pentru a incuraja achizitiile, se organizeaza o tombola, iar unul dintre cumparatori va primi
--un premiu surpriza. Primul cumparator (in ordine alfabetica) care locuieste in USA si care a
--cumparat cel putin un tablou mai vechi de 1950 prin intermediul acelei case de vanzari data 
--ca parametru, este ales castigator. Afisati acel nume. Daca niciun cumparator nu intruneste
--aceste conditii, premiul nu va fi acordat.


create or replace PROCEDURE proc_ex9  
    (casa in auction_house.house_name%type, 
    nume out buyer.b_last_name%type) 
    IS

BEGIN

    select bb.b_last_name
    into nume
    from (select b.b_last_name, b.buyer_id
        from buyer b, address a, buying bu, painting p, auction_house ah
    where a.country = 'USA' and p.painting_year < 1950 
    and b.buyer_id = bu.buyer_id and a.address_id = b.address_id
    and p.painting_id = bu.painting_id and ah.house_id = bu.house_id
    and ah.house_name = casa
    order by b.b_last_name) p, buyer bb
    where bb.buyer_id = p.buyer_id and rownum < 2
    order by p.b_last_name;
    
    exception
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20000,
    'Nu exista inregistrari care sa respecte cerintele.');
     
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');

     
END proc_ex9; 
/
DECLARE
    acestNume buyer.b_last_name%type;
    
BEGIN
 proc_ex9('Sotheby', acestNume);
 dbms_output.put_line('Castigatorul este ' || acestNume);
END;
/


DECLARE
    acestNume buyer.b_last_name%type;
    
BEGIN
 proc_ex9('Christie', acestNume);
 dbms_output.put_line('Castigatorul este ' || acestNume);
END;
/


------------------------------------------------------------
--10
--Defini?i un trigger de tip LMD la nivel de comandã. Declan?a?i trigger-ul.

--De regula, expozitiile se tin doar vineri, sambata si duminica, incepand cu orele 17:00.
--In acest interval, nu sunt posibile modificari aduse acestui tabel, in schimb, in restul 
--timpului, modificarile sunt permise. Declarati un trigger care sa interzica adaugarea, 
--stergerea sau inregistrarea datelor in tabelul exhibition in acest interval orar.


CREATE OR REPLACE TRIGGER trig_exhibition
    BEFORE INSERT OR DELETE OR UPDATE on exhibition
BEGIN
    IF (TO_CHAR(SYSDATE,'D') BETWEEN 5 and 7)
    AND (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 AND 17)
    
    THEN
    IF INSERTING THEN
    RAISE_APPLICATION_ERROR(-20001,'Inserarea in tabelul exhibition
    este permisa inafara orelor de expozitie!');
    
    ELSIF DELETING THEN
    RAISE_APPLICATION_ERROR(-20002,'Stergerea din tabelul exhibition
    este permisa inafara orelor de expozitie!');
    
    ELSE
    RAISE_APPLICATION_ERROR(-20003,'Actualizarile in tabelul exhibition
    sunt permise inafara orelor de expozitie!');
    END IF;

END IF;
END;
/

insert into exhibition(exhibition_id, exhibition_title, exhibition_date, exhibition_city) values
(7, 'Sun is up', to_date('04-10-2020', 'dd-mm-yyyy'), 'Los Angeles');

delete from exhibition
where exhibition_id = 6;

update exhibition
set exhibition_title = 'Sun'
where exhibition_id = 6;

rollback;
-------------------------------------------
--11. Defini?i un trigger de tip LMD la nivel de linie. Declan?a?i trigger-ul.
--In momentul in care se face un update pentru pretul cu care a fost vandut un anumit tablou,
--pentru a evita posibile greseli, vom folosi un trigger care sa nu permita ca pretul cel mai mic
--sa devina mai mare decat media preturilor deja existente, pretul cel mai mare sa nu devina
--mai mic decat media preturilor si totodata, pretul cel mai mare sa nu devina mai mare decat
--suma tuturor preturilor din baza de date.


create or replace package pachet_trig
is
    minp buying.price%type;
    avp buying.price%type;
    maxp buying.price%type;
    sump buying.price%type;
end pachet_trig;
/

create or replace trigger trigg11_first
before update of price on buying
begin
    select min(b.price), max(b.price), avg(b.price), sum(b.price)
    into pachet_trig.minp, pachet_trig.maxp, pachet_trig.avp, pachet_trig.sump
    from buying b;

end;
/

create or replace trigger trigg11_plus
before update of price on buying
for each row
begin    
    
    
    if(:OLD.price = pachet_trig.minp) and (:NEW.price > pachet_trig.avp)
    then
    RAISE_APPLICATION_ERROR(-20001, 'Pretul minim nu poate fi mai mare decat media preturilor!');
    
    elsif (:OLD.price = pachet_trig.maxp) and (:NEW.price < pachet_trig.avp)
    then
    RAISE_APPLICATION_ERROR(-20001, 'Pretul maxim nu poate fi mai mic decat media preturilor!');
    
    elsif (:OLD.price = pachet_trig.maxp) and (:NEW.price > pachet_trig.sump)
    then
    RAISE_APPLICATION_ERROR(-20001, 'Pretul maxim nu poate fi mai mare decat suma celorlalte tablouri!');
    
    end if;
end;
/

begin
    dbms_output.put_line(pachet_trig.minp);
    dbms_output.put_line(pachet_trig.maxp);
    dbms_output.put_line(pachet_trig.avp);
    dbms_output.put_line(pachet_trig.sump);
end;
/

update buying
set price = 190
where price = (select min(price) from buying);

update buying
set price = 6000
where price = (select max(price) from buying);

update buying
set price = 180
where price = (select max(price) from buying);

-----------------------------------------------------

--12. Defini?i un trigger de tip LDD. Declan?a?i trigger-ul
--Ne dorim un trigger care sa se declanseze in momentul efectuarii de comenzi LDD asupra
--obiectelor din schema personalã. Vrem sa retinem numele bazei de date, userul, evenimentul
--efectuat, tipul si numele obiectului referit.


CREATE TABLE a_user
    (nume_baza VARCHAR2(50),
    user_logat VARCHAR2(40),
    eveniment VARCHAR2(30),
    tip_obiect_referit VARCHAR2(30),
    nume_obiect_referit VARCHAR2(30),
    data TIMESTAMP(3));
    
CREATE OR REPLACE TRIGGER a_schema
    AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    INSERT INTO a_user
    VALUES (SYS.DATABASE_NAME, SYS.LOGIN_USER,
    SYS.SYSEVENT, SYS.DICTIONARY_OBJ_TYPE,
    SYS.DICTIONARY_OBJ_NAME, SYSTIMESTAMP(3));
END;
/

CREATE TABLE tabel (coloana_1 number(2));
ALTER TABLE tabel ADD (coloana_2 number(2));

INSERT INTO tabel VALUES (1,2);
CREATE INDEX ind_tabel ON tabel(coloana_1);

SELECT * FROM a_user;

SELECT * FROM tabel;


-----------------------------------------------------


--13.  Defini?i un pachet care sã con?inã toate obiectele definite în cadrul proiectului:
--Ne dorim un pachet care sa contina toate obiectele create anterior.


CREATE OR REPLACE PACKAGE pachet_gallery AS
    
    procedure proc_ex6;
    procedure proc_ex7;
    
    PROCEDURE proc_ex9  
    (casa in auction_house.house_name%type, 
    nume out buyer.b_last_name%type);
    
    function function_ex8
     (nume_seller seller.s_last_name%type default 'Gioconda',
     expozitie exhibition.exhibition_title%type default 'Shape Lab') 
    return number;
    
END pachet_gallery;
/
CREATE OR REPLACE PACKAGE BODY pachet_gallery AS
 
function function_ex8
     (nume_seller seller.s_last_name%type default 'Gioconda',
     expozitie exhibition.exhibition_title%type default 'Shape Lab') 
return number is
     comision auction_house.commission_pct%type; 
     idSeller number;

begin
     select s.seller_id
     into idSeller
     from seller s
     where lower(s.s_last_name) = lower(nume_seller);

     select a.commission_pct
     into comision
     from buying b, auction_house a, exhibition e
     where b.seller_id = idSeller and b.exhibition_id = e.exhibition_id
     and lower(e.exhibition_title) = lower(expozitie)
     and b.house_id = a.house_id;
     return comision;
 
     exception
     WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20000,
     'Nu exista casa de vanzari.');
     
     WHEN TOO_MANY_ROWS THEN
     RAISE_APPLICATION_ERROR(-20001,
     'Exista prea multe case de vanzari.');
     
     WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
     
end function_ex8; 

 
    procedure proc_ex6
    
    is
    type tabells is record(titlu exhibition.exhibition_title%type,
                      nrTab number(2), 
                      nrTabV number (2),
                      rap number(5,2));
    type vector_tabl is varray(20) of tabells;
    
    t vector_tabl := vector_tabl();
    nr number(2);
    r number(5,2);
begin
    select e.exhibition_title, count(*), 0, 0
    bulk collect into t
    from exhibition e, participate p
    where p.exhibition_id = e.exhibition_id
    group by e.exhibition_title;

    for i in t.first..t.last
    loop
        select count(b.exhibition_id)
        into nr
        from exhibition e, buying b
        where e.exhibition_id = b.exhibition_id
        and e.exhibition_title = t(i).titlu
        group by e.exhibition_title;
        
        t(i).nrTabV := nr;
        r := t(i).nrTabV * 100 / t(i).nrTab;
        t(i).rap := r;
    end loop;
    

    for i in 1..t.last
    loop
        dbms_output.put_line('Titlu: ' || t(i).titlu);
        dbms_output.put_line('Nr de tablouri ' || ' ' || t(i).nrTab);
        dbms_output.put_line('Nr de tablouri vandute ' || ' ' || t(i).nrTabV);
        dbms_output.put_line('Au fost vandute ' || t(i).rap || '% din tablourile expuse.');

        dbms_output.new_line();
        
        update exhibition_ado
        set nr_tablouri = t(i).nrTab
        where exhibition_title = t(i).titlu;
        
        update exhibition_ado
        set nr_tablouri_vandute = t(i).nrTabV
        where exhibition_title = t(i).titlu;
        
        update exhibition_ado
        set raport_tab = t(i).rap
        where exhibition_title = t(i).titlu;


    end loop;

end proc_ex6;

    procedure proc_ex7
    is
    type tabel is record(titlu painting.painting_title%type,
                        pret buying.price%type);
    type tabel_tablouri is table of tabel
    index by pls_integer;
    
    
    type tabel_c is record(curent art_movement.movement_name%type);
    type tabel_curente is table of tabel_c
    index by pls_integer;
    

    cursor c is
    select a.a_last_name nume_artist, a_first_name prenume_artist
    from artist a;

    nrCurente number(3);
    nrTablouri number(3);
    sumaTablouri number(6,2);
    
    tablouri tabel_tablouri;
    curente tabel_curente;
    nr number(4);

begin
    
    for k in c 
    loop
        dbms_output.new_line();
        dbms_output.put_line('-------------------------------');
        dbms_output.put_line(k.prenume_artist || ' ' || k.nume_artist || ': ');
        nrTablouri := 0;
        sumaTablouri := 0;
        
        select p.painting_title, b.price
        bulk collect into tablouri
        from (select pa.painting_title, pa.painting_id, b.price, pa.artist_id
              from painting pa, buying b
              where pa.painting_id = b.painting_id 
              order by b.price desc) p, artist a, buying b
        where lower(a.a_last_name) = lower(k.nume_artist) and p.artist_id = a.artist_id and b.painting_id = p.painting_id and rownum <= 3
        order by b.price desc;
        
        select am.movement_name
        bulk collect into curente
        from belongs b, artist a, art_movement am
        where lower(k.nume_artist) = lower(a.a_last_name) and b.artist_id = a.artist_id
        and am.movement_id = b.movement_id;
        
        
        nrTablouri := tablouri.count();
        if nrTablouri = 0 then
            dbms_output.put_line('Acest artist nu are inregistrat niciun tablou!');
        else
            if nrTablouri < 3
                then
                    dbms_output.put_line('Acest artist are mai putin de 3 tablouri inregistrate: ');
                else
                    dbms_output.put_line('Top cele mai scumpe tablouri: ');
                    
            end if;
            for i in 1..nrTablouri
            loop
                dbms_output.put_line(i || ': ' || tablouri(i).titlu  || ' ' || tablouri(i).pret || ' mil. $');
                sumaTablouri := sumaTablouri + tablouri(i).pret;
            end loop;
            if nrTablouri >= 3
                then
                    
                    dbms_output.put_line('Suma: ' || sumaTablouri || ' mil. $');
                    dbms_output.new_line();
            end if;
        end if;
        
        dbms_output.new_line();
        
        nrCurente := curente.count();
        if nrCurente = 0 then
            dbms_output.put_line('Acest artist nu a activat in niciun curent!');
        else
            dbms_output.put_line('Miscari artistice:');
            for i in 1..nrCurente
            loop
                dbms_output.put_line(curente(i).curent);
            end loop;
            dbms_output.new_line();
            
        end if;
        
    end loop;

end proc_ex7;


PROCEDURE proc_ex9  
    (casa in auction_house.house_name%type, 
    nume out buyer.b_last_name%type) 
    IS

BEGIN

    select bb.b_last_name
    into nume
    from (select b.b_last_name, b.buyer_id
        from buyer b, address a, buying bu, painting p, auction_house ah
    where a.country = 'USA' and p.painting_year < 1950 
    and b.buyer_id = bu.buyer_id and a.address_id = b.address_id
    and p.painting_id = bu.painting_id and ah.house_id = bu.house_id
    and ah.house_name = casa
    order by b.b_last_name) p, buyer bb
    where bb.buyer_id = p.buyer_id and rownum < 2
    order by p.b_last_name;
    
    exception
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20000,
    'Nu exista inregistrari care sa respecte cerintele.');
     
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');

     
END proc_ex9; 

END pachet_gallery;
/ 

DECLARE
acestNume buyer.b_last_name%type;
BEGIN
 pachet_gallery.proc_ex6();
 pachet_gallery.proc_ex7();
 dbms_output.put_line('Comisionul este '|| pachet_gallery.function_ex8('Altmann', 'Building Collections'));
 pachet_gallery.proc_ex9('Sotheby', acestNume);
  dbms_output.put_line('Castigatorul este ' || acestNume);
END;
/ 



--------------------------------------------------------------
--14
--Ne dorim sa afisam pentru fiecare artist, care sunt tablourile cu care acesta figureaza, 
--folosind un tip de date complex.Pe de alta parte, vrem sa afisam pentru fiecare vanzator,
--ce tablouri a vandut si carui artist ii apartine fiecare dintre tablourile lui, utilizand 
--tipul de date complex de mai devreme. Totodata, vrem sa stim si care este cel mai scump 
--tablou vandut de catre fiecare vanzator.Pentru a rezolva exercitiul, vom folosi un pachet 
--in care vom avea doua tipuri de date complexe. Un vector de vectori pentru a retine 
--tablourile artistilor si un vector de tablouri imbricate pentru a retine tablourile vandute 
--de vanzatori.



create or replace package pachet_date_complexe as
    type vec_artists is varray(1000) of artist.artist_id%type;
    my_vec_a vec_artists;
  
    type vec_paintings is varray(1000) of painting.painting_id%type;
    type tabl is table of vec_paintings; --tablou imbricat de vectori
    my_tab tabl := tabl();
    my_vec_p vec_paintings;
  
    type type_tab_seller is table of seller.seller_id%type;
    tab_seller type_tab_seller;
  
    type tab_e is table of vec_paintings;
    my_tab_e tab_e := tab_e();
    my_vec_pp vec_paintings;
  
    procedure afisare_tablouri_artist;
    procedure afisare_tablouri_seller;
    procedure afisare_tablouri_seller_artist;
  
    procedure afisare_nume_artist(idTablou IN painting.painting_id%TYPE,
    numeArtist OUT artist.a_last_name%type);
 
    procedure celMaiScump(idSeller IN seller.seller_id%TYPE,
    titluTab OUT painting.painting_title%type);

end pachet_date_complexe;
/



create or replace package body pachet_date_complexe as

procedure afisare_tablouri_artist is
    n artist.a_last_name%type;
    n1 artist.a_last_name%type;
    idul artist.artist_id%type;
    titlul painting.painting_title%type;
    titlul1 painting.painting_title%type;
    idulTablou painting.painting_id%type;

    cursor c1 is
    select a.a_last_name numeArtist, a.artist_id idArtist
    from artist a;
  
    cursor c is
    select p.painting_title numeTablou, p.painting_id idTablou
    from painting p;

begin

    for i in my_tab.first..my_tab.last loop
    dbms_output.new_line();
    open c1;
    loop
        fetch c1 into n1, idul;
        EXIT WHEN c1%NOTFOUND;
     
        --daca idul corespunde cu id-ul de la indicele resp din vectorul de artisti
        if idul = my_vec_a(i)
        then n := n1; --pun numele
        end if;
    end loop;
    close c1;
    
    --iterez prin tablouri
    dbms_output.put_line('ARTIST ' || n);
    if my_tab(i).count = 0 then
      dbms_output.put_line('NU SUNT TABLOURI');
    else
      dbms_output.put_line('LISTA TABLOURI');
      for j in my_tab(i).first..my_tab(i).last 
      loop
        open c;
        loop
            fetch c into titlul1, idulTablou;
            EXIT WHEN c%NOTFOUND;

            if idulTablou = my_tab(i)(j) --pentru a lua titlul tabloului
            then titlul := titlul1;
            end if;
        end loop;
        close c;
      
        dbms_output.put_line(titlul);
      end loop;
    end if;
  end loop;

end afisare_tablouri_artist;

procedure afisare_tablouri_seller is

    n seller.s_last_name%type;
    n1 seller.s_last_name%type;
    idul seller.seller_id%type;
    titlul painting.painting_title%type;
    titlul1 painting.painting_title%type;
    idulTablou painting.painting_id%type;

    cursor c2 is
    select s.s_last_name numeSeller, s.seller_id idSeller
    from seller s;
  
    cursor c is
    select p.painting_title numeTablou, p.painting_id idTablou
    from painting p;
  
begin
    for i in my_tab_e.first..my_tab_e.last 
    loop
        dbms_output.new_line();
        
        open c2;
        loop
            fetch c2 into n1, idul;
            EXIT WHEN c2%NOTFOUND;
        
            if idul = tab_seller(i)
            then n := n1;
            end if;
        end loop;
        close c2;
        
        dbms_output.put_line('Seller ' || n);
        if my_tab_e(i).count = 0 then
          dbms_output.put_line('NU SUNT TABLOURI');
        else
            dbms_output.put_line('LISTA TABLOURI');
            for j in my_tab_e(i).first..my_tab_e(i).last
            loop
                open c;
                loop
                    fetch c into titlul1, idulTablou;
                    EXIT WHEN c%NOTFOUND;
        
                    if idulTablou = my_tab_e(i)(j)
                    then titlul := titlul1;
                    end if;
                end loop;
                close c;
              
                dbms_output.put_line(titlul);
            end loop;
        end if;
    end loop;

end afisare_tablouri_seller;

procedure afisare_nume_artist(idTablou IN painting.painting_id%TYPE,
     numeArtist OUT artist.a_last_name%type) is
 
    n artist.a_last_name%type;
    idul artist.artist_id%type;
    idArtist artist.artist_id%type;
    iterator number;

    cursor c1 is
    select a.a_last_name numeArtist, a.artist_id idArtist
    from artist a;
  
begin
    for i in my_tab.first..my_tab.last --iterez printre tablourile artistilor
    loop
        if my_tab(i).count != 0 --daca are cel putin un tablou
        then
            for j in my_tab(i).first..my_tab(i).last 
            loop
                if idTablou = my_tab(i)(j) --iau id-ul si retin pozitia
                    then iterator := i;
                end if;
            end loop;
         end if;
    end loop;
    
    idArtist := my_vec_a(iterator); --caut id-ul artistului
  
    open c1;
    loop
        fetch c1 into n, idul;
        EXIT WHEN c1%NOTFOUND;
     
        if idul = idArtist
        then numeArtist := n; --ii iau numele
        end if;
    end loop;
    close c1;

end afisare_nume_artist;


procedure celMaiScump(idSeller IN seller.seller_id%TYPE,
 titluTab OUT painting.painting_title%type) is
 
    idul seller.seller_id%type;
    idTablou painting.painting_id%type;
    idulTablou painting.painting_id%type;
    titlul1 painting.painting_title%type;
    iterator number;
    iterator1 number;

    cursor c2 is
    select s.s_last_name numeSeller, s.seller_id idSeller
    from seller s;
  
    cursor c is
    select p.painting_title numeTablou, p.painting_id idTablou
    from painting p;
  
begin

    select b.painting_id into idTablou
    from buying b
    where b.seller_id = idSeller
    and b.price = (select max(b.price)
                    from buying b
                    where b.seller_id = idSeller);

    for i in my_tab_e.first..my_tab_e.last 
    loop

        if idSeller = tab_seller(i) and my_tab(i).count != 0
        then
            open c;
            loop
                fetch c into titlul1, idulTablou;
                EXIT WHEN c%NOTFOUND;
    
                if idulTablou = idTablou
                then titluTab := titlul1; --ii iau titlul
                end if;
            end loop;
        end if;
    end loop;
 
end celMaiScump;

procedure afisare_tablouri_seller_artist is

    n seller.s_last_name%type;
    n1 seller.s_last_name%type;
    idul seller.seller_id%type;
    idulSellerului seller.seller_id%type;
    titlul painting.painting_title%type;
    titlul1 painting.painting_title%type;
    titlulScump painting.painting_title%type;
    idulTablou painting.painting_id%type;
    idulArtist artist.a_last_name%type;
    artistul artist.artist_id%type;
    numeArtist artist.a_last_name%type;
    numele artist.a_last_name%type;
  
    cursor c is
    select p.painting_title numeTablou, p.painting_id idTablou
    from painting p;
  
    cursor c2 is
    select s.s_last_name numeSeller, s.seller_id idSeller
    from seller s;
  
begin

for i in my_tab_e.first..my_tab_e.last loop
    dbms_output.new_line();
    open c2;
    loop
        fetch c2 into n1, idul;
        EXIT WHEN c2%NOTFOUND;
     
        if idul = tab_seller(i)
        then n := n1;
        end if;
    end loop;
    close c2;
    
    dbms_output.new_line();
    dbms_output.put_line('----------------------------');
    dbms_output.put_line('Seller ' || n);
    
    if my_tab_e(i).count = 0 then
        dbms_output.put_line('NU SUNT TABLOURI');
    else
      
        dbms_output.put_line('LISTA TABLOURI');
        for j in my_tab_e(i).first..my_tab_e(i).last
        loop
            open c;
            loop
                fetch c into titlul1, idulTablou;
                EXIT WHEN c%NOTFOUND;
    
                if idulTablou = my_tab_e(i)(j)
                then 
                    titlul := titlul1;
                    numele := '';
                    afisare_nume_artist(idulTablou, numele);
                end if;
            end loop;
            close c;

            dbms_output.put_line(titlul || ' - ' || numele);
        end loop;
        
        titlulScump := '';
        celMaiScump(tab_seller(i), titlulScump);
        dbms_output.new_line();
        dbms_output.put_line('Cel mai scump tablou vandut: ' || titlulScump);
    end if;
end loop;

end afisare_tablouri_seller_artist;

begin
    
    select a.artist_id bulk collect into my_vec_a
    from artist a;
  
    for i in my_vec_a.first..my_vec_a.last 
    loop
        select p.painting_id bulk collect into my_vec_p
        from painting p
        where p.artist_id = my_vec_a(i);
        
        my_tab.extend; --tablourile artistilor
        my_tab(i) := my_vec_p;
    end loop;

  --
    select s.seller_id bulk collect into tab_seller
    from seller s;
  
    for i in tab_seller.first..tab_seller.last 
    loop
        select distinct b.painting_id bulk collect into my_vec_pp
        from buying b
        where b.seller_id = tab_seller(i);
        
        my_tab_e.extend;
        my_tab_e(i) := my_vec_pp;
    end loop;
  

end pachet_date_complexe;
/

execute pachet_date_complexe.afisare_tablouri_artist;

execute pachet_date_complexe.afisare_tablouri_seller;

execute pachet_date_complexe.afisare_tablouri_seller_artist;

declare
    nume artist.a_last_name%type;
begin

    pachet_date_complexe.afisare_nume_artist(22, nume);
    dbms_output.put_line('Numele este ' || nume);

end;
/

declare
    nume painting.painting_title%type;
begin

    pachet_date_complexe.celMaiScump(3, nume);
    dbms_output.put_line('Tabloul este ' || nume);

end;
/






