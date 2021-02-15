--DORNEANU ALINA-MIHAELA, 241
--windows + r
--services.msc
--restart listener and oracle express

create table artist
(artist_id number(6),
a_last_name varchar2(30) constraint artist_last_name_nn not null,
a_first_name varchar2(30) constraint artist_first_name_nn not null,
date_of_birth date,
a_country varchar2(25),
favourite_style varchar2(30),
constraint artist_artist_id_pk primary key (artist_id));

create table address
(address_id number(6),
zip_code number(11) constraint address_zip_code_nn not null,
country varchar2(25) constraint address_country_nn not null,
city varchar2(25) constraint address_city_nn not null,
street_name varchar2(25),
street_no number(5),
constraint address_address_id_pk primary key (address_id));

create table art_movement
(movement_id number(5),
century varchar2(20),
am_description varchar2(100),
constraint art_movement_id_pk primary key (movement_id));

alter table art_movement
add movement_name varchar2(30);

create table exhibition
(exhibition_id number(5),
exhibition_title varchar2(30), 
exhibition_date date constraint exhibition_exhibition_date_nn not null,
address_id number(6),
constraint exhibition_address_id_fk foreign key (address_id) references address(address_id) on delete set null,
constraint exhibition_exhibition_id_pk primary key (exhibition_id));

create table auction_house
(house_id number(5),
house_name varchar2(20) constraint a_ahouse_name_nn not null,
house_phone varchar2(10),
address_id number(6),
constraint ah_address_id_fk foreign key (address_id) references address(address_id) on delete set null,
constraint ah_ahouse_id_pk primary key (house_id));

create table buyer
(buyer_id number(6),
b_last_name varchar2(30) constraint b_last_name_nn not null,
b_first_name varchar2(30) constraint b_first_name_nn not null,
buyer_phone varchar2(10),
address_id number(6),
constraint b_address_id_fk foreign key (address_id) references address(address_id) on delete set null,
constraint b_buyer_id_pk primary key (buyer_id));


create table seller
(seller_id number(6),
s_last_name varchar2(30) constraint s_last_name_nn not null,
s_first_name varchar2(30) constraint s_first_name_nn not null,
seller_phone varchar2(10),
address_id number(6),
constraint s_seller_id_fk foreign key (address_id) references address(address_id) on delete set null,
constraint s_seller_id_pk primary key (seller_id));

create table painting
(painting_id number(6),
painting_title varchar2(40),
p_description varchar(100),
status varchar2(12) constraint p_status_nn not null,
painting_year varchar2(5),
artist_id number(6),
constraint s_artist_id_fk foreign key (artist_id) references artist(artist_id) on delete set null,
constraint p_painting_id_pk primary key (painting_id));

create table belongs
(artist_id number(6),
movement_id number(5),
constraint belongs_pk primary key (artist_id, movement_id),
constraint belongs_artist_id_fk foreign key (artist_id) references artist(artist_id) on delete cascade,
constraint belongs_movement_id_fk foreign key (movement_id) references art_movement(movement_id) on delete cascade);


create table participate
(painting_id number(6),
exhibition_id number(5),
constraint participate_pk primary key (painting_id, exhibition_id),
constraint participate_painting_id_fk foreign key (painting_id) references painting(painting_id) on delete cascade,
constraint participate_exhibition_id_fk foreign key (exhibition_id) references exhibition(exhibition_id) on delete cascade);

create table buying
(painting_id number(6),
seller_id number(6),
buyer_id number(6),
date_of_sale date constraint buying_date_of_sale_nn not null,
house_id number(5),
exhibition_id number(5),
constraint buying_pk primary key (painting_id, seller_id, buyer_id),
constraint buying_painting_id_fk foreign key (painting_id) references painting(painting_id) on delete cascade,
constraint buying_seller_id_fk foreign key (seller_id) references seller(seller_id) on delete cascade,
constraint buying_buyer_id_fk foreign key (buyer_id) references buyer(buyer_id) on delete cascade,
constraint buying_house_id_fk foreign key (house_id) references auction_house(house_id) on delete set null,
constraint buying_exhibition_id_fk foreign key (exhibition_id) references exhibition(exhibition_id) on delete set null);

alter table buying
add price number(11,2);

alter table auction_house
add commission_pct number(4,2);

alter table artist
rename column favourite_style to artist_movement;

--insert pt artist


insert into artist (artist_id, a_last_name, a_first_name, date_of_birth, a_country, artist_movement) values
(1, 'da Vinci', 'Leonardo', to_date('14-04-1452', 'dd-mm-yyyy'), 'Italy', 'High Renaissance' );

insert into artist (artist_id, a_last_name, a_first_name, date_of_birth, a_country, artist_movement) values
(2, 'Cezanne', 'Paul', to_date('19-01-1839', 'dd-mm-yyyy'), 'France', 'Impressionism' );

insert into artist (artist_id, a_last_name, a_first_name, date_of_birth, a_country, artist_movement) values
(3, 'Gauguin', 'Eugene Henri Paul', to_date('07-06-1848', 'dd-mm-yyyy'), 'France', 'Primitivism' );

insert into artist (artist_id, a_last_name, a_first_name, date_of_birth, a_country, artist_movement) values
(4, 'Picasso', 'Pablo Ruiz', to_date('25-10-1881', 'dd-mm-yyyy'), 'Spain', 'Cubism' );

insert into artist (artist_id, a_last_name, a_first_name, date_of_birth, a_country, artist_movement) values
(5, 'de Kooning', 'Williem', to_date('24-04-1904', 'dd-mm-yyyy'), 'Netherlands', 'Abstract Expressionism');

insert into artist (artist_id, a_last_name, a_first_name, date_of_birth, a_country, artist_movement) values
(6, 'Klimt', 'Gustav', to_date('14-07-1862', 'dd-mm-yyyy'), 'Austria', 'Symbolism');

insert into artist (artist_id, a_last_name, a_first_name, date_of_birth, a_country, artist_movement) values
(7, 'Pollock', 'Jackson', to_date('28-01-1912', 'dd-mm-yyyy'), 'USA', 'Abstract expressionism');

insert into artist (artist_id, a_last_name, a_first_name, date_of_birth, a_country) values
(8, 'van Gogh', 'Vincent', to_date('30-01-1853', 'dd-mm-yyyy'), 'Netherlands');

insert into artist (artist_id, a_last_name, a_first_name, date_of_birth, a_country) values
(9, 'Eakins', 'Thomas', to_date('25-07-1844', 'dd-mm-yyyy'), 'USA' );

insert into artist (artist_id, a_last_name, a_first_name, date_of_birth, a_country) values
(10, 'Bacon', 'Francis', to_date('28-10-1909', 'dd-mm-yyyy'), 'Ireland' );

select * from artist;

--insert pt address

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(1, 00233, 'Italy', 'Bologna', 'Via Barberia', 29);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(2, 29910, 'Italy', 'Florence', 'Via Doccia', 70);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(3, 3233, 'Netherlands', 'Amsterdam', 'Waaigat', 3);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(4, 12344, 'USA', 'New York', 'King St', null);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(5, 3299, 'USA', 'Detroit', 'Franklin St', 143);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(6, 69941, 'Spain', 'Murcia', 'Calle Mar del Caribe', 204);

insert into address(address_id, zip_code, country, city) values
(7, 7203, 'Russia', 'Perm');

insert into address(address_id, zip_code, country, city, street_name) values
(8, 1223, 'Qatar', 'Doha', 'Massafi St');

insert into address(address_id, zip_code, country, city) values
(9, 2345, 'Saudi Arabia', 'Medina');

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(10, 44509, 'USA', 'Tampa', 'W Spruce St', 503);

insert into address(address_id, zip_code, country, city, street_name) values
(11, 45641, 'Japan', 'Osaka', 'Nipponbashi');

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(12, 32555, 'Mexico', 'Guadalajara', 'Lucas Alaman', 120);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(13, 999221, 'USA', 'Los Angeles', 'Packard St', 223);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(14, 90032, 'USA', 'New York', 'Avenue St', null);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(15, 2113, 'Switzerland', 'Berna', 'Altenbergrain', null);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(16, 999234, 'USA', 'Los Angeles', 'New St', 104);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(17, 495300, 'USA', 'Florida', 'Sun St', 11);

insert into address(address_id, zip_code, country, city, street_name, street_no) values
(18, 22113, 'USA', 'California', 'Palm St', 407);

select * from address;

--insert pt art_movement

alter table art_movement
modify am_description varchar2(300);

insert into art_movement(movement_id, century, am_description, movement_name) values
(1, '15', 'The visual arts of the High Renaissance were marked by a renewed emphasis upon the classical tradition, the expansion of networks of patronage, and a gradual attenuation of figural forms into the style later termed Mannerism.', 'High Renaissance');

commit;

insert into art_movement(movement_id, century, am_description, movement_name) values
(2, '19', 'Is characterized by relatively small, thin, yet visible brush strokes, open composition, emphasis on accurate depiction of light in its changing qualities, ordinary subject matter, inclusion of movement as a crucial element of human perception and experience, and unusual visual angles.', 'Impressionism');

insert into art_movement(movement_id, century, am_description, movement_name) values
(3, '18', 'The utopian end toward which primitivists aspire usually lies in a notional "state of nature" in which their ancestors existed (chronological primitivism), or in the supposed natural condition of the peoples that live beyond civilization.', 'Primitivism');

insert into art_movement(movement_id, century, am_description, movement_name) values
(4, '20', 'In Cubist artwork, objects are analyzed, broken up and reassembled in an abstracted form—instead of depicting objects from a single viewpoint, the artist depicts the subject from a multitude of viewpoints to represent the subject in a greater context.', 'Cubism');

insert into art_movement(movement_id, century, am_description, movement_name) values
(5, '20', 'The movement name is derived from the combination of the emotional intensity and self-denial of the German Expressionists with the anti-figurative aesthetic of the European abstract schools such as Futurism, the Bauhaus, and Synthetic Cubism.', 'Abstract Expressionism');

insert into art_movement(movement_id, century, am_description, movement_name) values
(6, '19', 'Stood for idealism, sentimentalism or exoticism, alongside a noted interest in spirituality and esotericism.', 'Symbolism');

insert into art_movement(movement_id, century, am_description, movement_name) values
(7, '19', 'Wanted to break down the traditional distinction between fine arts and applied arts.', 'Art Nouveau');

insert into art_movement(movement_id, century, am_description, movement_name) values
(8, '19', 'Created a "total art", that unified painting, architecture, and the decorative arts.', 'Vienna Secession');

insert into art_movement(movement_id, century, am_description, movement_name) values
(9, '19', 'Post-Impressionism emerged as a reaction against Impressionists concern for the naturalistic depiction of light and colour.', 'Post-Impressionism');

insert into art_movement(movement_id, century, am_description, movement_name) values
(10, '20', 'Known for juxtaposition of uncommon imagery.', 'Surrealism');

select * from art_movement;

--insert pt exhibition

alter table exhibition
drop column address_id;

alter table exhibition
add place varchar2(40);

--update exhibition
--set exhibition_title = 'In The Making'
--where exhibition_id = 2;

insert into exhibition(exhibition_id, exhibition_title, exhibition_date, place) values
(1, '2001 Best Paintings', to_date('28-01-2001', 'dd-mm-yyyy'), 'New York');


insert into exhibition(exhibition_id, exhibition_title, exhibition_date, place) values
(2, 'In The Making', to_date('09-11-2019', 'dd-mm-yyyy'), 'Tokio');

insert into exhibition(exhibition_id, exhibition_title, exhibition_date, place) values
(3, 'Shape Lab', to_date('11-03-2020', 'dd-mm-yyyy'), 'California');

insert into exhibition(exhibition_id, exhibition_title, exhibition_date, place) values
(4, 'Building Collections', to_date('29-05-2018', 'dd-mm-yyyy'), 'New York');

insert into exhibition(exhibition_id, exhibition_title, exhibition_date, place) values
(5, 'American Modern', to_date('30-09-2017', 'dd-mm-yyyy'), 'Los Angeles');

insert into exhibition(exhibition_id, exhibition_title, exhibition_date, place) values
(6, 'Sunflower', to_date('04-01-2020', 'dd-mm-yyyy'), 'California);

select * from exhibition;

--insert pt auction house

alter table auction_house
modify house_phone varchar2(12);

insert into auction_house(house_id, house_name, house_phone, address_id) values
(1, 'Christie','917-277-1151', 4);

insert into auction_house(house_id, house_name, house_phone, address_id, commission_pct) values
(2, 'Larry Gagosian','886-300-1100', 3, 5);

insert into auction_house(house_id, house_name, house_phone, address_id, commission_pct) values
(3, 'Sotheby','223-299-1212', 10, 4.8);

insert into auction_house(house_id, house_name, house_phone, address_id, commission_pct) values
(4, 'Steven Mazoh', '917-277-1151', 13, 3.9);

select * from auction_house;

--insert pt buyer

alter table buyer
modify buyer_phone varchar2(12);

insert into buyer(buyer_id, b_last_name, b_first_name, buyer_phone, address_id) values
(1, 'Al Saud', 'Badr bin Abdullah', '223-008-0092', 8);

insert into buyer(buyer_id, b_last_name, b_first_name, buyer_phone, address_id) values
(2, 'Griffin', 'Kenneth', '890-808-123', 14);

insert into buyer(buyer_id, b_last_name, b_first_name, buyer_phone, address_id) values
(3, 'Rybolovlev', 'Dmitry', '700-122-2003', 7);

insert into buyer(buyer_id, b_last_name, b_first_name, buyer_phone, address_id) values
(4, 'Liu', 'Yiqian', '301-177-8880', 11);

insert into buyer(buyer_id, b_last_name, b_first_name, buyer_phone, address_id) values
(5, 'Martinez', 'David', '455-420-2020', 12);

insert into buyer(buyer_id, b_last_name, b_first_name, buyer_phone, address_id) values
(6, 'Staechelin', 'Rudolf', '233-009-1909', 5);

insert into buyer(buyer_id, b_last_name, b_first_name, buyer_phone, address_id) values
(7, 'Al Thani', 'Hamad', null, 9);

insert into buyer(buyer_id, b_last_name, b_first_name, buyer_phone, address_id) values
(8, 'James', 'Steven', null, 16);

insert into buyer(buyer_id, b_last_name, b_first_name, buyer_phone, address_id) values
(9, 'Wynn', 'Steve', null, 17);

insert into buyer(buyer_id, b_last_name, b_first_name, buyer_phone, address_id) values
(10, 'Whitney', 'Betsey', null, 18);

select * from buyer;

--insert pt seller

alter table seller
modify seller_phone varchar2(12);

insert into seller(seller_id, s_last_name, s_first_name, seller_phone, address_id) values
(1, 'Rybolovlev', 'Dmitry', '700-122-2003', 7);

insert into seller(seller_id, s_last_name, s_first_name, seller_phone, address_id) values
(2, 'Geffen', 'David', '566-444-2443', 1);

insert into seller(seller_id, s_last_name, s_first_name, seller_phone, address_id) values
(3, 'Embiricos', 'George', '333-231-2213', 6);

insert into seller(seller_id, s_last_name, s_first_name, seller_phone, address_id) values
(4, 'Staechelin', 'Rudolf', '921-219-7004', 15);

insert into seller(seller_id, s_last_name, s_first_name, seller_phone, address_id) values
(5, 'Altmann', 'Maria', '521-400-6399', 2);

select * from seller;

--insert pt painting



insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(1, 'Salvador Mundi', 'Jesus in Renaissance dress, making the sign of the cross.', 'sold', 1500, 1);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(2, 'The Card Players', 'The men look down at their cards rather than at each other.', 'sold', 1892, 3);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(3, 'When Will You Marry?', 'The front and middle ground are built up in areas of green, yellow and blue.', 'sold', 1892, 3);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(4, 'Women of Algiers', 'Image of languid, voluptuous women known as odalisques.', 'sold', 1955, 4);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(5, 'Interchange', 'It was one of de Kooning first abstract landscapes.', 'sold', 1955, 5);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(6, 'Boy with a Pipe', 'A Parisian adolescent boy who holds a pipe in his left hand.', 'available', 1905, 4);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(7, 'Woman III', ' Done between 1951 and 1953 in which the central theme was a woman.', 'available', 1953, 5);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(8, 'Le Reve', 'Is portraying his 22-year-old mistress Marie-Thér?se Walter.', 'available', 1932, 4);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(9, 'Otahi', 'Also known as Alone.', 'available', 1893, 3);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(10, 'Nude, Green Leaves and Bust', 'Featuring his mistress Marie-Thér?se Walter.', 'available', 1932, 4);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(11, 'Portrait of Adele Bloch-Bauer I', 'Also called The Lady in Gold or The Woman in Gold.', 'sold', 1907, 6);

insert into painting(painting_id, painting_title, p_description, status, painting_year, artist_id) values
(12, 'No. 5, 1948', 'The painting was created on fibreboard.', 'sold', 1948, 7);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(13, 'Portrait of Adele Bloch-Bauer II', 'Adele Bloch-Bauer was the only person whose portrait was painted twice by Klimt.', 1912, 6);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(14, 'Dora Maar au Chat', 'Dora Maar au Chat is one of the largest portraits of the subject by Picasso.', 1941, 4);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(15, 'Young Girl with a Flower Basket', 'The subject of the painting is a young girl who was working as a flower seller.', 1905, 4);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(16, 'Les Noces de Pierrette', 'The marriage of Pierrette.', 1905, 4);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(17, 'Yo, Picasso', 'Portret.', 1901, 4);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(18, 'Water Serpents II', 'It is the follow-up painting to the earlier painting Water Serpents I.', 1904, 6);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(19, 'Rideau, Cruchon et Compotier', 'It is considered the most expensive still life ever sold at an auction..', 1893, 2);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(20, 'Police Gazette', 'A landscape painted on canvas using abstract elements, and colors such as yellow, green and red.', 1955, 5);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(21, 'Portrait of Dr. Gachet', 'Shows Gachet sitting at a table and leaning his head on his right arm.', 1890, 8);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(22, 'Portrait of the Postman Joseph Roulin', 'Also known as The Father.', 1888, 8);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(23, 'Irises', 'The painting is full of softness and lightness.', 1889, 8);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(24, 'Starry Night Over the Rhône', 'The sky is aquamarine, the water is royal blue.', 1888, 8);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(25, 'Self-portrait without beard', 'This may have been his last self-portrait.', 1889, 8);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(26, 'Gioconda', 'Also known as Mona Lisa.', 1503, 1);

insert into painting(painting_id, painting_title, p_description, painting_year, artist_id) values
(27, 'Triptych, 1976', 'It is the second most expensive Bacon ever sold.', 1976, 10);

select * from painting;

commit;


select * from painting;

alter table painting
drop column status;

--insert pt participate

insert into participate(painting_id, exhibition_id) values
(1, 2);

insert into participate(painting_id, exhibition_id) values
(2, 4);

insert into participate(painting_id, exhibition_id) values
(3, 5);

insert into participate(painting_id, exhibition_id) values
(4, 3);

insert into participate(painting_id, exhibition_id) values
(5, 2);

insert into participate(painting_id, exhibition_id) values
(6, 5);

insert into participate(painting_id, exhibition_id) values
(7, 3);

insert into participate(painting_id, exhibition_id) values
(8, 3);

insert into participate(painting_id, exhibition_id) values
(9, 3);

insert into participate(painting_id, exhibition_id) values
(10, 4);

insert into participate(painting_id, exhibition_id) values
(10, 5);

insert into participate(painting_id, exhibition_id) values
(8, 2);

insert into participate(painting_id, exhibition_id) values
(8, 4);

insert into participate(painting_id, exhibition_id) values
(27, 1);

insert into participate(painting_id, exhibition_id) values
(27, 1);

insert into participate(painting_id, exhibition_id) values
(26, 1);

insert into participate(painting_id, exhibition_id) values
(11, 1);

insert into participate(painting_id, exhibition_id) values
(12, 3);

insert into participate(painting_id, exhibition_id) values
(12, 1);

insert into participate(painting_id, exhibition_id) values
(13, 3);

insert into participate(painting_id, exhibition_id) values
(14, 5);

insert into participate(painting_id, exhibition_id) values
(15, 2);

insert into participate(painting_id, exhibition_id) values
(16, 2);

insert into participate(painting_id, exhibition_id) values
(17, 4);

insert into participate(painting_id, exhibition_id) values
(18, 4);

insert into participate(painting_id, exhibition_id) values
(19, 5);

insert into participate(painting_id, exhibition_id) values
(20, 1);

insert into participate(painting_id, exhibition_id) values
(21, 1);

insert into participate(painting_id, exhibition_id) values
(21, 3);

insert into participate(painting_id, exhibition_id) values
(22, 5);

insert into participate(painting_id, exhibition_id) values
(23, 4);

insert into participate(painting_id, exhibition_id) values
(24, 4);

insert into participate(painting_id, exhibition_id) values
(25, 2);

insert into participate(painting_id, exhibition_id) values
(1, 5);

insert into participate(painting_id, exhibition_id) values
(21, 4);

insert into participate(painting_id, exhibition_id) values
(18, 2);

insert into participate(painting_id, exhibition_id) values
(13, 1);

insert into participate(painting_id, exhibition_id) values
(4, 5);

insert into participate(painting_id, exhibition_id) values
(12, 4);

insert into participate(painting_id, exhibition_id) values
(17, 2);

insert into participate(painting_id, exhibition_id) values
(19, 2);

insert into participate(painting_id, exhibition_id) values
(20, 2);

insert into participate(painting_id, exhibition_id) values
(11, 2);

insert into participate(painting_id, exhibition_id) values
(1, 1);

insert into participate(painting_id, exhibition_id) values
(2, 5);

insert into participate(painting_id, exhibition_id) values
(3, 2);


insert into participate(painting_id, exhibition_id) values
(5, 4);

insert into participate(painting_id, exhibition_id) values
(6, 3);

insert into participate(painting_id, exhibition_id) values
(9, 5);


insert into participate(painting_id, exhibition_id) values
(13, 2);

insert into participate(painting_id, exhibition_id) values
(15, 5);

insert into participate(painting_id, exhibition_id) values
(23, 2);

insert into participate(painting_id, exhibition_id) values
(27, 5);

insert into participate(painting_id, exhibition_id) values
(14, 1);

select * from participate;

--insert pt buying
--(painting_id number(6),
--seller_id number(6),
--buyer_id number(6),
--date_of_sale date constraint buying_date_of_sale_nn not null,
---house_id number(5),
--exhibition_id number(5),


insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(1, 1, 1, to_date('15-11-2017', 'dd-mm-yyyy'), 1, 1, 469.7);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(2, 3, 1, to_date('15-08-2015', 'dd-mm-yyyy'), 3, 5, 284);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(3, 4, 2, to_date('03-08-2014', 'dd-mm-yyyy'), 4, 2, 227);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(4, 4, 2, to_date('03-08-2014', 'dd-mm-yyyy'), 1, 3, 193.5);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(5, 2, 2, to_date('11-05-2015', 'dd-mm-yyyy'), 2, 4, 324);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(6, 2, 3, to_date('02-11-2006', 'dd-mm-yyyy'), 3, 3, 141);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(7, 3, 4, to_date('02-11-2006', 'dd-mm-yyyy'), 3, 3, 177.6);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(8, 3, 1, to_date('26-03-2013', 'dd-mm-yyyy'), 3, 3, 170.1);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(9, 5, 3, to_date('24-08-2013', 'dd-mm-yyyy'), 3, 5, 131.7);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(10, 5, 6, to_date('04-05-2010', 'dd-mm-yyyy'), 3, 4, 124.8);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(11, 4, 7, to_date('11-05-2015', 'dd-mm-yyyy'), 1, 2, 171.2);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(12, 4, 7, to_date('02-11-2006', 'dd-mm-yyyy'), 3, 1, 177.6);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(13, 1, 4, to_date('23-02-2016', 'dd-mm-yyyy'), 2, 2, 159.8);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(14, 2, 5, to_date('23-02-2016', 'dd-mm-yyyy'), 3, 5, 120.8);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(15, 4, 2, to_date('08-05-2018', 'dd-mm-yyyy'), 3, 5, 117.1);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(16, 5, 7, to_date('30-11-2000', 'dd-mm-yyyy'), 4, 2, 101.7);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(17, 2, 6, to_date('30-11-2000', 'dd-mm-yyyy'), 4, 2, 101.7);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(18, 5, 3, to_date('13-04-2013', 'dd-mm-yyyy'), null, null, 201.7);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(19, 1, 7, to_date('10-05-1999', 'dd-mm-yyyy'), null, null, 92.9);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(20, 2, 5, to_date('12-10-2006', 'dd-mm-yyyy'), null, null, 80.5);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(21, 5, 6, to_date('15-05-1990', 'dd-mm-yyyy'), null, null, 161.4);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(22, 1, 4, to_date('15-05-1990', 'dd-mm-yyyy'), null, null, 123.8);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(23, 2, 2, to_date('11-11-1987', 'dd-mm-yyyy'), 4, 2, 121.3);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(24, 5, 6, to_date('11-11-1987', 'dd-mm-yyyy'), null, null, 101.3);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(25, 4, 7, to_date('11-11-1987', 'dd-mm-yyyy'), null, null, 71.5);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(26, 2, 3, to_date('11-11-1987', 'dd-mm-yyyy'), null, null, 860);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(27, 5, 10, to_date('14-05-2018', 'dd-mm-yyyy'), 3, 5, 102.5);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(11, 2, 8, to_date('11-12-2019', 'dd-mm-yyyy'), 2, 1, 190.4);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(14, 5, 10, to_date('03-05-2019', 'dd-mm-yyyy'), 4, 1, 130.9);

insert into buying(painting_id, seller_id, buyer_id, date_of_sale, house_id, exhibition_id, price) values
(3, 4, 9, to_date('21-01-2019', 'dd-mm-yyyy'), 3, 2, 250.4 );

select * from buying;


select * from painting;
select * from auction_house;
select * from seller;
select * from buyer;

commit;

--insert pt belongs
alter table artist
drop column artist_movement;

alter table exhibition
rename column city to exhibition_city;

insert into belongs(artist_id, movement_id) values
(1, 1);

insert into belongs(artist_id, movement_id) values
(2, 2);

insert into belongs(artist_id, movement_id) values
(2, 9);

insert into belongs(artist_id, movement_id) values
(3, 9);

insert into belongs(artist_id, movement_id) values
(3, 3);

insert into belongs(artist_id, movement_id) values
(4, 4);

insert into belongs(artist_id, movement_id) values
(4, 10);

insert into belongs(artist_id, movement_id) values
(5, 5);

insert into belongs(artist_id, movement_id) values
(6, 6);

insert into belongs(artist_id, movement_id) values
(6, 7);

insert into belongs(artist_id, movement_id) values
(6, 8);

insert into belongs(artist_id, movement_id) values
(7, 5);

insert into belongs(artist_id, movement_id) values
(8, 9);

insert into belongs(artist_id, movement_id) values
(10, 4);

insert into belongs(artist_id, movement_id) values
(10, 5);

select * from belongs;


select * from artist;
select * from address;
select * from art_movement;
select * from exhibition;
select * from auction_house;
select * from seller;
select * from buyer;
select * from paiting;
select * from belongs;
select * from participate;
select * from buying;
