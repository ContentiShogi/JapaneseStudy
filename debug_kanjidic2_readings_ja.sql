--select * from jmdict_kanji_unwrapped_stage1 where vocab_ent_n=454
select max(vocab_ent_n)from jmdict_kanji_unwrapped_stage3_rev2
select distinct m_hiragana,m_kanji_index,vocab_ent_n,vocab_reading_hiragana,m_std_reading,m_starter,m_ender
from jmdict_kanji_unwrapped_stage3_rev2 order by vocab_ent_n,m_kanji_index
select s3.*,s1.vocab_kanji,s1.vocab_reading_hiragana from jmdict_kanji_unwrapped_stage3_rev2(nolock)s3
left join jmdict_kanji_unwrapped_stage1 s1 on s1.vocab_ent_n=s3.vocab_ent_n and s1.kanjichar_reading_hiragana=s3.m_std_reading and s1.kanjichar_index=s3.m_kanji_index
order by s1.vocab_ent_n,s1.kanjichar_index
select * from jmdict_kanji_unwrapped_stage3_rev2


set nocount on;
drop table if exists #kanasandhi
select distinct *,len(ender)len_ender,len(starter)len_starter,right(ender,1)e,left(starter,1)s
into #kanasandhi from kana_sandhi where starter!='' and ender!='' union
 select distinct ender,starter+kana,endersandhi,startersandhi+kana,sandhitype,len(ender)len_ender,len(starter+kana)len_starter,right(ender,1)e,left(starter+kana,1)s
from kana_unwrapped join kana_sandhi on kana_sandhi.starter='' union
 select distinct ender+kana,starter,endersandhi+kana,startersandhi,sandhitype,len(ender+kana)len_ender,len(starter)len_starter,right(ender+kana,1)e,left(starter,1)s
from kana_unwrapped join kana_sandhi on kana_sandhi.ender=''

drop table if exists #jmdict_kanji_unwrapped_stage2_e_m_s
select 
middles.kanjichar_index middleskanjichar_index,
middles.vocab_ent_n middlesvocab_ent_n,
middles.vocab_kanji middlesvocab_kanji,
middles.kanjichar middleskanjichar,
middles.vocab_reading_hiragana middlesvocab_reading_hiragana,
CASE CHARINDEX(middles.kanjichar,middles.vocab_kanji) WHEN 1 THEN 's' WHEN len(middles.vocab_kanji) THEN 'e' ELSE 'm' END m_position,

isnull(enders.kanjichar_reading_hiragana,substring(middles.vocab_kanji,charindex(middles.kanjichar,middles.vocab_kanji)-1,1)) enderskanjichar_reading_hiragana,
middles.kanjichar_reading_hiragana middleskanjichar_reading_hiragana,
isnull(starters.kanjichar_reading_hiragana,substring(middles.vocab_kanji,charindex(middles.kanjichar,middles.vocab_kanji)+1,1)) starterskanjichar_reading_hiragana,

nullif(isnull(right(enders.kanjichar_reading_hiragana,1),substring(middles.vocab_kanji,charindex(middles.kanjichar,middles.vocab_kanji)-1,1)),'')ee,
left(middles.kanjichar_reading_hiragana,1)ms,
right(middles.kanjichar_reading_hiragana,1)me,
nullif(isnull(left(starters.kanjichar_reading_hiragana,1),substring(middles.vocab_kanji,charindex(middles.kanjichar,middles.vocab_kanji)+1,1)),'')ss
into #jmdict_kanji_unwrapped_stage2_e_m_s
from jmdict_kanji_unwrapped_stage2 middles
	full outer join jmdict_kanji_unwrapped_stage2 enders on enders.vocab_ent_n=middles.vocab_ent_n and enders.kanjichar_index=middles.kanjichar_index-1
	full outer join jmdict_kanji_unwrapped_stage2 starters on middles.vocab_ent_n=starters.vocab_ent_n and middles.kanjichar_index=starters.kanjichar_index-1
where middles.vocab_ent_n in (454)
select * from #jmdict_kanji_unwrapped_stage2_e_m_s

;with sandhis as
(	select distinct 
		stuff(stuff(middleskanjichar_reading_hiragana,1,ender_sandhi.len_starter,ender_sandhi.startersandhi)
			,len(stuff(middleskanjichar_reading_hiragana,1,ender_sandhi.len_starter,ender_sandhi.startersandhi))-starter_sandhi.len_ender+1
			,starter_sandhi.len_ender,starter_sandhi.endersandhi) m_hiragana
	,	middlesvocab_kanji,middleskanjichar
	,	middleskanjichar_index m_kanji_index
	,	middlesvocab_ent_n
	,	middlesvocab_reading_hiragana
	,	middleskanjichar_reading_hiragana m_std_reading
	,	iif(m_position = 's','', ender_sandhi.endersandhi) endersandhi, ender_sandhi.startersandhi m_starter
	,	starter_sandhi.endersandhi m_ender, iif(m_position = 'e','',starter_sandhi.startersandhi) startersandhi
	--,*
	from #jmdict_kanji_unwrapped_stage2_e_m_s
	join #kanasandhi ender_sandhi	on  (enderskanjichar_reading_hiragana is null or ender_sandhi.e=ee) and ender_sandhi.s=ms
	join #kanasandhi starter_sandhi	on	starter_sandhi.e=me	and (starterskanjichar_reading_hiragana is null or starter_sandhi.s=ss)
	--order by #jmdict_kanji_unwrapped_stage2_e_m_s.middlesvocab_ent_n,#jmdict_kanji_unwrapped_stage2_e_m_s.middleskanjichar_index
	and	charindex(
				iif(m_position = 's','', ender_sandhi.endersandhi)
			+	nullif(stuff(
						 stuff(middleskanjichar_reading_hiragana,1,ender_sandhi.len_starter,ender_sandhi.startersandhi)
						,len(stuff(middleskanjichar_reading_hiragana,1,ender_sandhi.len_starter,ender_sandhi.startersandhi))-starter_sandhi.len_ender+1
						,starter_sandhi.len_ender,starter_sandhi.endersandhi)
					,middleskanjichar_reading_hiragana)
			+	iif(m_position = 'e','',starter_sandhi.startersandhi)
		,middlesvocab_reading_hiragana)>0
)
--insert into jmdict_kanji_unwrapped_stage3_rev2
select * from sandhis
