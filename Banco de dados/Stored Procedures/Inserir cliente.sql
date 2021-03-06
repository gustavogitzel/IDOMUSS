USE [Indomuss]
GO
/****** Object:  StoredProcedure [dbo].[cadastroCliente_sp]    Script Date: 04/05/2020 21:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cadastroCliente_sp]
@rg char(9) = null,
@cpf char(11) = null,
@nome varchar(50) = null,
@email varchar(60) = null,
@numeroCelular char(15) = null,
@dataNascimento date = null,
@genero varchar(20) = null,
@querGenero bit = null,
@descricao ntext = null,
@foto ntext = null,
@senha varchar(max) = null
as
begin
if(@nome is not null and @senha is not null and @email is not null and @rg is not null and @numeroCelular is not null and @dataNascimento is not null and @genero is not null and @descricao is not null and @foto is not null and @querGenero is not null)
begin 
	if not exists (select * from Cliente where email = @email or rg = @rg or cpf = @cpf)
	begin
		insert into Cliente values(@rg, @cpf, @nome, @email, @numeroCelular, @dataNascimento, @genero, CAST(@querGenero as binary), hashbytes('md5', @senha), @descricao, @foto)
		select nome, email from Cliente where email = @email and senha = @senha
	end
end
end