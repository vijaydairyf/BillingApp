/****** Object:  UserDefinedFunction [dbo].[udf_GetApplicationURL]    Script Date: 11/21/2016 9:44:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_GetApplicationURL] ()
RETURNS varchar(255)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result varchar(255)

	SET @result = CASE DB_NAME() 
			WHEN 'ScreeningONE' THEN 
					CASE @@SERVERNAME
						WHEN 'S1-TPA-DV1\DBDV2' THEN 'http://localhost:53081'
						ELSE 'https://www.screeningone.com'
					END 
		END

	RETURN ISNULL(@result, 'ScreeningONE');
END

GO
