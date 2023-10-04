drop table if exists #kr_cr,#kanji_reading_component_map,#phonetic_components_and_others
drop table if exists #t1,#t2,#t3,#words
drop table if exists #kanjivg_kanji_components,#kanji_components,#component_map,#top_comps,#disp_topcomps;
select distinct vg.e element,coalesce(vg1.e,vg2.e,vg3.e,vg4.e,vg5.e,vg6.e,vg7.e,vg8.e,vg9.e,vg.e)component
--,vg.id,vg1.e c,vg1.id,vg2.e c,vg2.id,vg3.e c,vg3.id,vg4.e c,vg4.id,vg5.e c,vg5.id,vg6.e c,vg6.id,vg7.e c,vg7.id,vg8.e c,vg8.id,vg9.e c,vg9.id
into #kanjivg_kanji_components
from kanjidic2_readings_corrected r
--join kanji jouyou on jouyou.kanji=r.literal--uncomment if you only want jouyou
left join kanjivg_breakdown vg  on vg.e=r.literal and vg.lvl=0
left join kanjivg_breakdown vg1 on vg1._id=vg.id                    and vg1.lvl=vg.lvl+1
left join kanjivg_breakdown vg2 on vg2._id=vg1.id and vg1.e is null and vg2.lvl=vg1.lvl+1
left join kanjivg_breakdown vg3 on vg3._id=vg2.id and vg2.e is null and vg3.lvl=vg2.lvl+1
left join kanjivg_breakdown vg4 on vg4._id=vg3.id and vg3.e is null and vg4.lvl=vg3.lvl+1
left join kanjivg_breakdown vg5 on vg5._id=vg4.id and vg4.e is null and vg5.lvl=vg4.lvl+1
left join kanjivg_breakdown vg6 on vg6._id=vg5.id and vg5.e is null and vg6.lvl=vg5.lvl+1
left join kanjivg_breakdown vg7 on vg7._id=vg6.id and vg6.e is null and vg7.lvl=vg6.lvl+1
left join kanjivg_breakdown vg8 on vg8._id=vg7.id and vg7.e is null and vg8.lvl=vg7.lvl+1
left join kanjivg_breakdown vg9 on vg9._id=vg8.id and vg8.e is null and vg9.lvl=vg8.lvl+1
where r.r_type='ja_on'and coalesce(vg1.e,vg2.e,vg3.e,vg4.e,vg5.e,vg6.e,vg7.e,vg8.e,vg9.e,vg.e) is not null
order by 1 , 2

select r.reading,vg.component,element kanji
into #kanji_components from #kanjivg_kanji_components vg
join kanjidic2_readings_corrected r on vg.element=r.literal
--join kanji jouyou on jouyou.kanji=r.literal
where r.r_type='ja_on'
select r.reading,vg.component,count(distinct element)kanji_count,STRING_AGG(element,',')kanji
into #component_map from #kanjivg_kanji_components vg
join kanjidic2_readings_corrected r on vg.element=r.literal
--join kanji jouyou on jouyou.kanji=r.literal
where r.r_type='ja_on'
group by r.reading,vg.component

;with cte2 as(select
component,count(distinct reading)reading_count,sum(kanji_count)kanji_count,replace(STRING_AGG(reading+'('+kanji+')','|')within group (order by kanji_count desc,reading,kanji),'|',' | ')readings_kanji
from #component_map cte
group by component)
,cte3 as(select *,convert(numeric(5,2),kanji_count*1.0/reading_count) score from cte2)
,cte4 as(select * from cte3 /*where score>=3 or cte3.component in(select cte.component from #component_map cte where kanji_count>2)*/)
,cte5 as(select * from cte4 /*where score>=1.5*/)
,cte6 as(select row_number()over (partition by cte.component order by cte.component,cte.kanji_count desc,cte.reading)rn,cte.* from #component_map cte join cte5 on cte5.component=cte.component)
--,cte7 as(select cte6.component,string_agg(cte6.reading+'('+cte6.kanji+')',';')kanji,sum(cte6.kanji_count)kanji_count
--		from (select component,reading,kanji_count from cte6 where rn = 1)a
--		join cte6 on cte6.component=a.component and cte6.kanji_count=1
--		group by cte6.component)
,cte8 as(select cte6.component,cte6.reading,cte6.kanji_count,cte6.kanji
			from (select component,reading,kanji_count from cte6 where rn = 1)a
			join cte6 on cte6.component=a.component --and cte6.kanji_count!=1
		--union all
		--select cte7.component,'except'reading,cte7.kanji_count,cte7.kanji from cte7
		)
,cte9 as(select component,STRING_AGG(reading+'('+convert(varchar(3),kanji_count)+case when reading!='except'then','+left(cte8.kanji,1)else''end+')',';')within group (order by case when reading='except'then 1 else 0 end, kanji_count desc)[reading(number of kanji,example)],sum(kanji_count)kanji_count
from cte8
--new filter, ideally should've been in cte8.. anyway so I'm trying to only get those components whose top reading is at least 10% of total readings
group by component 
--having not exists(select 1 from cte6 where rn = 1 and cte8.component=cte6.component and charindex(cte6.reading,STRING_AGG(cte8.reading,','))>0
--and SUM(cte8.kanji_count)>10*cte6.kanji_count--IDK why commenting this makes query on line 104 give no results
--)
)
--select * into #top_comps from cte8 where reading!='except'--first populate this, then populate #disp_topcomps
select component,kanji_count,
case when [reading(number of kanji,example)] not like'%except%'then '"'+replace([reading(number of kanji,example)],';','||')+'"|(0)'else '"'+replace(replace([reading(number of kanji,example)],';','||'),'||'+'except','"|')end reading
into #disp_topcomps from cte9
order by component,kanji_count desc,[reading(number of kanji,example)]

select distinct k.kanji,k.reading kr,c.component,c.reading cr into #kr_cr
from #kanji_components k 
left join /*#component_map*/#top_comps c on c.component=k.component
order by k.kanji,c.component
--select * from #kanji_components where component =N'票'
--select * from #disp_topcomps


;with cte as(select distinct o.kanji,o.component,case when kr=cr then cr end reading--,kragg,cragg
from #kr_cr o
--join (select i.kanji,string_agg(i.kr,',')within group (order by i.kr)kragg from (select distinct kanji,kr from #kr_cr)i group by i.kanji)kragg on kragg.kanji=o.kanji
--join (select i.component,string_agg(i.cr,',')within group (order by i.cr)cragg from (select distinct component,cr from #kr_cr)i group by i.component)cragg on cragg.component=o.component
--cross apply (select string_agg(kr,',')kragg from #kr_cr i where i.kanji=o.kanji)kragg
--group by kanji,component,case when kr=cr then cr end
)
select distinct literal kanji,r.reading,c.component
,case when cte.component is not null then 'Y' end source_component
--,replace(ltrim(rtrim(replace(replace(kragg+',',isnull(reading+',',''),''),',',' '))),' ',',')kragg
--,replace(ltrim(rtrim(replace(replace(cragg+',',isnull(reading+',',''),''),',',' '))),' ',',')cragg
into #kanji_reading_component_map from
kanjidic2_readings_corrected r join #kanjivg_kanji_components c on c.element=r.literal
left join cte on cte.kanji=r.literal and cte.reading=r.reading and c.component=cte.component
where r_type='ja_on'
order by r.literal,r.reading,c.component
--select * from #kanji_reading_component_map

--select * from #kanji_reading_component_map order by 1,2,3,4
--select m.kanji,m.reading,m.component phonetic_component,c.component other_component
--from #kanji_reading_component_map m
--left join #kanjivg_kanji_components c on c.component_level%10000=0 and c.element=m.kanji
--and not exists (select 1 from #kanji_reading_component_map m2 where m2.kanji=m.kanji and m2.reading=m.reading and c.component=m2.component)
--where c.component is not null
--order by 1,2,3
select m2.component phonetic_component,m1.reading onyomi,m1.component other_component,m1.kanji
into #phonetic_components_and_others
from #kanji_reading_component_map m1
join #kanji_reading_component_map m2 on m2.kanji=m1.kanji and m2.reading=m1.reading and m2.source_component is not null and m2.component!=m1.component
order by 1,2,3,4
--select * from #phonetic_components_and_others x where x.phonetic_component not in
--(select a.phonetic_component from #phonetic_components_and_others a join #phonetic_components_and_others b on b.phonetic_component=a.other_component and b.other_component=a.phonetic_component and a.onyomi!=b.onyomi and a.kanji!=b.kanji)
--order by 1,2,3,4
--select * from #phonetic_components_and_others

--;with cte as(select component,kanji_count,reading from #disp_topcomps
--where component not in 
--(select a.phonetic_component from #phonetic_components_and_others a
--join #phonetic_components_and_others b on b.phonetic_component=a.other_component and b.other_component=a.phonetic_component 
--and a.onyomi!=b.onyomi and a.kanji!=b.kanji)
--)
--,cte2 as(select component,kanji_count,left(reading,charindex('"|(',reading))readings,convert(int,replace(right(reading,len(reading)-charindex('"|(',reading)-2),')',''))exception_count
--from cte)
--select component,readings,kanji_count,exception_count,kanji_count-exception_count [difference],(kanji_count-exception_count)*100.0/kanji_count confidence from cte2
--order by kanji_count-exception_count desc

select dense_rank()over(order by isnull(f.FREQ_BIG_5,9999)/100,phonetic_component,p1.kanji,onyomi)rn,
isnull(f.FREQ_BIG_5,9999)freq,case when k.Kanji is not null then 1 else 0 end joyo,p1.kanji,phonetic_component,onyomi,string_agg(isnull(other_component,''),' ')within group (order by other_component)other_components
into #t1 from #phonetic_components_and_others p1
left join kanji k on k.Kanji=p1.kanji
left join kanji_freqs f on f.literal=p1.kanji
group by isnull(f.FREQ_BIG_5,9999),case when k.Kanji is not null then 1 else 0 end,p1.kanji,phonetic_component,onyomi
--select max(rn) from #t1 where joyo=1 order by rn--7279

select distinct k.keb,r.reb into #words from jmdict_readings r
join jmdict_kanji k on k.ent_seq=r.ent_seq
where (ke_pri1 is not null or ke_pri2 is not null or ke_pri3 is not null or ke_pri4 is not null)and
	(re_pri1 is not null or re_pri2 is not null or re_pri3 is not null or re_pri4 is not null or re_pri5 is not null or re_pri6 is not null)
;with cte as (select distinct kanji
						,onyomi
						,keb+'('+stuff(reb,CHARINDEX(onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS),len(onyomi),onyomi)+')'vocab
						,replace(stuff(keb,CHARINDEX(kanji,keb),len(kanji),'`'),'`',onyomi)
							+'('+stuff(reb,CHARINDEX(onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS),len(onyomi),onyomi)+')'vocab2
						,DENSE_RANK()over(partition by kanji,onyomi order by len(keb),len(reb),keb,reb)rn from #t1
				join #words on charindex(kanji,keb)>0 and kanji!=keb and
				CHARINDEX(onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS)=charindex(kanji,keb)
				)
select kanji,onyomi,string_agg(vocab,'|') vocab,string_agg(vocab2,'|') vocab2 into #t2 from cte where rn=1 group by kanji,onyomi

select #t1.phonetic_component,#t1.onyomi
,STRING_AGG(#t1.kanji,'|')within group (order by #t2.vocab desc,rn) kanji
,STRING_AGG(isnull(#t2.vocab,'-'),'|')within group (order by #t2.vocab desc,rn) vocab
,STRING_AGG(isnull(#t2.vocab2,'-'),'|')within group (order by #t2.vocab desc,rn) vocab2
into #t3 from #t1 left join #t2 on #t1.kanji=#t2.kanji and #t1.onyomi=#t2.onyomi
group by phonetic_component,#t1.onyomi
order by 1

;with cte as (select *,len(vocab)-len(replace(vocab,'|',''))+1 kanjicount,len(vocab)-len(replace(vocab,'-',''))without_examples_count from #t3)
,cte2 as(select convert(numeric(3,2),((kanjicount-without_examples_count)*1.0)/kanjicount)pct_good,* from cte)
,cte3 as(select sum(pct_good*kanjicount)/sum(kanjicount)pct_good,phonetic_component from cte2
		group by phonetic_component having /*sum(pct_good*kanjicount)/sum(kanjicount)>=0.33 and*/ count(distinct onyomi)<=6)
select cte3.pct_good pct_good_percomponent,cte2.pct_good pct_good_peronyomi,cte2.phonetic_component,cte2.onyomi,'"'+cte2.kanji+'"'kanji,'"'+cte2.vocab+'"'vocab,'"'+cte2.vocab2+'"'vocab2
from cte2 join cte3 on cte2.phonetic_component=cte3.phonetic_component
where cte2.kanjicount>2 --and cte2.pct_good>=0.33
order by cte3.pct_good desc,cte2.phonetic_component,cte2.pct_good desc,cte2.onyomi
--select * from cte2 where phonetic_component in(N'㇐',N'一')