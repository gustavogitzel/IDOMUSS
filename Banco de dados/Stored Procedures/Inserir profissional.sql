USE [Indomuss]
GO
/****** Object:  StoredProcedure [dbo].[cadastroProfissional_sp]    Script Date: 04/05/2020 21:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[cadastroProfissional_sp]
@rg char(9) = null,
@cpf char(11) = null,
@cnpj char(14) = null,
@nome varchar(50) = null,
@email varchar(60) = null,
@cep char(8) = null,
@numeroCelular char(15) = null,
@dataNascimento date = null,
@genero varchar(20) = null,
@querGenero bit = null,
@descricao ntext = null,
@foto ntext = null,
@senha varchar(max) = null,
@nomeServico varchar(50) = null
as
begin
if(@nomeServico is not null and @cnpj is not null and @cep is not null and @nome is not null and @senha is not null and @email is not null and @rg is not null and @numeroCelular is not null and @dataNascimento is not null and @genero is not null and @descricao is not null and @foto is not null and @querGenero is not null)
begin 
	if not exists (select * from Profissional where email = @email or rg = @rg or cpf = @cpf)
	begin
		insert into Profissional values(@rg, @cpf, @cnpj, @nome, @email, @cep, @numeroCelular, @dataNascimento, @genero, CAST(@querGenero as binary), hashbytes('md5', @senha), @descricao, @foto,
									(select idServico from Servico where nome = @nomeServico))

		select * from Profissional where email = @email and senha = @senha
	end
end
end