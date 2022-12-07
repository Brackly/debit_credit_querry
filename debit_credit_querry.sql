
select * from transactions

with remod(ac_no,Trans_date,deb_cred,amount) as (
        select ac_no,Trans_date,deb_cred,
        case  deb_cred
            when 'debit' then amount*(-1)
            when  'credit' then amount
        end
        from transactions),

    sumed_table(ac_no,Trans_date,deb_cred,amount,Total_bal,current_bal,flag) as (
        select *,
        sum(amount) over (partition by ac_no order by Trans_date 
        range between unbounded preceding and unbounded following)as totals,
        sum(amount) over (partition by ac_no order by Trans_date 
        )as current_bal,
        case when sum(amount) over (partition by ac_no order by Trans_date)>=1000 then 1 else 0 end as flag
         from remod)

select ac_no,min(Trans_date) as Transaction_date from sumed_table  where Total_bal>=1000 and flag=1
group by ac_no


