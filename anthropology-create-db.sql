use master;
create database forensics;
go
use forensics;

-----------
-- ENUMS --
-----------
-- I find enums important to avoid typos ("green" not matching "gren"), strange user defined
-- values and to keep the matching fields
-- in as small range as possible (eg. eye color "green" not matching "light green")
-- However, if it is necessary, option to add new value is easy

create table GenderRef
(
    gender char(1) not null primary key
);

create table RaceRef
(
    race varchar(32) not null primary key
);

create table EyeColorRef
(
    eye_color varchar(16) not null primary key
);

create table StatusRef
(
    status varchar(32) not null primary key
);

create table CountryRef
(
    country char(2) not null primary key
);

create table EventTypeRef
(
    event_type varchar(64) not null primary key
);

-----------------
-- MAIN TABLES --
-----------------

-- I thought about merging PostMortems and AnteMortems tables (as they by design share all but one field
-- but I think it is important to keep logical separation between the two
create table Institutions
(
    institution_id int identity primary key,
    name           varchar(256) unique not null,
    country        char(2)             not null,
    foreign key (country) references CountryRef (country),
);

create table Anthropologists
(
    anthropologist_id int identity primary key,
    first_name        varchar(64) not null,
    last_name         varchar(64) not null,
    affiliation_id    int         not null, -- index
    foreign key (affiliation_id) references Institutions (institution_id),
);

-- based on 3rd query and common sense
create index IX_Anthropologists_AffiliationId
    on Anthropologists (affiliation_id);

-- I allow for a lot of nulls, but for each I can imagine a situation where the value is not known
-- country? maybe it happened on international waters, date? maybe it was found long after and exact date is not known, etc.
create table Events
(
    event_id    int identity primary key,
    name        varchar(256) unique not null,
    latitude    decimal(9, 6)       null,
    longitude   decimal(9, 6)       null,
    date        datetime            null,
    description ntext               not null,
    type        varchar(64)         not null, -- index
    country     char(2)             null,     -- index
    foreign key (type) references EventTypeRef (event_type),
    foreign key (country) references CountryRef (country),
);

-- might be useful to group events by type (for eg. global death statistics by cause)
create index IX_Events_Type
    on Events (type);

-- based on 1st query
create index IX_Events_Country
    on Events (country);

create table AnteMortems
(
    ante_mortem_id int identity primary key,
    first_name     varchar(64) not null,
    last_name      varchar(64) not null,
    age            tinyint     null,
    height         smallint    null,
    weight         smallint    null,
    gender         char(1)     null,     -- enum
    race           varchar(32) null,     -- enum
    eye_color      varchar(16) null,     -- enum
    status         varchar(32) null,     -- enum
    event_id       int         not null, -- fk
    created_by_id  int         not null, -- fk
    foreign key (gender) references GenderRef (gender),
    foreign key (race) references RaceRef (race),
    foreign key (eye_color) references EyeColorRef (eye_color),
    foreign key (status) references StatusRef (status),
    foreign key (event_id) references Events (event_id),
    foreign key (created_by_id) references Anthropologists (anthropologist_id),
);

-- I general all foreign keys should have indexes placed on them.
-- I won't do so for enums, as they have very low selectivity, but it applies to all regular fk
create index IX_AnteMortems_EventId
    on AnteMortems (event_id);

create index IX_AnteMortems_CreatedById
    on AnteMortems (created_by_id);

create table PostMortems
(
    post_mortem_id int identity primary key,
    age            tinyint     null,
    height         smallint    null,
    weight         smallint    null,
    gender         char(1)     null,     -- enum
    race           varchar(32) null,     -- enum
    eye_color      varchar(16) null,     -- enum
    status         varchar(32) null,     -- enum
    ante_mortem_id int         null,     -- 1-1 fk
    event_id       int         not null,
    created_by_id  int         not null, -- fk
    foreign key (gender) references GenderRef (gender),
    foreign key (race) references RaceRef (race),
    foreign key (eye_color) references EyeColorRef (eye_color),
    foreign key (status) references StatusRef (status),
    foreign key (ante_mortem_id) references AnteMortems (ante_mortem_id),
    foreign key (event_id) references Events (event_id),
    foreign key (created_by_id) references Anthropologists (anthropologist_id),
);

-- I want ante_mortem_id to be unique, unless it's null, this calls for custom unique index as described here
-- https://stackoverflow.com/questions/767657/how-do-i-create-a-unique-constraint-that-also-allows-nulls/767702#767702
create unique nonclustered index UQ_PostMortem_AnteMortemId
    on PostMortems (ante_mortem_id)
    where ante_mortem_id is not null;

-- regular fk indexes as well
create index IX_PostMortems_EventId
    on PostMortems (event_id);

create index IX_PostMortems_CreatedById
    on PostMortems (created_by_id);

-- name is not unique, as there could be for eg. two, but completely different, watches
-- we will be matching them by id and it will be forced on the anthropologist to search
-- already available items to check if similar item is already in the database
create table Items
(
    item_id     int identity primary key,
    name        varchar(256) not null,
    description ntext        not null, -- nudge lazy anthropologist to fill it in
);

-- same rationale as above
create table SpecialMarks
(
    special_mark_id int identity primary key,
    name            varchar(256) not null,
    description     ntext        not null,
)

----------------------------
-- MANY TO MANY RELATIONS --
----------------------------

create table PostMortems_SpecialMarks
(
    post_mortem_id  int not null,
    special_mark_id int not null,
    primary key (post_mortem_id, special_mark_id),
    foreign key (post_mortem_id) references PostMortems (post_mortem_id),
    foreign key (special_mark_id) references SpecialMarks (special_mark_id),
);

create table AnteMortems_SpecialMarks
(
    ante_mortem_id  int not null,
    special_mark_id int not null,
    primary key (ante_mortem_id, special_mark_id),
    foreign key (ante_mortem_id) references AnteMortems (ante_mortem_id),
    foreign key (special_mark_id) references SpecialMarks (special_mark_id),
);

create table PostMortems_Items
(
    post_mortem_id int not null,
    item_id        int not null,
    primary key (post_mortem_id, item_id),
    foreign key (post_mortem_id) references PostMortems (post_mortem_id),
    foreign key (item_id) references Items (item_id),
);

create table AnteMortems_Items
(
    ante_mortem_id int not null,
    item_id        int not null,
    primary key (ante_mortem_id, item_id),
    foreign key (ante_mortem_id) references AnteMortems (ante_mortem_id),
    foreign key (item_id) references Items (item_id),
);