select departamento as "nome departamento", count(empregado) as "numEmpregados",  (round(sum(r.liquido) / count(empregado), 2) || '') as "media", 
case when max(r.liquido) = 0 then '0' else cast(round(max(r.liquido),2) as varchar) end as "máximo", 
case when min(r.liquido) = 0 then '0' else cast(round(min(r.liquido),2) as varchar) end as "mínimo"
from ( select dep.nome as departamento, emp.nome as empregado, round(( select coalesce(sum(v.valor), 0) 
from departamento depar join divisao divis on depar.cod_dep = divis.cod_dep join empregado empre on divis.cod_divisao = empre.lotacao_div join emp_venc ev on empre.matr = ev.matr join vencimento v on ev.cod_venc = v.cod_venc where empre.nome = emp.nome ), 2) - ( select coalesce(sum(d.valor), 0) 
from departamento depa join divisao divi on depa.cod_dep = divi.cod_dep join empregado empr on divi.cod_divisao = empr.lotacao_div join emp_desc ed on empr.matr = ed.matr join desconto d on ed.cod_desc = d.cod_desc where empr.nome = emp.nome ) as liquido 
from departamento dep join divisao div on dep.cod_dep = div.cod_dep join empregado emp on div.cod_divisao = emp.lotacao_div group by departamento, empregado order by liquido desc) as r group by r.departamento order by "media" desc;
