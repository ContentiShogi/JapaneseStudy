/*;with cte as (select * from kanji_radicals_et_elements where radicals not in
(N'결',N'경',N'곗',N'괬',N'괴',N'굇',N'굳',N'기',N'꺅',N'껀',N'껄',N'껨',N'꼇',N'꼍',N'꽥',N'꾄',N'꿰',N'난',N'넘',N'네',N'뇨',N'뇬',N'눴',N'늚',N'늬',N'뎬',N'도',N'둔',N'뒀',N'뒤',N'뒵',N'듯',N'디',N'따',N'뚝',N'뚤',N'뜯',N'뜹',N'루',N'룰',N'룹',N'룽',N'륵',N'릊',N'링',N'맑',N'맛',N'맹',N'멓',N'메',N'모',N'뫙',N'묩',N'밋',N'밞',N'밟',N'뱝',N'범',N'벗',N'볍',N'빡',N'뺍',N'뺙',N'뾔',N'뿍',N'쁑',N'삐',N'삔',N'삣',N'산',N'새',N'섀',N'섄',N'섈',N'섐',N'섞',N'솔',N'쇨',N'숍',N'쉰',N'슬',N'슷',N'썽',N'쏴',N'쒜',N'쒼',N'엣',N'여',N'였',N'올',N'옴',N'옵',N'와',N'욕',N'웰',N'웸',N'으',N'읍',N'읕',N'읗',N'읽',N'있',N'장',N'쟀',N'정',N'죌',N'지',N'짯',N'쭹',N'채',N'챘',N'쵸',N'췸',N'캣',N'캥',N'콤',N'큉',N'탠',N'터',N'텔',N'텼',N'튐',N'팰',N'팻',N'폐',N'폰',N'폽',N'퐁',N'풩',N'플',N'하',N'허',N'헷',N'혠',N'훑',N'훵',N'흑',N'흗',N'흴',N'흼',N'',N'',N'')
)
select kr.radicals+isnull(kr2.radicals,'')
		+isnull(kr3.radicals,'')
		+isnull(kr4.radicals,'')
		+isnull(kr5.radicals,'')
		+isnull(kr6.radicals,'')
		+isnull(kr7.radicals,'')
		+isnull(kr8.radicals,'')
		+isnull(kr9.radicals,'')
		+isnull(kr10.radicals,'')
		radicals
		,r.ja_on,count(distinct r.literal) kanji_count,left(STRING_AGG(r.literal,'')within group (order by len(r.meanings),r.literal),5)examples
into radical_onyomi_complete_map
from cte kr
join kanjidic2_readings r on kr.kanji=r.literal and r.ja_on is not null
left join cte kr2 on kr2.radicals>kr.radicals and kr.kanji=kr2.kanji
left join cte kr3 on kr3.radicals>kr2.radicals and kr2.kanji=kr3.kanji
left join cte kr4 on kr4.radicals>kr3.radicals and kr.kanji=kr4.kanji
left join cte kr5 on kr5.radicals>kr4.radicals and kr.kanji=kr5.kanji
left join cte kr6 on kr6.radicals>kr5.radicals and kr.kanji=kr6.kanji
left join cte kr7 on kr7.radicals>kr6.radicals and kr.kanji=kr7.kanji
left join cte kr8 on kr8.radicals>kr7.radicals and kr.kanji=kr8.kanji
left join cte kr9 on kr9.radicals>kr8.radicals and kr.kanji=kr9.kanji
left join cte kr10 on kr10.radicals>kr9.radicals and kr.kanji=kr10.kanji
group by 
kr.radicals+isnull(kr2.radicals,'')
+isnull(kr3.radicals,'')
+isnull(kr4.radicals,'')
+isnull(kr5.radicals,'')
+isnull(kr6.radicals,'')
+isnull(kr7.radicals,'')
+isnull(kr8.radicals,'')
+isnull(kr9.radicals,'')
+isnull(kr10.radicals,'')
,r.ja_on
*/

declare @cutoff int = 10,@cutoff2 int = 5
;with cte as (select * from radical_onyomi_complete_map m where exists (select 1 from radical_onyomi_complete_map m1 where m1.radicals=m.radicals and m1.ja_on=m.ja_on group by m1.radicals,m1.ja_on having sum(m1.kanji_count)>=@cutoff2))
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
select p.radicals,/*ex.better_alts_jis_code,*/p.ja_on,p.given_rad_chance_of_on,p.given_on_chance_of_rad,p.examples
into yomi_and_radical_pattern
from yomi_and_radical_pattern p
--left join kanji_radicals_et_elements ex on ex.radicals=p.radicals
--select * from yomi_and_radical_pattern
