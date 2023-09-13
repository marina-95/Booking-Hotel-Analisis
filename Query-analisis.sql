--Analisis estratégico--

select * from hotel_booking_new

--1) Top 10 origen huéspedes

select top 10 count(id_hotel_booking_new) as cant_reservas, s.country
from [dbo].[hotel_booking_new] r
left join [dbo].[countries] s
on r.id_country = s.id_country
where s.country is not null
group by s.country
order by cant_reservas desc;

--2) ¿Cuántas noches en promedio se hospedan las personas según el tipo de hotel?

select avg(stays_in_week_nights + stays_in_weekend_nights) as noches_totales, s.name
from [dbo].[hotel_booking_new] r
left join [dbo].[hotel] s
on r.id_hotel = s.[id_hotel]
where r.stays_in_week_nights != 0 or r.stays_in_weekend_nights != 0
group by s.name;

--3a) Tasa de cancelación en todo el periodo de análisis

select s.name, round(count(r.id_reservation_status) / cast((select count(*) from [dbo].[hotel_booking_new]) as decimal(8,2)), 2) as porcentaje
from [dbo].[hotel_booking_new] r
join  [dbo].[reservations_status] s
on r.id_reservation_status = s.id_reservation_status
where r.id_reservation_status = 3
group by r.id_reservation_status, s.name;

--3b) Tasa de cancelación en función del tipo de hotel

select t.name, s.name, round(count(r.id_reservation_status) / cast((select count(*) from [dbo].[hotel_booking_new]) as decimal(8,2)), 2) as porcentaje
from [dbo].[hotel_booking_new] r
join  [dbo].[reservations_status] s
on r.id_reservation_status = s.id_reservation_status
join [dbo].[hotel] t
on r.id_hotel = t.id_hotel
where r.id_reservation_status = 3
group by r.id_reservation_status, s.name, t.name;


--4) En qué mes/meses se hacen más reservas? (se verá mejor en una visualización)

select month(arrival_date) as mes, count(is_canceled) as cant_reservas
from [dbo].[hotel_booking_new]
where is_canceled = 0
group by month(arrival_date)
order by month(arrival_date);

--5) Segmentacion de mercado

select s.name, count(id_hotel_booking_new) as cant_reservas, (count(id_hotel_booking_new) * 100.0/ (select count(id_hotel_booking_new) from [dbo].[hotel_booking_new])) as porcentaje
from [dbo].[hotel_booking_new] r
join [dbo].[market_segments] s
on r.id_market_segment = s.id_market_segment
group by s.name
order by cant_reservas desc


