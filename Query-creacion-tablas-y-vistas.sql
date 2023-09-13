--En esta sección creo varias tablas para mis relaciones-entidad y luego creo las vistas para importarlas en Power BI--

--Creo tabla de tipo de hotel--
--INICIO

drop table if exists hotel
create table hotel
(
	id_hotel int identity (1,1) primary key,
	name nvarchar(30)
);

insert into hotel
select distinct hotel
FROM [dbo].[hotel_booking];

--FIN


--Creo tabla de meal--
--INICIO

drop table if exists meals
create table meals
(
	id_meal int identity (1,1) primary key,
	name nvarchar(15)
);

insert into meals
select distinct meal
FROM [dbo].[hotel_booking];

select * from meals;
--FIN


--Creo tabla countries--
--INICIO

drop table if exists countries
create table countries
(
	id_country int identity (1,1) primary key,
	country nvarchar(20)
);

insert into countries
select distinct country
FROM [dbo].[hotel_booking]
where country is not null;

select * from countries;

--FIN


--Creo tabla de market_segments--
--INICIO

drop table if exists market_segments
create table market_segments
(
	id_market_segment int identity (1,1) primary key,
	name nvarchar(30)
);

insert into market_segments
select distinct market_segment
FROM [dbo].[hotel_booking];

select * from market_segments;

--FIN


--Creo tabla de distribution_channels--
--INICIO

drop table if exists distribution_channels
create table distribution_channels
(
	id_distribution_channel int identity (1,1) primary key,
	name nvarchar(30)
);

insert into distribution_channels
select distinct distribution_channel
FROM [dbo].[hotel_booking];

select * from distribution_channels;

--FIN


--Creo tabla de deposits_types--
--INICIO

drop table if exists deposits_types
create table deposits_types
(
	id_deposit_type int identity (1,1) primary key,
	name nvarchar(30)
);

insert into deposits_types
select distinct deposit_type
FROM [dbo].[hotel_booking];

select * from deposits_types;

--FIN


--Creo tabla customers_types--
--INICIO

drop table if exists customers_types
create table customers_types
(
	id_customer_type int identity (1,1) primary key,
	name nvarchar(30)
);

insert into customers_types
select distinct customer_type
FROM [dbo].[hotel_booking];

--FIN


--Creo tabla reservations_status
--INICIO

drop table if exists reservations_status
create table reservations_status
(
	id_reservation_status int identity (1,1) primary key,
	name nvarchar(30)
);

insert into reservations_status
select distinct reservation_status
FROM [dbo].[hotel_booking];

--FIN


--Creo tabla general--
--INICIO

drop table if exists hotel_booking_new
create table hotel_booking_new
(
	id_hotel_booking_new int identity (1,1) primary key,
	id_hotel int not null,
	is_canceled bit,
	lead_time int,
	arrival_date date,
	stays_in_weekend_nights tinyint,
	stays_in_week_nights tinyint,
	adults tinyint,
	children tinyint,
	babies tinyint,
	id_meal tinyint,
	id_country int,
	id_market_segment tinyint,
	id_distribution_channel tinyint,
	is_repeated_guest tinyint,
	previous_cancellations tinyint,
	previous_bookings_not_canceled tinyint,
	reserved_room_type nvarchar(20),
	assigned_room_type nvarchar(20),
	booking_changes tinyint,
	id_deposit_type tinyint,
	agent float,
	company float,
	days_in_waiting_list int,
	id_customer_type tinyint,
	adr float,
	required_car_parking_spaces tinyint,
	total_of_special_requests tinyint,
	id_reservation_status tinyint,
);

insert into hotel_booking_new
select
	id_hotel,
	is_canceled,
	lead_time,
	concat(arrival_date_year, ' ', arrival_date_month,' ',arrival_date_day_of_month) as arrival_date,
	stays_in_weekend_nights,
	stays_in_week_nights,
	adults,
	children,
	babies,
	id_meal,
	id_country,
	id_market_segment,
	id_distribution_channel,
	is_repeated_guest,
	previous_cancellations,
	previous_bookings_not_canceled,
	reserved_room_type,
	assigned_room_type,
	booking_changes,
	id_deposit_type,
	agent,
	company,
	days_in_waiting_list,
	id_customer_type,
	adr,
	required_car_parking_spaces,
	total_of_special_requests,
	id_reservation_status
from [dbo].[hotel_booking]
left join [dbo].[hotel]
on [dbo].[hotel_booking].hotel = [dbo].[hotel].name
left join [dbo].[meals]
on [dbo].[hotel_booking].meal = [dbo].[meals].name
left join [dbo].[countries]
on [dbo].[hotel_booking].country = [dbo].[countries].country
left join [dbo].[market_segments]
on [dbo].[hotel_booking].market_segment = [dbo].[market_segments].name
left join [dbo].[distribution_channels]
on [dbo].[hotel_booking].distribution_channel = [dbo].[distribution_channels].name
left join [dbo].[deposits_types]
on [dbo].[hotel_booking].deposit_type = [dbo].[deposits_types].name
left join [dbo].[customers_types]
on [dbo].[hotel_booking].customer_type = [dbo].[customers_types].name
left join [dbo].[reservations_status]
on [dbo].[hotel_booking].reservation_status = [dbo].[reservations_status].name;

select * from hotel_booking_new;

--FIN

--Creo vistas de las tablas creadas--
--INICIO

create view v_hotel as
select * from [dbo].hotel;

create view v_meals as
select * from [dbo].meals;

create view v_countries as
select * from [dbo].countries;

create view v_market_segments as
select * from [dbo].market_segments;

create view v_distribution_channels as
select * from [dbo].distribution_channels;

create view v_deposits_types as
select * from [dbo].deposits_types;

create view v_customers_types as
select * from [dbo].customers_types;

create view v_reservations_status as
select * from [dbo].reservations_status;

create view v_hotel_booking_new as
select * from [dbo].hotel_booking_new;

--FIN
