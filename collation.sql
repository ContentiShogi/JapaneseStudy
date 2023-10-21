select 'alter table '+OBJECT_NAME(object_id)+' alter column '+c.name+' '+t.name+'('+convert(nvarchar(5),c.max_length)+') collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS'
+';
go'
from sys.columns c
join sys.types t on t.user_type_id=c.user_type_id
where 
--c.collation_name='Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS'and 
object_name(object_id)='jmdict_separated_charas'and c.name like'cr%'
order by OBJECT_NAME(object_id),c.name
