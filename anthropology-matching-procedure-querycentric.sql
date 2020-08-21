create procedure proposeEventMatchesQuerycentirc(@event_id as int)
as
begin

    declare @post_mortem_id int, @ante_mortem_id int;
    declare @match_table table
                         (
                             ante_mortem_id int not null,
                             post_mortem_id int not null
                         );
    set @match_table = (
        select AM.ante_mortem_id, PM.post_mortem_id
        from PostMortems PM
                 cross join AnteMortems AM
        where PM.event_id = 3
          and AM.event_id = 3
          and PM.race = AM.race
          and abs(PM.height - AM.height) <= 5
          and ((PM.age < 18 and AM.age < 18 and abs(PM.age - AM.age) <= 2) or abs(PM.age - AM.age) <= 10)
          and PM.eye_color = AM.eye_color
          and abs(PM.weight - AM.weight) / PM.weight <= 0.1
    )
    declare matches_cursor cursor for (
        select post_mortem_id, ante_mortem_id
        from @match_table
        where post_mortem_id in (select post_mortem_id from @match_table group by post_mortem_id having count(*) = 1)
          and ante_mortem_id in (select ante_mortem_id from @match_table group by ante_mortem_id having count(*) = 1)
    );
    open matches_cursor;
    fetch next from matches_cursor into @post_mortem_id, @ante_mortem_id;
    while @@fetch_status = 0
        begin
            -- update Post Mortem ante_mortem fk and status
            update PostMortems
            set ante_mortem_id = @ante_mortem_id,
                status         = 'potential match'
            where post_mortem_id = @post_mortem_id;
            -- update Ante Mortem status
            update AnteMortems
            set status = 'potential match'
            where ante_mortem_id = @ante_mortem_id;
            fetch next from matches_cursor into @post_mortem_id, @ante_mortem_id;
        end
    close matches_cursor;
    deallocate matches_cursor;

    -- process multiple post mortem matches
    update PostMortems
    set status = 'multiple matches'
    where post_mortem_id in (
        select post_mortem_id
        from @match_table
        group by post_mortem_id
        having count(*) > 1
    );

    -- process multiple ante mortem matches
    update AnteMortems
    set status = 'multiple matches'
    where ante_mortem_id in (
        select ante_mortem_id
        from @match_table
        group by ante_mortem_id
        having count(*) > 1
    );

    -- process no matches
    update PostMortems
    set status = 'unidentified'
    where event_id = @event_id
      and status is null;

    update AnteMortems
    set status = 'unidentified'
    where event_id = @event_id
      and status is null;
end