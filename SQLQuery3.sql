USE [X_Messenger]
GO
/****** Object:  StoredProcedure [dbo].[Registration]    Script Date: 01.05.2023 16:57:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Registration] 
	@NICKNAME nvarchar(50), 
	@LOGIN nvarchar(30), 
	@PASS nvarchar(64)
as
begin
	begin try
		DECLARE @ID INT = (isnull((select max(Users.UserID) from Users),1) + 1);
		insert into Users values (@ID, @NICKNAME, @LOGIN, @PASS, NULL, NULL) 
		return @ID;
	end try
	begin catch
		return -1;
	end catch
end

go
create procedure [Authorization] 
	@LOGIN nvarchar(30),
	@PASS nvarchar(64)
as
begin
	declare @id int = -1;
	declare users cursor local for select UserID from Users where @LOGIN = [Login] and @PASS = [Password];

	open users
		fetch users into @id;

		if @@FETCH_STATUS < 0
			set @id = -1;
	close users

	return @id;
end

select * from Users

declare @r Int;
exec @r = [Registration] @NICKNAME = 'Dl' , @LOGIN = '1223', @PASS = '123456789'
print @r
