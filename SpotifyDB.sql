Create database SpotifyDB
Use SpotifyDB

Create table Users
(
Id int primary key identity,
Name nvarchar(40) not null,
Surname nvarchar(40) not null,
Username nvarchar(40) not null unique,
Password nvarchar(40) not null unique,
Gender nvarchar(40) not null 
)
INSERT INTO Users (Name, Surname, Username, Password, Gender) VALUES
('John', 'Doe', 'johndoe', 'password123', 'Male'),
('Jane', 'Smith', 'janesmith', 'password456', 'Female'),
('Alex', 'Johnson', 'alexj', 'password789', 'Male'),
('Emily', 'Davis', 'emilyd', 'password101', 'Female'),
('Michael', 'Williams', 'michaelw', 'password112', 'Male');

select * from Users

 Create table Artists
(
Id int primary key identity,
Name nvarchar(40) not null,
Surname nvarchar(40) not null,
Birthday date not null,
Gender nvarchar(40) not null 
)
INSERT INTO Artists (Name, Surname, Birthday, Gender) VALUES
('Ed', 'Sheeran', '1991-02-17', 'Male'),
('Taylor', 'Swift', '1989-12-13', 'Female'),
('Ariana', 'Grande', '1993-06-26', 'Female'),
('Drake', 'Bell', '1986-06-27', 'Male'),
('Billie', 'Eilish', '2001-12-18', 'Female');
select * from Artists

Create table Categories
(
Id int primary key identity,
Name nvarchar(40) not null
)
INSERT INTO Categories (Name) VALUES
('Pop'),
('Rock'),
('Hip-Hop'),
('Jazz'),
('Classical');

select * from Categories




Create table Musics
(
Id int primary key identity,
Name nvarchar(40) not null,
Duration time not null Check(Duration> '00:00:00'),
CategoryId int Foreign key references Categories(Id)
) 
select format(Duration, 'hh:mm:ss') as Duration
From Musics

INSERT INTO Musics (Name, Duration, CategoryId) VALUES
('Shape of You', '00:04:24', 1),
('Love Story', '00:03:55', 1),
('Thank U, Next', '00:03:27', 1),
('Hotline Bling', '00:04:27', 2),
('Bad Guy', '00:03:14', 1),
('Blinding Lights', '00:03:22', 2),
('The One That Got Away', '00:04:47', 2),
('Stressed Out', '00:03:22', 3),
('Closer', '00:04:04', 3),
('The Less I Know The Better', '00:03:36', 3),
('All of Me', '00:04:23', 4),
('Smooth Jazz', '00:05:10', 4),
('Für Elise', '00:02:57', 5),
('Symphony No. 9', '00:09:35', 5),
('Imagine', '00:03:05', 1),
('Bohemian Rhapsody', '00:05:55', 2),
('Somewhere Over The Rainbow', '00:02:34', 5),
('Enter Sandman', '00:05:31', 2),
('Stay', '00:04:00', 1),
('Everything I Wanted', '00:03:42', 1);

insert into Musics
values




select * from Musics


Create table Playlist
(
 Id int primary key identity,
 MusicId int Foreign key references Musics(Id),
 UserId int Foreign key references Users(Id)
)
INSERT INTO Playlist (MusicId, UserId) VALUES
(1, 1), (2, 1), (3, 1),  -- User 1 Playlist
(4, 2), (5, 2), (6, 2),  -- User 2 Playlist
(7, 3), (8, 3), (9, 3),  -- User 3 Playlist
(10, 4), (11, 4), (12, 4), -- User 4 Playlist
(13, 5), (14, 5), (15, 5); -- User 5 Playlist



create table ArtistTrack
(
Id int primary key identity,
ArtistId int Foreign key references Artists(Id),
MusicId int Foreign key references Musics(Id)
)

INSERT INTO ArtistTrack (ArtistId, MusicId) VALUES
(1, 1), (1, 2), (1, 3),  -- Ed Sheeran
(2, 4), (2, 5), (2, 6),  -- Taylor Swift
(3, 7), (3, 8), (3, 9),  -- Ariana Grande
(4, 10), (4, 11), (4, 12), -- Drake
(5, 13), (5, 14), (5, 15); -- Billie Eilish
insert into ArtistTrack (ArtistId, MusicId) VALUES
(5,16);


--1. Mahnını adını, uzunluğunu, kateqoriyasını, hansı ifaçı tərəfindən oxunulduğunu bildirən sorğunu özündə saxlayan updateable view yazın

create view MusicDetails
as
select m.Name as 'Music Name',
m.Duration as 'Music Duration',
c.Name as 'Category Name',
a.Name as 'Artist Name',
a.Surname as 'Artist SurName'
from Musics as m
join Categories as c
on m.CategoryId = c.Id
join ArtistTrack as at
on at.MusicId = m.Id
join Artists as a
on a.Id = at.ArtistId

--2. Music, User və Category üçün müvafiq olaraq usp_CreateMusic, usp_CreateUser və usp_CreateCategory procedurlarini yazın.
select * from Users
Create procedure usp_CreateMusic( @MusicName nvarchar(40),@Duration time,@CategoryId int)
as
Begin
Insert into Musics(Name, Duration,CategoryId)
values (@MusicName,@Duration,@CategoryId)
end

exec usp_CreateMusic 'Monster', '00:02:58', 2


select * from Users
Create procedure usp_CreateUser
(
@Name nvarchar(40),
@Surname nvarchar(40),
@Username nvarchar(40),
@Password nvarchar(40),
@Gender nvarchar(40)
)
as
begin
Insert into Users(Name,Surname,Username,Password,Gender)
values
(
@Name,
@Surname,
@Username,
@Password,
@Gender
)
end

 exec usp_CreateUser 'Bextiyar', 'Novruzov', 'Proud', 'Password@0000','Male'


select * from Categories
Create procedure usp_CreateCategory(@Name nvarchar(40))
as
begin
insert into Categories(name)	
values
(@Name)
end
exec usp_CreateCategory 'Retro'


--3. Function yazirsiz . Id qebul edir gonderilen Id-li Userin dinlediyi Ifacilarin sayini geriye qaytarir (Ifacilarin sayini mahnilarin yox)
select * from Users
select * from Playlist


create Function GetArtistsCount(@UserId int )
returns int
as
begin
declare @ArtistsCount int
select @ArtistsCount = count(ArtistId)  from Users as u
join Playlist as p
on u.Id = p.UserId
join ArtistTrack as at
on p.MusicId= at.MusicId
where u.Id = @UserId
group by u.Id
return @ArtistsCount 
end
select dbo.GetArtistsCount(3) as 'Artists Count'

--alternative query
create function Get_artists_table(@UserId int)
returns Table
as
return
(
select u.Name as 'Name', u.Surname as 'Surname' , COUNT(at.ArtistId) as 'Artists Count' from  Users as u
join Playlist as p
on u.Id = p.UserId
join ArtistTrack as at
on p.MusicId = at.MusicId
where u.Id = @UserId
group by u.Id,u.Name, u.Surname
)

select * from Get_artists_table(2)

--4. Procedure yazirsiz Id qebul edir hemin Id-li userin playlistinə əlavə etdiyi mahnıların siyahısını çıxarın
create procedure get_playlist(@UserId int)
as
begin
select m.Name as 'Music Names' from Users as u
join Playlist as p
on u.Id = p.UserId
join Musics as m
on p.MusicId = m.Id
where u.Id =@UserId
end
exec get_playlist 2


--5. Mahnıları uzunluğuna görə sıralayın(Order by arashdirin)
--asc
select * from MusicDetails as md
order by md.[Music Duration]

--desc
select * from MusicDetails as md
order by md.[Music Duration] desc

--6. Saytda ən çox mahnı çıxaran ifaçını(ları) seçin (Komek ucun functionlar tapa bilersiz muxtelif cur yazmaq olur)


--v.01
Select top 1 a.name , a.Surname , Count(*) as SongsCount from Musics as m
join ArtistTrack as at
on m.Id = at.MusicId
join Artists as a 
on at.ArtistId = a.Id
Group by a.Id,a.Name,a.Surname
order by SongsCount desc


--v.02
Select a.name , a.Surname , Count(*) as SongsCount from Musics as m
join ArtistTrack as at
on m.Id = at.MusicId
join Artists as a 
on at.ArtistId = a.Id
Group by a.Id,a.Name,a.Surname
having  Count(*) = ( Select Max(SongsCount) from(
Select a.name , a.Surname , Count(*) as SongsCount from Musics as m
join ArtistTrack as at
on m.Id = at.MusicId
join Artists as a 
on at.ArtistId = a.Id
Group by a.Id,a.Name,a.Surname) as ArtistSongsCount)












