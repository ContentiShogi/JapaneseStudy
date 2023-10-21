--select k.ent_seq,k.entry_n,k.kanji dict,k.reading dictreading,k.c kanji,isnull(k.orig_reading,k.cr)kanji_reading,k.cr kanji_reading_in_word
--,k.score,jmkr.score2
--,isnull(replace(r.r_type,'ja_',''),'??')yomi
--into jmdict_vocab_kanji_reading_map
--from jmdict_kanji_reading_attempt2 k
--left join kanjidic2_readings_ja_2 r on r.literal=k.c and (r.reading=isnull(k.orig_reading,k.cr))
--left join kanji_reading_map_from_jmdict jmkr on jmkr.c=k.c and jmkr.cr=isnull(k.orig_reading,k.cr)and jmkr.yomi=isnull(replace(r.r_type,'ja_',''),'??')
--order by jmkr.score2 desc,
--k.c,k.score
----select * from kanjidic2_readings_ja_2
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

;with j as(select row_number()over(partition by kanji,kanji_reading order by score desc)rn,m.*,isnull(replace(g.posgloss,'"',''''),'') collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS gloss from jmdict_vocab_kanji_reading_map m left join jmdict_gloss_condensed g on g.ent_seq=m.ent_seq)
select j.kanji,j.kanji_reading onyomi,string_agg(convert(nvarchar(max),isnull(j.dict +'('+j.dictreading+')','')),'|') vocab
				   ,string_agg(convert(nvarchar(max),isnull(replace(j.dict,j.kanji,N'['+j.kanji_reading_in_word+N']')+':'+left(j.gloss,147)+case when len(j.gloss)>147 then'...'else''end,'')),'|') vocab2
		,avg(isnull(j.score,25))vocabfreqscore,avg(isnull(j.score2,0))vocabfreqscore2
into #read_kanji_enh_commonvocab from j
where j.yomi in ('on','both')and rn<=2
group by j.kanji,j.kanji_reading
--select * from #read_kanji_enh_commonvocab where kanji in (N'褊',N'蝙',N'翩',N'偏',N'騙',N'遍',N'編',N'扁',N'篇',N'諞')
select t1.phonetic_component,t1.onyomi
	,STRING_AGG(t1.kanji,'|')within group (order by t2.vocabfreqscore2 desc,t2.vocab desc,rn) kanji
	,STRING_AGG(isnull(t2.vocab,'`'),'|')within group (order by t2.vocabfreqscore2 desc,t2.vocab desc,rn) vocab
	,STRING_AGG(isnull(t2.vocab2,'`'),'|')within group (order by t2.vocabfreqscore2 desc,t2.vocab desc,rn) vocab2
	,count(distinct t1.kanji)kanjicount,count(distinct t2.vocab)vocabcount
into #cmp_read_enh0_vocab
from #cmp_read_kanji_enh_phon_freq t1
	left join #read_kanji_enh_commonvocab t2 on t1.kanji=t2.kanji
	--todo: was lazy here. Convert #cmp_read_kanji_enh_phon_freq to hiragana to do it properly
	and t1.onyomi collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS =t2.onyomi collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS 
	group by phonetic_component,t1.onyomi
	order by 1
--select * from #cmp_read_enh0_vocab where kanji in (N'褊',N'蝙',N'翩',N'偏',N'騙',N'遍',N'編',N'扁',N'篇',N'諞')
drop table if exists #cmp_read_enh1_vocab,#cmp_read_enh2_vocab,#temp_cmp_enh,#cmp_read_enh3_vocab
select */*,len(vocab)-len(replace(vocab,'|',''))+1 kanjicount,len(vocab)-len(replace(vocab,'`',''))without_examples_count*/
into #cmp_read_enh1_vocab from #cmp_read_enh0_vocab
select convert(numeric(3,2),((/*kanjicount-without_examples_count*/vocabcount)*1.0)/kanjicount)pct_good,*
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
		,replace(replace(replace(replace(replace(replace('"'+replace(string_agg(replace(replace(replace(vocab,'|`',''),'`|',''),'`',''),'`')within group (order by kanjicount desc,pct_good_peronyomi desc),'`','||')+'"','||||||','||'),'||||||','||'),'||||','||'),'||||','||'),'||||','||'),'||"','"')vocab
		,replace(replace(replace(replace(replace(replace('"'+replace(string_agg(replace(replace(replace(vocab2,'|`',''),'`|',''),'`',''),'`')within group (order by kanjicount desc,pct_good_peronyomi desc),'`','||')+'"','||||||','||'),'||||||','||'),'||||','||'),'||||','||'),'||||','||'),'||"','"')vocab2
		,sum(pct_good_peronyomi*kanjicount)/sum(kanjicount)pct_good,sum(kanjicount)kanjicount,count(onyomi)onyomicount
		from #cmp_read_enh3_vocab group by phonetic_component)
select phonetic_component,kanji readings,vocab2 quiz,vocab answer,pct_good,kanjicount,onyomicount,convert(int,round(((1+pct_good)*kanjicount*1.0)/(onyomicount),0))score
into #cmp_read_disp from cmp_read_enh_final

select * from #cmp_read_disp
--where phonetic_component=N'扁'
order by score desc,kanjicount desc,onyomicount