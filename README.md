# 🏨 Booking Hotel - Amálisis
(logo)

## Tabla de Contenido

## Introducción
Utilizo una base de datos de un hotel ficticio extraído de [Kaggle](https://www.kaggle.com/datasets/mojtaba142/hotel-booking). 
El mismo contiene 119.390 observaciones. Cada observación representa una reserva de hotel entre el 1 de julio de 2015 y el 31 de agosto de 2017, incluyendo la reserva que efectivamente llegó y la reserva que fue cancelada.
Mi intención es llevar a cabo un análisis del tipo estratégico destinado a la gerencia del hotel, logrando así ayudar en la toma de decisiones.

## Herramientas utilizadas
- SQL: creación de tablas/vistas y posterior análisis
- Power BI: visualización
- Canva: creación de logo

## Diagrama entidad relación

## Preguntas y respuestas
**1) ¿De qué países provienen los huéspedes?**

````sql
select 
	top 5 count(id_hotel_booking_new) as Cant_Reservas, 
	s.country as Paises
from [dbo].[hotel_booking_new] r
left join [dbo].[countries] s
on r.id_country = s.id_country
where s.country is not null
group by s.country
order by cant_reservas desc
````
#### Respuesta:
| Cant_Reservas | Países |
| ------------- | ------ |
| 48590         | PRT    |
| 12129         | GBR    |
| 10415         | FRA    |
| 8568          | ESP    |
| 7287          | DEU    |

**2) ¿Cuántas noches (en promedio) se hospedan las personas según el tipo de hotel?**

````sql
select 
	avg(stays_in_week_nights + stays_in_weekend_nights) as Noches_Totales, 
	s.name as Nombre_Hotel
from [dbo].[hotel_booking_new] r
left join [dbo].[hotel] s
on r.id_hotel = s.[id_hotel]
where r.stays_in_week_nights != 0 or r.stays_in_weekend_nights != 0
group by s.name;
````
#### Respuesta:
| Noches_Totales | Nombre_Hotel   |
| -------------- | -------------- |
| 2              | City Hotel     |
| 4              | Resort Hotel   |

**3) ¿Cuál es la tasa de cancelación general y en cada hotel?**
- Tasa cancelación general:
````sql
select 
	s.name as Estado_Reserva, 
	round(count(r.id_reservation_status) / cast((select count(*) from [dbo].[hotel_booking_new]) as decimal(8,2)), 2) as Porcentaje
from [dbo].[hotel_booking_new] r
join  [dbo].[reservations_status] s
on r.id_reservation_status = s.id_reservation_status
where r.id_reservation_status = 3
group by r.id_reservation_status, s.name;
````
#### Respuesta:
| Estado_Reserva | Porcentaje |
| -------------- | ---------- |
| Canceled       | 0.36       |

- Tasa cancelación por hotel:
````sql
select 
	t.name as Nombre_Hotel, 
	s.name as Estado_Reserva, 
	round(count(r.id_reservation_status) / cast((select count(*) from [dbo].[hotel_booking_new]) as decimal(8,2)), 2) as Porcentaje
from [dbo].[hotel_booking_new] r
join  [dbo].[reservations_status] s
on r.id_reservation_status = s.id_reservation_status
join [dbo].[hotel] t
on r.id_hotel = t.id_hotel
where r.id_reservation_status = 3
group by r.id_reservation_status, s.name, t.name;
````
#### Respuesta:
| Nombre_Hotel   | Estado_Reserva | Porcentaje |
| -------------- | -------------- | ---------- |
| City Hotel     | Canceled       | 0.27       |
| Resort Hotel   | Canceled       | 0.09       |

**4) ¿En qué meses se realizan más reservas?**
````sql
with Reservas_Por_Mes as (
    select
        datename(month, arrival_date) as Mes,
        count(is_canceled) as Cant_Reservas
    from [dbo].[hotel_booking_new]
    where is_canceled = 0
    group by datename(month, arrival_date)
)
select top 3 Mes, Cant_Reservas
from Reservas_Por_Mes
order by Cant_Reservas desc;
````
#### Respuesta:
| Mes    | Cant_Reservas | 
| ------ | ------------- |
| August | 8638          |
| July   | 7919          | 
| May    | 7114          |

**5) ¿Qué segmentación del mercado es la que predomina?**
````sql
select 
	s.name as Segmentacion, 
	count(id_hotel_booking_new) as Cant_Reservas, 
	(count(id_hotel_booking_new) * 100.0/ (select count(id_hotel_booking_new) from [dbo].[hotel_booking_new])) as Porcentaje
from [dbo].[hotel_booking_new] r
join [dbo].[market_segments] s
on r.id_market_segment = s.id_market_segment
group by s.name
order by cant_reservas desc
````
#### Respuesta:
| Segmentacion  | Cant_Reservas | Porcentaje |
| ------------- | ------------- |----------- |
| Online TA     | 56477         | 47.3       |
| Offline TA/TO | 24219         | 20.3       |
| Groups        | 19811         | 16.6       |
| Direct        | 12606         | 10.6       |
| Corporate     | 5295          | 4.4        |
| Complementary | 743           | 0.6        |
| Aviation      | 237           | 0.2        |
| Undefined     | 2             | 0.002      |
 
## Dashboard
![Booking_page-0001](https://github.com/marina-95/Booking-Hotel-Analisis/assets/144913530/d119edb3-1862-4240-9f68-af19ae7252ee)
