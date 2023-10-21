--;with cte as(select distinct pos1 pos from jmdict_gloss union
--select distinct pos2 from jmdict_gloss union
--select distinct pos3 from jmdict_gloss union
--select distinct pos5 from jmdict_gloss union
--select distinct pos5 from jmdict_gloss union
--select distinct pos6 from jmdict_gloss)
--select ',(N'''+replace(pos,'''','''''')+''',N'''+left(replace(replace(pos,'''',''),' ',''),6)+''')'from cte where pos is not null
--order by 1
;with abbrs as(select * from (values
(N'adjectival nouns or quasi-adjectives (keiyodoshi)',N'adj-n',1)
,(N'adjective (keiyoushi) - yoi/ii class',N'adj-ii',1)
,(N'adjective (keiyoushi)',N'adj',1)
,(N'adverb (fukushi)',N'adv',1)
,(N'adverb taking the ''to'' particle',N'adv-to',1)
,(N'archaic/formal form of na-adjective',N'old-adj',3)
,(N'auxiliary adjective',N'aux-adj',1)
,(N'auxiliary verb',N'aux-v',1)
,(N'auxiliary',N'aux',2)
,(N'conjunction',N'conjcn',1)
,(N'copula',N'copula',1)
,(N'counter',N'countr',1)
,(N'expressions (phrases, clauses, etc.)',N'expr',1)
,(N'Godan verb - -aru special class',N'v5-aru',1)
,(N'Godan verb - Iku/Yuku special class',N'v-iku',1)
,(N'Godan verb with ''bu'' ending',N'v5bu',1)
,(N'Godan verb with ''gu'' ending',N'v5gu',1)
,(N'Godan verb with ''ku'' ending',N'v5ku',1)
,(N'Godan verb with ''mu'' ending',N'v5mu',1)
,(N'Godan verb with ''nu'' ending',N'v5nu',1)
,(N'Godan verb with ''ru'' ending (irregular verb)',N'v5ru-ir',1)
,(N'Godan verb with ''ru'' ending',N'v5ru',1)
,(N'Godan verb with ''su'' ending',N'v5su',1)
,(N'Godan verb with ''tsu'' ending',N'v5tsu',1)
,(N'Godan verb with ''u'' ending (special class)',N'v5u-sp',1)
,(N'Godan verb with ''u'' ending',N'v5u',1)
,(N'Ichidan verb - kureru special class',N'v1-kure',1)
,(N'Ichidan verb - zuru verb (alternative form of -jiru verbs)',N'v1-zuru',1)
,(N'Ichidan verb',N'v1',1)
,(N'interjection (kandoushi)',N'intrjcn',1)
,(N'intransitive verb',N'intrnsv',2)
,(N'irregular nu verb',N'v-nu-ir',1)
,(N'irregular ru verb, plain form ends with -ri',N'v-ru-ir',1)
,(N'''ku'' adjective (archaic)',N'adj-ku',3)
,(N'Kuru verb - special class',N'v-kuru',1)
,(N'Nidan verb (lower class) with ''dzu'' ending (archaic)',N'v2dzu',3)
,(N'Nidan verb (lower class) with ''gu'' ending (archaic)',N'v2gu',3)
,(N'Nidan verb (lower class) with ''hu/fu'' ending (archaic)',N'v2hu',3)
,(N'Nidan verb (lower class) with ''ku'' ending (archaic)',N'v2ku',3)
,(N'Nidan verb (lower class) with ''mu'' ending (archaic)',N'v2mu',3)
,(N'Nidan verb (lower class) with ''nu'' ending (archaic)',N'v2nu',3)
,(N'Nidan verb (lower class) with ''ru'' ending (archaic)',N'v2ru',3)
,(N'Nidan verb (lower class) with ''su'' ending (archaic)',N'v2su',3)
,(N'Nidan verb (lower class) with ''tsu'' ending (archaic)',N'v2tsu',3)
,(N'Nidan verb (lower class) with ''u'' ending and ''we'' conjugation (archaic)',N'v2u-we',3)
,(N'Nidan verb (lower class) with ''yu'' ending (archaic)',N'v2yu',3)
,(N'Nidan verb (lower class) with ''zu'' ending (archaic)',N'v2zu',3)
,(N'Nidan verb (upper class) with ''bu'' ending (archaic)',N'v2bu',3)
,(N'Nidan verb (upper class) with ''gu'' ending (archaic)',N'v2gu',3)
,(N'Nidan verb (upper class) with ''hu/fu'' ending (archaic)',N'v2hu',3)
,(N'Nidan verb (upper class) with ''ku'' ending (archaic)',N'v2ku',3)
,(N'Nidan verb (upper class) with ''ru'' ending (archaic)',N'v2ru',3)
,(N'Nidan verb (upper class) with ''tsu'' ending (archaic)',N'v2tsu',3)
,(N'Nidan verb (upper class) with ''yu'' ending (archaic)',N'v2yu',3)
,(N'Nidan verb with ''u'' ending (archaic)',N'v2u',3)
,(N'noun (common) (futsuumeishi)',N'n-comm',1)
,(N'noun or participle which takes the aux. verb suru',N'n-suru',1)
,(N'noun or verb acting prenominally',N'prenom',1)
,(N'noun, used as a prefix',N'n-pref',1)
,(N'noun, used as a suffix',N'n-suff',1)
,(N'nouns which may take the genitive case particle ''no''',N'n-no',1)
,(N'numeric',N'numeric',1)
,(N'particle',N'prt',1)
,(N'prefix',N'pref',1)
,(N'pre-noun adjectival (rentaishi)',N'prenadj',1)
,(N'pronoun',N'pron',1)
,(N'''shiku'' adjective (archaic)',N'adjshik',3)
,(N'su verb - precursor to the modern suru',N'verb-su',3)
,(N'suffix',N'suff',1)
,(N'suru verb - included',N'v-suru',1)
,(N'suru verb - special class',N'vsurusp',1)
,(N'''taru'' adjective',N'adjtaru',2)
,(N'transitive verb',N'trnsitv',1)
,(N'unclassified',N'?',3)
,(N'verb unspecified',N'v-?',3)
,(N'Yodan verb with ''bu'' ending (archaic)',N'v4bu',3)
,(N'Yodan verb with ''gu'' ending (archaic)',N'v4gu',3)
,(N'Yodan verb with ''hu/fu'' ending (archaic)',N'v4hu',3)
,(N'Yodan verb with ''ku'' ending (archaic)',N'v4ku',3)
,(N'Yodan verb with ''mu'' ending (archaic)',N'v4mu',3)
,(N'Yodan verb with ''ru'' ending (archaic)',N'v4ru',3)
,(N'Yodan verb with ''su'' ending (archaic)',N'v4su',3)
,(N'Yodan verb with ''tsu'' ending (archaic)',N'v4tsu',3)
)as abrs(pos,posab,prio))
,cte as
(select ent_seq,
	(select string_agg(a,';')within group(order by isnull(b,100),len(a),a) from (values (isnull(a1.posab,''),a1.prio),(isnull(a2.posab,''),a2.prio),(isnull(a3.posab,''),a3.prio),(isnull(a4.posab,''),a4.prio),(isnull(a5.posab,''),a5.prio),(isnull(a6.posab,''),a6.prio))as a(a,b))pos
	,STRING_AGG(gloss,'; ')within group (order by gloss)gloss
from jmdict_gloss
left join abbrs a1 on a1.pos=pos1 left join abbrs a2 on a2.pos=pos2 left join abbrs a3 on a3.pos=pos3 left join abbrs a4 on a4.pos=pos4 left join abbrs a5 on a5.pos=pos5 left join abbrs a6 on a6.pos=pos6
where gloss_lang='eng'
group by ent_seq,isnull(a1.posab,''),a1.prio,isnull(a2.posab,''),a2.prio,isnull(a3.posab,''),a3.prio,isnull(a4.posab,''),a4.prio,isnull(a5.posab,''),a5.prio,isnull(a6.posab,''),a6.prio
)--select * from cte where ent_seq in(1092280,1102580)order by ent_seq
select distinct ent_seq,
replace('['+
(select string_agg(a,';') within group (order by len(a),a)x from(select distinct replace(value,';','') a from string_split(
left(replace(replace(replace(replace(string_agg(pos+';',';'),';;;;;',';'),';;;;',';'),';;;',';'),';;',';')
	 ,len(replace(replace(replace(replace(string_agg(pos+';',';'),';;;;;',';'),';;;;',';'),';;;',';'),';;',';'))-1),';')where replace(value,';','')!='')as a(a))
+']','[;','[')pos,
replace(replace(replace(replace(STRING_AGG(gloss,'; '),';;;;;',';'),';;;;',';'),';;;',';'),';;',';')gloss,
replace('['+
(select string_agg(a,';') within group (order by len(a),a)x from(select distinct replace(value,';','') a from string_split(
left(replace(replace(replace(replace(string_agg(pos+';',';'),';;;;;',';'),';;;;',';'),';;;',';'),';;',';')
	 ,len(replace(replace(replace(replace(string_agg(pos+';',';'),';;;;;',';'),';;;;',';'),';;;',';'),';;',';'))-1),';')where replace(value,';','')!='')as a(a))
--+case when len(left(replace(replace(replace(replace(string_agg(pos+';',';'),';;;;;',';'),';;;;',';'),';;;',';'),';;',';')
--				   ,len(replace(replace(replace(replace(string_agg(pos+';',';'),';;;;;',';'),';;;;',';'),';;;',';'),';;',';'))-1))>15 then'..'else''end
+']','[;','[')+replace(replace(replace(replace(STRING_AGG(gloss,'; '),';;;;;',';'),';;;;',';'),';;;',';'),';;',';')posgloss
into jmdict_gloss_condensed
from cte group by ent_seq
select * from jmdict_gloss_condensed