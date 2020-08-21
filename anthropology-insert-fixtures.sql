use forensics;

-- ENUM POPULATION
insert into GenderRef (gender)
values ('M'),
       ('F'),
       ('O');

insert into RaceRef (race)
values ('dragonborn'),
       ('dwarf'),
       ('elf'),
       ('gnome'),
       ('halfelf'),
       ('halfling'),
       ('halforc'),
       ('human'),
       ('tiefling');

insert into EyeColorRef (eye_color)
values ('brown'),
       ('hazel'),
       ('gray'),
       ('blue'),
       ('amber'),
       ('green'),
       ('violet'),
       ('red'),
       ('black');

insert into StatusRef (status)
values ('unidentified'),
       ('potential match'),
       ('multiple matches');

insert into CountryRef (country)
values ('AL'),
       ('AD'),
       ('AM'),
       ('AT'),
       ('BY'),
       ('BE'),
       ('BA'),
       ('BG'),
       ('CH'),
       ('CY'),
       ('CZ'),
       ('DE'),
       ('DK'),
       ('EE'),
       ('ES'),
       ('FO'),
       ('FI'),
       ('FR'),
       ('GB'),
       ('GE'),
       ('GI'),
       ('GR'),
       ('HU'),
       ('HR'),
       ('IE'),
       ('IS'),
       ('IT'),
       ('LT'),
       ('LU'),
       ('LV'),
       ('MC'),
       ('MK'),
       ('MT'),
       ('NO'),
       ('NL'),
       ('PO'),
       ('PT'),
       ('RO'),
       ('RU'),
       ('SE'),
       ('SI'),
       ('SK'),
       ('SM'),
       ('TR'),
       ('UA'),
       ('VA');
insert into CountryRef (country)
values ('US'),
       ('CN');

insert into EventTypeRef (event_type)
values ('natural catastrophe'),
       ('terror attack'),
       ('infrastructure failure'),
       ('plague');
insert into EventTypeRef (event_type)
values ('earthquake'),
       ('wildfire'),
       ('ship grounding');

-- Institutions
insert into Institutions
values ('Polish National Forensics Institute', 'PO'),
       ('German National Forensics Institute', 'DE'),
       ('French National Forensics Institute', 'FR'),
       ('Danish National Forensics Institute', 'DK'),
       ('UK National Forensics Institute', 'GB');

-- Anthropologists
insert into Anthropologists
select 'Adam', 'Kowalski', institution_id
from Institutions
where name = 'Polish National Forensics Institute';

insert into Anthropologists
select 'Jan', 'Brzechwa', institution_id
from Institutions
where name = 'Polish National Forensics Institute';

insert into Anthropologists
select 'Toby', 'Mueller', institution_id
from Institutions
where name = 'German National Forensics Institute';

insert into Anthropologists
select 'Tim', 'Merkel', institution_id
from Institutions
where name = 'German National Forensics Institute';

insert into Anthropologists
select 'Lui', 'Vit', institution_id
from Institutions
where name = 'French National Forensics Institute';

insert into Anthropologists
select 'Josh', 'Gosh', institution_id
from Institutions
where name = 'UK National Forensics Institute';

-- Events
insert into Events
select 'September 11 attacks',
       40.7115,
       -74.0127,
       '2001-09-11T08:46:00',
       'The September 11 attacks (also referred to as 9/11) were a series of four coordinated terrorist attacks by the Islamic terrorist group al-Qaeda against the United States on the morning of Tuesday, September 11, 2001.',
       'terror attack',
       'US';

insert into Events
select 'Munich massacre',
       48.174419,
       11.553776,
       '1972-09-05T04:31:00',
       'The Munich massacre was an attack during the 1972 Summer Olympics in Munich, West Germany, in which the Palestinian terrorist group Black September took eleven Israeli Olympic team members hostage and killed them along with a West German police officer.',
       'terror attack',
       'DE';

insert into Events
select 'Great Tangshan earthquake',
       39.63,
       118.1,
       '1976-06-28T03:43:00',
       'The 1976 Tangshan earthquake, also known as Great Tangshan earthquake, was a natural disaster resulting from a magnitude 7.6 earthquake that hit the region around Tangshan, Hebei, People''s Republic of China on 28 July 1976, at 3:42 in the morning.',
       'earthquake',
       'CN';

insert into Events
select 'Attica wildfires',
       38.0525,
       23.868333,
       '2018-07-23T00:00:00',
       'A series of wildfires in Greece, during the 2018 European heat wave, began in the coastal areas of Attica in July 2018. As of May 2019, 102 people were confirmed dead. The fires were the second-deadliest wildfire event in the 21st century, after the 2009 Black Saturday bushfires in Australia that killed 173. ',
       'wildfire',
       'GR';

insert into Events
select 'Costa Concordia disaster',
       42.365278,
       10.921667,
       '2012-01-13T00:00:00',
       'On 13 January 2012, the Italian cruise ship Costa Concordia ran aground and overturned after striking an underwater rock off Isola del Giglio, Tuscany, resulting in 32 deaths. The eight-year-old Costa Cruises vessel was on the first leg of a cruise around the Mediterranean Sea when she deviated from her planned route at the Isola del Giglio, sailed closer to the island, and struck a rock formation on the sea floor. A six-hour rescue effort brought most of the passengers ashore.',
       'ship grounding',
       'IT';

-- Ante Mortems
-- first name and last name don't identify a anthropologist uniquely, but I assume only data created beforehand is my own
insert into AnteMortems
select 'Gotrek',
       'Gurnisson',
       120,
       150,
       118,
       'M',
       'dwarf',
       'green',
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Adam'
  and last_name = 'Kowalski';

insert into AnteMortems
select 'Felix',
       'Jaeger',
       40,
       190,
       85,
       'M',
       'human',
       'blue',
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Jan'
  and last_name = 'Brzechwa';

insert into AnteMortems
select 'Jane',
       'Generic',
       25,
       175,
       60,
       'F',
       'elf',
       'blue',
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Toby'
  and last_name = 'Mueller';

insert into AnteMortems
select 'Jim',
       'Lee',
       30,
       160,
       60,
       'M',
       'human',
       'brown',
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Toby'
  and last_name = 'Mueller';

insert into AnteMortems
select 'Tim',
       'Lee',
       30,
       162,
       61,
       'M',
       'human',
       'brown',
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Toby'
  and last_name = 'Mueller';

insert into AnteMortems
select 'Jack',
       'Unidentif',
       5,
       20,
       5,
       'M',
       'dragonborn',
       'red',
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Tim'
  and last_name = 'Merkel';

-- obligatory update
update AnteMortems
set created_by_id = 2
where first_name = 'Jack' and last_name = 'Unidentif';

insert into AnteMortems
select 'Player',
       'Unknown',
       99,
       170,
       56,
       'O',
       'halfling',
       'brown',
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Tim'
  and last_name = 'Merkel';


insert into AnteMortems
select 'Alpha',
       'AA',
       52,
       203,
       52,
       'M',
       'human',
       'brown',
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Attica wildfires'
  and first_name = 'Tim'
  and last_name = 'Merkel';

insert into AnteMortems
select 'Beta',
       'BB',
       54,
       223,
       51,
       'F',
       'human',
       'green',
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Attica wildfires'
  and first_name = 'Jan'
  and last_name = 'Brzechwa';

insert into AnteMortems
select 'Gamma',
       'C',
       52,
       203,
       52,
       'M',
       'human',
       'brown',
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Attica wildfires'
  and first_name = 'Tim'
  and last_name = 'Merkel';

-- Post Mortems
-- this will match one to one with Gotrek
insert into PostMortems
select 120,
       150,
       118,
       'M',
       'dwarf',
       'green',
       null,
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Jan'
  and last_name = 'Brzechwa';

-- this will match one to one with Felix (despite some nulls)
insert into PostMortems (age, height, weight, gender, race, eye_color, status, ante_mortem_id, event_id, created_by_id)
select null,
       191,
       83,
       'M',
       'human',
       null,
       null,
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Jan'
  and last_name = 'Brzechwa';

-- this and the next one will match Jane Generic
insert into PostMortems
select 25,
       175,
       60,
       'F',
       'elf',
       'blue',
       null,
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Toby'
  and last_name = 'Mueller';

insert into PostMortems
select 35,
       175,
       60,
       'F',
       null,
       'blue',
       null,
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Toby'
  and last_name = 'Mueller';

-- this will be matched by both Lees
insert into PostMortems
select 30,
       160,
       60,
       'M',
       'human',
       'brown',
       null,
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Toby'
  and last_name = 'Mueller';

-- these two won't match anything
insert into PostMortems
select 130,
       62,
       21,
       'O',
       'tiefling',
       null,
       null,
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Great Tangshan earthquake'
  and first_name = 'Toby'
  and last_name = 'Mueller';

insert into PostMortems (age, height, weight, gender, race, eye_color, status, ante_mortem_id, event_id, created_by_id)
select null,
       null,
       null,
       null,
       'elf',
       'blue',
       null,
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Attica wildfires'
  and first_name = 'Toby'
  and last_name = 'Mueller';

insert into PostMortems
select 100,
       100,
       100,
       'F',
       'elf',
       'blue',
       null,
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Attica wildfires'
  and first_name = 'Lui'
  and last_name = 'Vit';

insert into PostMortems
select 110,
       110,
       110,
       'M',
       'human',
       'violet',
       null,
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'Attica wildfires'
  and first_name = 'Lui'
  and last_name = 'Vit';

insert into PostMortems
select 120,
       120,
       120,
       'O',
       'elf',
       'brown',
       null,
       null,
       event_id,
       anthropologist_id
from Events
         cross join Anthropologists
where name = 'September 11 attacks'
  and first_name = 'Lui'
  and last_name = 'Vit';

select * from PostMortems;

insert into Items
values ('sickle', 'red, possibly bloodied'),
       ('hammer', 'regular looking hammer'),
       ('gun', '9mm glock'),
       ('axe', 'battle axe worthy of battle hardened dwarf'),
       ('book', 'title reads "Trollslayer"');

insert into PostMortems_Items
values (1,4),
       (2,5),
       (3,3),
       (3,2),
       (3,1);

insert into AnteMortems_Items
values (1,4),
       (2,5),
       (3,3),
       (4,2),
       (5,1);

insert into SpecialMarks
values ('tattoo', 'troll slayer tattoo'),
       ('scaven bites', 'multiple bites to legs, arms and torso'),
       ('missing pinky', 'finger cut at the metacarpals'),
       ('missing eye', 'left eye missing with empty hole left'),
       ('funny nose', 'just particularly funny nose');


insert into PostMortems_SpecialMarks
values (1,1),
       (1,4),
       (2,2),
       (3,3),
       (4,4);

insert into AnteMortems_SpecialMarks
values (1,1),
       (1,4),
       (2,2),
       (3,3),
       (4,4);