USE [Indomuss]
GO
/****** Object:  StoredProcedure [dbo].[acessoCliente_sp]    Script Date: 04/05/2020 21:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[acessoCliente_sp]
@email varchar(60) = null,
@senha varchar(max) = null
as
begin
if(@email is not null and @senha is not null)
begin 
	set @senha = HASHBYTES('md5', @senha)
	if exists (select * from Cliente where email = @email and senha = @senha)
	begin
		insert into HistoricoDeAcessoCliente values(GetDate(), (select idCliente from Cliente where email = @email))
		select * from Cliente where email = @email
	end
end	
end