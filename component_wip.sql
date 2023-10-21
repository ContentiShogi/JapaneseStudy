--c-r-k
drop table if exists #cmp_read_kanji_basic,#cmp_read_kanji_enh_temp,#cmp_read_kanji_enh_phon_freq
--c
drop table if exists #cmp_basic,#cmp_enh,#common_vocab
--c-k
drop table if exists #cmp_kanji;
--r-k
drop table if exists #read_kanji_enh_commonvocab
--c-r
drop table if exists #cmp_read_basic,#cmp_read_enh0_vocab,#cmp_read_enh1_vocab,#cmp_read_enh2_vocab,#temp_cmp_enh,#cmp_read_enh3_vocab,#cmp_read_disp


select distinct vg.e element,coalesce(vg1.e,vg2.e,vg3.e,vg4.e,vg5.e,vg6.e,vg7.e,vg8.e,vg9.e,vg.e)component
		,convert(nvarchar(20),'' collate Japanese_Bushu_Kakusu_140_CI_AI_KS_WS_VSS)other_component
into #cmp_kanji
	from kanjidic2_readings_corrected r
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
	update a set a.other_component=isnull(replace(b.other_component,a.component,''),'')
	from #cmp_kanji a
	cross apply(select STRING_AGG(b.component,'')within group(order by b.component)other_component from #cmp_kanji b where b.component!=b.element and b.element=a.element)b
	insert into #cmp_kanji
	select distinct element as element,element,'' as component from #cmp_kanji c1 where not exists (select 1 from #cmp_kanji c2 where c1.element=c2.component and c1.element=c2.element)

select r.reading,vg.component,element kanji
into #cmp_read_kanji_basic from #cmp_kanji vg
	join kanjidic2_readings_corrected r on vg.element=r.literal
	where r.r_type='ja_on'
select r.reading,vg.component,count(distinct element)kanji_count,STRING_AGG(element,',')kanji
into #cmp_read_basic from #cmp_kanji vg
	join kanjidic2_readings_corrected r on vg.element=r.literal
	where r.r_type='ja_on'
	group by r.reading,vg.component
select component,count(distinct reading)reading_count,sum(kanji_count)kanji_count,replace(STRING_AGG(reading+'('+kanji+')','|')within group (order by kanji_count desc,reading,kanji),'|',' | ')readings_kanji
into #cmp_basic from #cmp_read_basic cte group by component
select *,convert(numeric(5,2),kanji_count*1.0/reading_count) score
into #cmp_enh from #cmp_basic

select m2.component phonetic_component,m1.reading onyomi,m1.component other_component,m1.kanji
into #cmp_read_kanji_enh_temp
	from #cmp_read_kanji_basic m1
	join #cmp_read_kanji_basic m2 on m2.kanji=m1.kanji and m2.reading=m1.reading and m2.component!=m1.component
	order by 1,2,3,4

select dense_rank()over(order by isnull(f.FREQ_BIG_5,9999)/100,phonetic_component,p1.kanji,onyomi)rn,
	isnull(f.FREQ_BIG_5,9999)freq,case when jouyou.Kanji is not null then 1 else 0 end joyo,p1.kanji,p1.phonetic_component,onyomi,string_agg(isnull(p1.other_component,''),' ')within group (order by other_component)other_components
into #cmp_read_kanji_enh_phon_freq from #cmp_read_kanji_enh_temp p1
	left join kanji jouyou on jouyou.Kanji=p1.kanji
	left join kanji_freqs f on f.literal=p1.kanji
	group by isnull(f.FREQ_BIG_5,9999),case when jouyou.Kanji is not null then 1 else 0 end,p1.kanji,phonetic_component,onyomi

select distinct k.keb,r.reb,
	(select avg(convert(int,right(a,1))) from (values(ke_pri1),(ke_pri2),(ke_pri3),(ke_pri4),(re_pri1),(re_pri2),(re_pri3),(re_pri4),(re_pri5),(re_pri6))a(a)where a is not null)freq
into #common_vocab from jmdict_readings r
	join jmdict_kanji k on k.ent_seq=r.ent_seq
	where (ke_pri1 is not null or ke_pri2 is not null or ke_pri3 is not null or ke_pri4 is not null)and
	(re_pri1 is not null or re_pri2 is not null or re_pri3 is not null or re_pri4 is not null or re_pri5 is not null or re_pri6 is not null)

	;with cte as (select distinct kanji
			,onyomi
			,w1.keb+'('+
			case when CHARINDEX(onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,w1.reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS)=charindex(kanji,w1.keb)
			then stuff(w1.reb,CHARINDEX(onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,w1.reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS),len(onyomi),onyomi)
			else replace(w1.reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,onyomi)end+')'
			vocab
			,replace(w1.keb,kanji,onyomi)
				+'('+
			case when CHARINDEX(onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,w1.reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS)=charindex(kanji,w1.keb)
			then stuff(w1.reb,CHARINDEX(onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,w1.reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS),len(onyomi),onyomi)
			else replace(w1.reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,onyomi)end+')'
			vocab2
			,DENSE_RANK()over(partition by kanji,onyomi order by len(keb),len(reb),keb,reb)rn
			,w1.freq vocabfreq
	from #cmp_read_kanji_enh_phon_freq
	left join #common_vocab w1 on charindex(kanji,w1.keb)>0 and 
		kanji!=w1.keb and
		(CHARINDEX(onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,w1.reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS)=charindex(kanji,w1.keb)
		or len(w1.reb)-len(replace(w1.reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS,''))=len(onyomi))
	)
select kanji,onyomi,string_agg(isnull(vocab,cte.kanji+'('+w2.reb+')'),'|') vocab
				   ,string_agg(isnull(vocab2,w2.reb),'|') vocab2
		,avg(isnull(vocabfreq,3))vocabfreq
into #read_kanji_enh_commonvocab from cte
	outer apply(select max(w2.reb)reb from #common_vocab w2
		where w2.keb= cte.kanji and w2.reb collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS =onyomi collate Japanese_Bushu_Kakusu_140_CI_AI_WS_VSS and (rn=1 and vocab is null))w2
	where isnull(rn,0)=1 or (vocab is null and w2.reb is not null)
	group by kanji,onyomi

select t1.phonetic_component,t1.onyomi
	,STRING_AGG(t1.kanji,'|')within group (order by t2.vocabfreq desc,t2.vocab desc,rn) kanji
	,STRING_AGG(isnull(t2.vocab,'-'),'|')within group (order by t2.vocabfreq desc,t2.vocab desc,rn) vocab
	,STRING_AGG(isnull(t2.vocab2,'-'),'|')within group (order by t2.vocabfreq desc,t2.vocab desc,rn) vocab2
into #cmp_read_enh0_vocab from #cmp_read_kanji_enh_phon_freq t1
	left join #read_kanji_enh_commonvocab t2 on t1.kanji=t2.kanji and t1.onyomi=t2.onyomi
	group by phonetic_component,t1.onyomi
	order by 1

drop table if exists #cmp_read_enh1_vocab,#cmp_read_enh2_vocab,#temp_cmp_enh,#cmp_read_enh3_vocab
select *,len(vocab)-len(replace(vocab,'|',''))+1 kanjicount,len(vocab)-len(replace(vocab,'-',''))without_examples_count 
into #cmp_read_enh1_vocab from #cmp_read_enh0_vocab
select convert(numeric(3,2),((kanjicount-without_examples_count)*1.0)/kanjicount)pct_good,*
into #cmp_read_enh2_vocab from #cmp_read_enh1_vocab cte
select sum(pct_good*kanjicount)/sum(kanjicount)pct_good,phonetic_component
into #temp_cmp_enh from #cmp_read_enh2_vocab cte2
	group by phonetic_component
select cte3.pct_good pct_good_percomponent,cte2.pct_good pct_good_peronyomi,cte2.phonetic_component,cte2.onyomi,cte2.kanji ,cte2.vocab,cte2.vocab2,cte2.kanjicount
into #cmp_read_enh3_vocab from #cmp_read_enh2_vocab cte2 join #temp_cmp_enh cte3 on cte2.phonetic_component=cte3.phonetic_component
	order by cte3.pct_good desc,cte2.phonetic_component,cte2.pct_good desc,cte2.onyomi

;with cmp_read_enh_final as
	(select phonetic_component
		,'"'+replace(string_agg(onyomi+'('+replace(kanji,'|',',')+')','`')within group (order by kanjicount desc,pct_good_peronyomi desc),'`','|')+'"'kanji
		,replace(replace(replace(replace(replace(replace('"'+replace(string_agg(replace(replace(replace(vocab,'|-',''),'-|',''),'-',''),'`')within group (order by kanjicount desc,pct_good_peronyomi desc),'`','||')+'"','||||||','||'),'||||||','||'),'||||','||'),'||||','||'),'||||','||'),'||"','"')vocab
		,replace(replace(replace(replace(replace(replace('"'+replace(string_agg(replace(replace(replace(vocab2,'|-',''),'-|',''),'-',''),'`')within group (order by kanjicount desc,pct_good_peronyomi desc),'`','||')+'"','||||||','||'),'||||||','||'),'||||','||'),'||||','||'),'||||','||'),'||"','"')vocab2
		,sum(pct_good_peronyomi*kanjicount)/sum(kanjicount)pct_good,sum(kanjicount)kanjicount,count(onyomi)onyomicount
		from #cmp_read_enh3_vocab group by phonetic_component)
select phonetic_component,kanji readings,vocab2 quiz,vocab answer,pct_good,kanjicount,onyomicount,((1+pct_good)*kanjicount*1.0)/(onyomicount)score
into #cmp_read_disp from cmp_read_enh_final

select * from #cmp_read_disp order by score desc,kanjicount desc,onyomicount