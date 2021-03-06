/****** Object:  UserDefinedFunction [dbo].[fnDelimiter_To_Table]    Script Date: 11/21/2016 9:44:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnDelimiter_To_Table] (
        @id             int,
        @String varchar(8000), 
        @Delimiter char(1)
)       
returns @temptable TABLE (id int, items varchar(128))       
as       
begin       
    declare @idx int       
    declare @slice varchar(8000)       
      
    select @idx = 1       
        if len(@String)<1 or @String is null  return       
      
    while @idx!= 0       
    begin       
        set @idx = charindex(@Delimiter,@String)       
        if @idx!=0       
            set @slice = left(RTRIM(LTRIM(@String)),@idx - 1)       
        else       
            set @slice = RTRIM(LTRIM(@String))
          
            insert into @temptable(id, Items) values(@id, @slice)       
  
        set @String = right(@String,len(@String) - @idx)       
        if len(@String) = 0 break       
    end   
return       
end  


GO
