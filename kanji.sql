--SELECT * FROM kanji_strokes
--SELECT * FROM kanji_rad_config--https://i.pinimg.com/originals/80/31/94/803194d7c854c1ae7839ee991c93d8c2.jpg
--SELECT * FROM kanji_radicals
--SELECT * FROM kanji
--SELECT * FROM kanji_readings
--SELECT * FROM kanji_meanings
/*
update kanji_radical_map set radical_kana='     '

update k
set radical_kana=replace(replace(k.radical collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS,'oo','ou') collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS,h.en,h.jp)collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS
from kanji_radical_map k
join hiragana h on charindex(h.en,replace(k.radical collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS,'oo','ou'))>0
where h.replace_priority=3 and radical_kana='     '
select * from kanji_radical_map 


update k
set radical_kana=replace(replace(k.radical_kana collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS,'oo','ou') collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS,h.en,h.jp)collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS
from kanji_radical_map k
join hiragana h on charindex(h.en,replace(k.radical_kana collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS,'oo','ou'))>0
where h.replace_priority=3-- and radical_kana='     '
--select * from kanji_radical_map where radical_kana='     '
select * from kanji_radical_map where radical_kana like'%[a-Z]%'
*/
/*--SELECT * FROM sys.fn_helpcollations() WHERE (1=1) AND description LIKE '%kanatype-insensitive%' AND name LIKE '%japanese%' 
;with katakana as(select b10-12449 kananum,b10 unicodes,nchar(b10)collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS kana from numbers_64k where b10 between 12449 and 12532)
,hiragana as(select b10-12353 kananum,b10 unicodes,nchar(b10)collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS kana from numbers_64k where b10 between 12353 and 12436)
,readings as(--select * from hiragana h join katakana k on h.kananum=k.kananum order by 1
select id kanji_id,kanji,reading,1 joyo_bit,
case when exists (select 1 from katakana where CHARINDEX(kana,reading)>0) then 'on'
when exists (select 1 from hiragana where CHARINDEX(kana,reading)>0) then 'kun'end yomi
from kanji 
cross apply (select replace(replace(value,N'[',''),N']','') collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS reading from string_split(reading_within_joyo,N'、'))as readings
union all
select id,kanji,reading,0 joyo_bit,
case when exists (select 1 from katakana where CHARINDEX(kana,reading)>0) then 'kun'
when exists (select 1 from hiragana where CHARINDEX(kana,reading)>0) then 'on'end yomi
from kanji 
cross apply (select value collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS reading from string_split(reading_beyond_Joyo,N'、'))as readings
)select 
ROW_NUMBER()over(partition by reading collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS order by joyo_bit desc,yomi desc,kanji_id )kanjibyreadings,kanji_id,
ROW_NUMBER()over(partition by kanji_id order by joyo_bit desc,yomi desc,reading)readingsbykanji,kanji,reading,joyo_bit,yomi
into kanji_readings
from readings
order by kanji_id,joyo_bit desc,yomi desc,readingsbykanji*/
--select * from hiragana where verb_ending_bit=1
--update k set k.grammar= case when h.jp in (N'う',N'つ')then N'Verb (Godan>うつる)'
--when h.jp in (N'ぬ',N'ぶ',N'む')then N'Verb (Godan>ぬぶむ)'
--when h.jp in (N'す')then N'Verb (Godan>す)'
--when h.jp in (N'く',N'ぐ')then N'Verb (Godan>くぐ)'
--when h.jp = N'る' and notirueru.jp is not null then N'Verb (Godan>うつる)'
--when h.jp = N'る' and notirueru.jp is null then N'Verb'
--end--,k.reading,h.jp,notirueru.jp
--from kanji_readings k
--join hiragana h on right(k.reading,1)collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS=h.jp collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS
--left join 
--hiragana notirueru 
--on right(
--		left(
--			replace(k.reading,N'-','')
--			,len(replace(k.reading,N'-',''))-1)
--	,len(notirueru.jp))=notirueru.jp and notirueru.vowel_group not in (N'い',N'え') and h.jp=N'る'
--where h.verb_ending_bit=1 and CHARINDEX(N'-',reading collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS)>0
--and k.grammar is null
--update k set grammar =N'Adjective (い)'
--select * from kanji_readings k where reading like N'%-%' and grammar is null and right(reading,1)!=N'い'
--order by reading
--select * from kanji_readings
/*
select kanji_id,kanji,meaning,STRING_AGG(yomi,'/') within group (order by yomi desc) yomi 
into kanji_meanings
from 
(
select id kanji_id,kanji,meaning,'Kun'yomi,Translation_of_Kun tl from kanji
cross apply (select nullif(nullif(ltrim(rtrim(replace(value,'|','.'))),N'-'),'')  meaning 
			from string_split(replace(replace(
						replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
						replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(Translation_of_Kun,'number (1, 2, 3, etc.)','number (1 2 3 etc)'),', etc.',' etc|'),'etc.','etc|'),'neg.','neg|'),'Mr.','Mr|'),'Messrs.','Messrs|'),'Mrs.','Mrs|'),'Mme.','Mme|'),'oz.','oz|'),'yds.','yds|'),'(c.','(c|'),'U.S.','US')
						,'8.3','8|3'),'1.1','1|1'),'a.m.','am'),'p.m.','pm'),'1.8','1|8'),'4.96','4|96'),'number (1, 2, 3, ','number (1 2 3 '),'N.B.','NB'),'2.45','2|45'),'4.8','4|8'),'U.S.A','USA'),'2.44','2|44'),'.245','|245'),'0.1325','0|1325'),'(contracts, treaties, and friendships)','(contracts treaties and friendships)'),'time, latitude, degree','time/latitude/degree')
							,'.',','),';',','),N','))as meanings
where meaning is not null
union all
select id kanji_id,kanji,meaning,'On'yomi,Translation_of_On tl from kanji
cross apply (select nullif(nullif(ltrim(rtrim(replace(value,'|','.'))),N'-'),'')  meaning 
			from string_split(replace(replace(
						replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
						replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(Translation_of_On,'number (1, 2, 3, etc.)','number (1 2 3 etc)'),', etc.',' etc|'),'etc.','etc|'),'neg.','neg|'),'Mr.','Mr|'),'Messrs.','Messrs|'),'Mrs.','Mrs|'),'Mme.','Mme|'),'oz.','oz|'),'yds.','yds|'),'(c.','(c|'),'U.S.','US')
						,'8.3','8|3'),'1.1','1|1'),'a.m.','am'),'p.m.','pm'),'1.8','1|8'),'4.96','4|96'),'number (1, 2, 3, ','number (1 2 3 '),'N.B.','NB'),'2.45','2|45'),'4.8','4|8'),'U.S.A','USA'),'2.44','2|44'),'.245','|245'),'0.1325','0|1325'),'(contracts, treaties, and friendships)','(contracts treaties and friendships)'),'time, latitude, degree','time/latitude/degree')
							,'.',','),';',','),N','))as meanings
where meaning is not null
)as a
group by kanji_id,kanji,meaning
order by len(meaning),3
*/
--alter table kanji_meanings add meaning_id int, kanjibymeaning int
--select dense_rank()over (order by len(meaning)-len(replace(meaning,' ','')),replace(meaning,'(',''))meaning_id,
--ROW_NUMBER()over(partition by meaning order by len(meaning)-len(replace(meaning,' ','')),replace(meaning,'(',''),yomi desc,kanji_id)kanjibymeaning,
--kanji,kanji_id,yomi,meaning
--into #cte from kanji_meanings order by len(meaning)-len(replace(meaning,' ','')),replace(meaning,'(',''),yomi desc,kanji_id
--update a set a.meaning_id=cte.meaning_id,a.kanjibymeaning=cte.kanjibymeaning from kanji_meanings a join #cte cte on cte.kanji_id=a.kanji_id and cte.meaning=a.meaning and cte.yomi=a.yomi and a.kanji=cte.kanji
--select row_number()over(order by meaning_id,kanjibymeaning)sr_no,meaning,kanji,yomi from kanji_meanings
--select distinct radical, '                         ' collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS radical_kana,radical_freq,strokes,symmetry,id kanji_id,kanji into kanji_radical_map from kanji
--cross apply (select ltrim(rtrim(value))radical from string_split(Name_of_Radical,','))a
--order by 1,2,3,4
--SELECT CONVERT(XML,MY_XML,2)xmldata into kanjidic2
--     FROM OPENROWSET(BULK 'F:\art\languages\kanjidic2.xml', SINGLE_BLOB) AS T(MY_XML)) AS T(MY_XML)
--INSERT INTO kanjidic2_test
--(literal
----,/*codepoint*/cp_value,/*@*/cp_type/*(ucs and jis208)*/
----,/*radical*/rad_value,/*@*/rad_type
--/*misc*/,grade,stroke_count/*,variant,/*@*/var_type*/,freq,jlpt/*,rad_name*/
----/*dic_number*/,dic_ref,/*@*/dr_type,/*@*/m_vol,/*@*/m_page
----/*query_code*/,q_code,/*@*/qc_type,skip_misclass
----/*reading_meaning,rmgroup*/,reading,/*@*/r_type,meaning,/*@*/m_lang
----,nanori
--)
--SELECT
--   MY_XML.characters.query('literal').value('.', 'NVARCHAR(2)')literal,
--   MY_XML.characters.query('misc/grade').value('.', 'INT')grade,
--   MY_XML.characters.query('misc/stroke_count').value('.', 'INT')stroke_count
--INTO kanjidic2_literals
--FROM kanjidic2
--CROSS APPLY xmldata.nodes('kanjidic2/character') AS MY_XML (characters);
--;with cte as(select kanjidic2,header,file_version,database_version,date_of_creation,character,literal,codepoint,cp_value,cp_type,radical,rad_value,rad_type,misc,grade,stroke_count,variant,var_type,freq,jlpt,rad_name,dic_number,dic_ref,dr_type,m_vol,m_page,query_code,q_code,qc_type,skip_misclass,reading_meaning,rmgroup,reading,r_type,meaning,m_lang,nanori
--from [kanjidic2_pt1.xml.xlsx - Sheet1]
--union all
--select kanjidic2,header,file_version,database_version,date_of_creation,character,literal,codepoint,cp_value,cp_type,radical,rad_value,rad_type,misc,grade,stroke_count,variant,var_type,freq,jlpt,rad_name,dic_number,dic_ref,dr_type,m_vol,m_page,query_code,q_code,qc_type,skip_misclass,reading_meaning,rmgroup,reading,r_type,meaning,m_lang,nanori
--from [kanjidic2_pt2.xml.xlsx - Sheet1]
--)
--,cte2 as(select distinct literal,cp_type,isnull(cp_value,'')cp_value from cte)
--select * into kanjidic2_codepoints from
--cte2
--pivot(
--min(cp_value) for cp_type in ([jis208],[jis212],[jis213],[ucs])
--)as p
--;with cte as(select kanjidic2,header,file_version,database_version,date_of_creation,character,literal,codepoint,cp_value,cp_type,radical,rad_value,rad_type,misc,grade,stroke_count,variant,var_type,freq,jlpt,rad_name,dic_number,dic_ref,dr_type,m_vol,m_page,query_code,q_code,qc_type,skip_misclass,reading_meaning,rmgroup,reading,r_type,meaning,m_lang,nanori
--from [kanjidic2_pt1.xml.xlsx - Sheet1]
--union all
--select kanjidic2,header,file_version,database_version,date_of_creation,character,literal,codepoint,cp_value,cp_type,radical,rad_value,rad_type,misc,grade,stroke_count,variant,var_type,freq,jlpt,rad_name,dic_number,dic_ref,dr_type,m_vol,m_page,query_code,q_code,qc_type,skip_misclass,reading_meaning,rmgroup,reading,r_type,meaning,m_lang,nanori
--from [kanjidic2_pt2.xml.xlsx - Sheet1]
--)--select distinct rad_type from cte
--,cte2 as(select distinct literal,rad_type,isnull(rad_value,'')rad_value from cte)
--select distinct * into kanjidic2_radicals 
--from
--cte2
--pivot(
--min(rad_value) for rad_type in ([classical],[nelson_c])
--)as p
--
--;with cte as(select kanjidic2,header,file_version,database_version,date_of_creation,character,literal,codepoint,cp_value,cp_type,radical,rad_value,rad_type,misc,grade,stroke_count,variant,var_type,freq,jlpt,rad_name,dic_number,dic_ref,dr_type,m_vol,m_page,query_code,q_code,qc_type,skip_misclass,reading_meaning,rmgroup,reading,r_type,meaning,m_lang,nanori
--from [kanjidic2_pt1.xml.xlsx - Sheet1]
--union all
--select kanjidic2,header,file_version,database_version,date_of_creation,character,literal,codepoint,cp_value,cp_type,radical,rad_value,rad_type,misc,grade,stroke_count,variant,var_type,freq,jlpt,rad_name,dic_number,dic_ref,dr_type,m_vol,m_page,query_code,q_code,qc_type,skip_misclass,reading_meaning,rmgroup,reading,r_type,meaning,m_lang,nanori
--from [kanjidic2_pt2.xml.xlsx - Sheet1]
--)
--,cte2 as(select distinct literal,variant,var_type from cte)
--select *
--from cte2
--pivot(
--min(variant) for var_type in ([oneill],[deroo],[njecd],[jis213],[nelson_c],[s_h],[ucs],[jis208],[jis212])
--)as p
--;with cte as
--(
--select kanjidic2,header,file_version,database_version,date_of_creation,character,literal,codepoint,cp_value,cp_type,radical,rad_value,rad_type,misc,grade,stroke_count,variant,var_type,freq,jlpt,rad_name,dic_number,dic_ref,dr_type,m_vol,m_page,query_code,q_code,qc_type,skip_misclass,reading_meaning,rmgroup,reading,r_type,meaning,m_lang,nanori
--from [kanjidic2_pt1.xml.xlsx - Sheet1]
--union all
--select kanjidic2,header,file_version,database_version,date_of_creation,character,literal,codepoint,cp_value,cp_type,radical,rad_value,rad_type,misc,grade,stroke_count,variant,var_type,freq,jlpt,rad_name,dic_number,dic_ref,dr_type,m_vol,m_page,query_code,q_code,qc_type,skip_misclass,reading_meaning,rmgroup,reading,r_type,meaning,m_lang,nanori
--from [kanjidic2_pt2.xml.xlsx - Sheet1]
--)
--,cte2 as
--(
--select distinct literal,dic_ref,dr_type,m_vol,m_page from cte
--)--select distinct m_vol from cte2 
--select * into kanjidic2_dic_refs
--from cte2
--order by 1--similar logic was used for-> select * from kanjidic2_query_codes
--/*reading_meaning,rmgroup*/,reading,/*@*/r_type,meaning,/*@*/m_lang
--;with cte as
--(
--select kanjidic2,header,file_version,database_version,date_of_creation,character,literal,codepoint,cp_value,cp_type,radical,rad_value,rad_type,misc,grade,stroke_count,variant,var_type,freq,jlpt,rad_name,dic_number,dic_ref,dr_type,m_vol,m_page,query_code,q_code,qc_type,skip_misclass,reading_meaning,rmgroup,reading,r_type,meaning,m_lang,nanori
--from [kanjidic2_pt1.xml.xlsx - Sheet1]
--union all
--select kanjidic2,header,file_version,database_version,date_of_creation,character,literal,codepoint,cp_value,cp_type,radical,rad_value,rad_type,misc,grade,stroke_count,variant,var_type,freq,jlpt,rad_name,dic_number,dic_ref,dr_type,m_vol,m_page,query_code,q_code,qc_type,skip_misclass,reading_meaning,rmgroup,reading,r_type,meaning,m_lang,nanori
--from [kanjidic2_pt2.xml.xlsx - Sheet1]
--)
--,cte2 as
--(
--select distinct literal,reading,r_type,meaning,m_lang from cte
--)--select distinct r_type from cte2 order by 1
--,cte3 as(select distinct literal,ja_kun,ja_on,meaning
--from cte2
--pivot(
--min(reading)for r_type in ([ja_kun],[ja_on])
--)as p)
--select literal,ja_kun collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS ja_kun,ja_on collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS ja_on,STRING_AGG(convert(nvarchar(max),meaning),'|') within group (order by meaning)meanings
--into kanjidic2_readings from cte3 group by literal,ja_kun,ja_on
--select literal,ja_kun,ja_on,meaning into kanjidic2_meanings from kanjidic2_readings
--cross apply (select value meaning from string_split(meanings,'|'))a
--insert into kanji_radicals_et_elements
--select distinct radkfile.kanji,radkfile.radical,radkfile.jis_code better_alts_jis_code,stroke_count,'radkfile'
--from radkfile
--left join kradfile on radkfile.kanji=kradfile.kanji and radkfile.radical=kradfile.radicals
--where kradfile.kanji is null and kradfile.radicals is null
--union
--select distinct kradfile.kanji,kradfile.radicals,radkfile.jis_code better_alts_jis_code,stroke_count,'kradfile'
--from kradfile
--left join radkfile on radkfile.kanji=kradfile.kanji and radkfile.radical=kradfile.radicals
--where radkfile.kanji is null and radkfile.radical is null
--union
--select distinct radkfile.kanji,radkfile.radical,radkfile.jis_code better_alts_jis_code,stroke_count,'kradradk'
--from radkfile
--join kradfile on radkfile.kanji=kradfile.kanji and radkfile.radical=kradfile.radicals
--order by stroke_count,radical,kanji
--;with cte as(select kr.radicals,r.ja_on,count(distinct kr.kanji) kanji_count
--from kanji_radicals_et_elements kr
--join kanjidic2_readings r on kr.kanji=r.literal
--group by kr.radicals,r.ja_on having r.ja_on is not null)
--,radkanjicount as(select radicals,sum(kanji_count)total_kanji from cte group by radicals)--select * from radkanjicount
--,onkanjicount as(select ja_on,sum(kanji_count)total_kanji from cte group by ja_on)
--select cte.radicals,cte.ja_on,convert(numeric(6,3),(cte.kanji_count*100.0)/r.total_kanji) given_rad_chance_of_on,convert(numeric(6,3),(cte.kanji_count*100.0)/o.total_kanji) given_on_chance_of_rad
----,cte.kanji_count,r.total_kanji,o.total_kanji
--from cte
--left join radkanjicount r on r.radicals=cte.radicals
--left join onkanjicount o on o.ja_on=cte.ja_on
----where cte.radicals=N'十'
--order by 1,3 desc,2,4 desc
----order by 4 desc,2,3 desc,1
declare @cutoff int = 10
;with cte as(select kr.radicals,r.ja_on,count(distinct kr.kanji) kanji_count,left(STRING_AGG(kr.kanji,'')within group (order by kr.stroke_count,kr.kanji),5)examples
from kanji_radicals_et_elements kr
join kanjidic2_readings r on kr.kanji=r.literal
group by kr.radicals,r.ja_on having r.ja_on is not null)
,radkanjicount as(select radicals,sum(kanji_count)total_kanji from cte group by radicals)--select * from radkanjicount
,onkanjicount as(select ja_on,sum(kanji_count)total_kanji from cte group by ja_on)
,cte2 as(select cte.radicals,cte.ja_on,cte.kanji_count,examples,convert(numeric(6,3),(cte.kanji_count*100.0)/r.total_kanji) given_rad_chance_of_on,convert(numeric(6,3),(cte.kanji_count*100.0)/o.total_kanji) given_on_chance_of_rad
--,cte.kanji_count,r.total_kanji,o.total_kanji
from cte
left join radkanjicount r on r.radicals=cte.radicals
left join onkanjicount o on o.ja_on=cte.ja_on
--order by 1,3 desc,2,4 desc
--order by 4 desc,2,3 desc,1
)
,cte3 as(select SUM(given_on_chance_of_rad) OVER (PARTITION BY ja_on ORDER BY given_on_chance_of_rad /*important*/desc,radicals)sum_given_on_chance_of_rad
	  ,SUM(given_rad_chance_of_on) OVER (PARTITION BY radicals ORDER BY given_rad_chance_of_on /*important*/desc,ja_on)sum_given_rad_chance_of_on
	  ,* from cte2
--order by radicals,sum_given_rad_chance_of_on,ja_on,sum_given_on_chance_of_rad
)
,prunedbyrad as (select radicals,max(sum_given_rad_chance_of_on)cutoff from cte3 where given_rad_chance_of_on>=@cutoff or (sum_given_rad_chance_of_on<=50) group by radicals having count(distinct ja_on)<=(100*1.0)/@cutoff)
,prunedbyon as (select ja_on,max(sum_given_on_chance_of_rad)cutoff from cte3 where given_on_chance_of_rad>=@cutoff or (sum_given_on_chance_of_rad<=50) group by ja_on having count(distinct radicals)<=(100*1.0)/@cutoff)
,radicals_with_yomi_pattern as (select r.radicals,r.ja_on,given_rad_chance_of_on from cte3 r join prunedbyrad p on r.radicals=p.radicals and r.sum_given_rad_chance_of_on<=cutoff)
,yomi_with_radical_pattern as (select o.ja_on,o.radicals,given_on_chance_of_rad from cte3 o join prunedbyon p on o.ja_on=p.ja_on and o.sum_given_on_chance_of_rad<=cutoff)
,yomi_and_radical_pattern as 
	(select cte3.ja_on,cte3.radicals,cte3.given_on_chance_of_rad,cte3.given_rad_chance_of_on,cte3.examples from cte3 
	left join prunedbyon o on cte3.ja_on=o.ja_on 
	left join prunedbyrad r on cte3.radicals=r.radicals and cte3.sum_given_rad_chance_of_on<=r.cutoff
	where (cte3.sum_given_on_chance_of_rad<=o.cutoff or cte3.sum_given_rad_chance_of_on<=r.cutoff))
select * from yomi_and_radical_pattern
