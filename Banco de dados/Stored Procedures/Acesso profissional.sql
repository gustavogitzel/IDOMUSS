USE [Indomuss]
GO
/****** Object:  StoredProcedure [dbo].[acessoProfissional_sp]    Script Date: 04/05/2020 21:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[acessoProfissional_sp]
@email varchar(60) = null,
@senha varchar(max) = null
as
begin
if(@email is not null and @senha is not null)
begin 
	set @senha = HASHBYTES('md5', @senha)
	if exists (select * from Profissional where email = @email and senha = @senha)
	begin
		insert into HistoricoDeAcessoProfissional values(GetDate(), (select idProfissional from Profissional where email = @email))
		select * from Profissional where email = @email
	end
end	
end
