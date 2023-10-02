# 🏨 Booking Hotel - Análisis
![WhatsApp Image 2023-09-24 at 21 06 01](https://github.com/marina-95/Booking-Hotel-Analysis/assets/144913530/9fb57506-3291-4a88-8a8c-dcb1336d4d7a)

## Tabla de Contenido
- [Introducción](#introducción)
- [Herramientas utilizadas](#herramientas-utilizadas)
- [Diagrama entidad relación](#diagrama-entidad-relación)
- [Preguntas y respuestas](#preguntas-y-respuestas)
- [Conclusiones](#conclusiones)
- [Dashboard](#dashboard)

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
	top 5 count(id_hotel_booking_2) as Cant_Reservas, 
	country as Pais
from hotel_booking_2
where country is not null
group by country
order by Cant_Reservas desc;
````
#### Respuesta:
| Cant_Reservas | Pais   |
| ------------- | ------ |
| 48590         | PRT    |
| 12129         | GBR    |
| 10415         | FRA    |
| 8568          | ESP    |
| 7287          | DEU    |

**2) ¿Cuántas noches (en promedio) se hospedan las personas según el tipo de hotel?**

````sql
select 
	avg(stays_in_week_nights + stays_in_weekend_nights) as Noches_Totales, hotel as Nombre_Hotel
from hotel_booking_2
where stays_in_week_nights != 0 or stays_in_weekend_nights != 0
group by hotel;
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
	reservation_status as Estado_Reserva, 
	round(count(reservation_status) / cast((select count(*) from hotel_booking_2) as decimal(8,2)), 2) as Porcentaje
from hotel_booking_2
where reservation_status = 'Canceled'
group by reservation_status;
````
#### Respuesta:
| Estado_Reserva | Porcentaje |
| -------------- | ---------- |
| Canceled       | 0.36       |

- Tasa cancelación por hotel:
````sql
select 
	hotel as Nombre_Hotel, 
	reservation_status as Estado_Reserva, 
	round(count(reservation_status) / cast((select count(*) from hotel_booking_2) as decimal(8,2)), 2) as Porcentaje
from hotel_booking_2
where reservation_status = 'Canceled'
group by reservation_status, hotel;
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
    from hotel_booking_2
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
	market_segment as Segmentacion_Mercado, 
	count(id_hotel_booking_2) as Cant_Reservas, 
	(count(id_hotel_booking_2) * 100.0/ (select count(id_hotel_booking_2) from hotel_booking_2)) as Porcentaje
from hotel_booking_2
group by market_segment
order by Cant_Reservas desc
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

**6) ¿Cuánto es el ADR promedio?**
````sql
select 
	round(avg(adr),0) as ADR_Promedio_USD
from hotel_booking_2
````
#### Respuesta:
| ADR_Promedio_USD  |
| ----------------- | 
| 102               |

## Conclusiones
- Los huéspedes provenientes de  **Portugal** son los que más reservan en estos hoteles.
- Los huéspedes reservan, en promedio, **4 noches** en el _Resort Hotel_ y **2 noches** en _City Hotel_.
- La tasa de cancelación es del **36 %** en total, siendo **27 %** de _City Hotel_ y el resto de _Resort Hotel_.
- El mes con más reserva es **Agosto**.
- La segmentación que predomina es **Online Travel Agents**.

## Dashboard
![Booking_page-0001](https://github.com/marina-95/Booking-Hotel-Analisis/assets/144913530/d119edb3-1862-4240-9f68-af19ae7252ee)
