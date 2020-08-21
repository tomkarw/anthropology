create procedure proposeEventMatchesProcedural(@event_id as int)
as
begin

    declare
        @am_id int,
        @am_age smallint, -- for negative values
        @am_height smallint,
        @am_weight smallint,
        @am_gender char(1),
        @am_race varchar(32),
        @am_eye_color varchar(16),
        @pm_id int,
        @pm_age smallint, -- for negative values
        @pm_height smallint,
        @pm_weight smallint,
        @pm_gender char(1),
        @pm_race varchar(32),
        @pm_eye_color varchar(16);
    declare @pair_table table
                        (
                            am_id int not null,
                            pm_id int not null
                        );
    declare all_possibilities_cursor cursor for (
        select PM.post_mortem_id,
               PM.age,
               PM.height,
               PM.weight,
               PM.gender,
               PM.race,
               PM.eye_color,
               AM.ante_mortem_id,
               AM.age,
               AM.height,
               AM.weight,
               AM.gender,
               AM.race,
               AM.eye_color
        from PostMortems PM
                 cross join AnteMortems AM
        where PM.event_id = @event_id
          and AM.event_id = @event_id
    );
    open all_possibilities_cursor;
    fetch next from all_possibilities_cursor into
        @am_id,
        @am_age,
        @am_height,
        @am_weight,
        @am_gender,
        @am_race,
        @am_eye_color,
        @pm_id,
        @pm_age,
        @pm_height,
        @pm_weight,
        @pm_gender,
        @pm_race,
        @pm_eye_color;
    while @@fetch_status = 0
        begin
            -- collect 3 point or break if some field doesn't match
            declare @match_points int = 0;

            -- if any of the fields is null skip it
            if @am_age is not null and @pm_age is not null
                begin
                    -- if they match, add match point
                    if ((@pm_age < 18 and @am_age < 18 and abs(@pm_age - @am_age) <= 2) or
                        abs(@pm_age - @am_age) <= 10)
                        begin
                            set @match_points = @match_points + 1;
                        end
                    else
                        begin
                            -- not a pair, go to the next one
                            fetch next from all_possibilities_cursor into
                                @am_id,
                                @am_age,
                                @am_height,
                                @am_weight,
                                @am_gender,
                                @am_race,
                                @am_eye_color,
                                @pm_id,
                                @pm_age,
                                @pm_height,
                                @pm_weight,
                                @pm_gender,
                                @pm_race,
                                @pm_eye_color;
                            continue;
                        end
                end

            -- same for height
            if @am_height is not null and @pm_height is not null
                begin
                    if (abs(@pm_height - @am_height) <= 5)
                        begin
                            set @match_points = @match_points + 1;
                        end
                    else
                        begin
                            fetch next from all_possibilities_cursor into
                                @am_id,
                                @am_age,
                                @am_height,
                                @am_weight,
                                @am_gender,
                                @am_race,
                                @am_eye_color,
                                @pm_id,
                                @pm_age,
                                @pm_height,
                                @pm_weight,
                                @pm_gender,
                                @pm_race,
                                @pm_eye_color;
                            continue;
                        end
                end

            -- weight
            if @am_weight is not null and @pm_weight is not null
                begin
                    -- if they match, add match point
                    if (abs(@pm_weight - @am_weight) / @pm_weight <= 0.1)
                        begin
                            set @match_points = @match_points + 1;
                        end
                    else
                        begin
                            -- not a pair, go to the next one
                            fetch next from all_possibilities_cursor into
                                @am_id,
                                @am_age,
                                @am_height,
                                @am_weight,
                                @am_gender,
                                @am_race,
                                @am_eye_color,
                                @pm_id,
                                @pm_age,
                                @pm_height,
                                @pm_weight,
                                @pm_gender,
                                @pm_race,
                                @pm_eye_color;
                            continue;
                        end
                end

            -- gender
            if @am_gender is not null and @pm_gender is not null
                begin
                    -- if they match, add match point
                    if (@am_gender <> @pm_gender)
                        begin
                            set @match_points = @match_points + 1;
                        end
                    else
                        begin
                            -- not a pair, go to the next one
                            fetch next from all_possibilities_cursor into
                                @am_id,
                                @am_age,
                                @am_height,
                                @am_weight,
                                @am_gender,
                                @am_race,
                                @am_eye_color,
                                @pm_id,
                                @pm_age,
                                @pm_height,
                                @pm_weight,
                                @pm_gender,
                                @pm_race,
                                @pm_eye_color;
                            continue;
                        end
                end

            -- race
            if @am_race is not null and @pm_race is not null
                begin
                    -- if they match, add match point
                    if (@am_race <> @pm_race)
                        begin
                            set @match_points = @match_points + 1;
                        end
                    else
                        begin
                            -- not a pair, go to the next one
                            fetch next from all_possibilities_cursor into
                                @am_id,
                                @am_age,
                                @am_height,
                                @am_weight,
                                @am_gender,
                                @am_race,
                                @am_eye_color,
                                @pm_id,
                                @pm_age,
                                @pm_height,
                                @pm_weight,
                                @pm_gender,
                                @pm_race,
                                @pm_eye_color;
                            continue;
                        end
                end

            -- if not enough matches fetch next
            if @match_points < 3
                begin
                    fetch next from all_possibilities_cursor into
                        @am_id,
                        @am_age,
                        @am_height,
                        @am_weight,
                        @am_gender,
                        @am_race,
                        @am_eye_color,
                        @pm_id,
                        @pm_age,
                        @pm_height,
                        @pm_weight,
                        @pm_gender,
                        @pm_race,
                        @pm_eye_color;
                    continue;
                end

            -- if pair has matching potential add it to semi_table
            insert into @pair_table values (@am_id, @pm_id);

            fetch next from all_possibilities_cursor into
                @am_id,
                @am_age,
                @am_height,
                @am_weight,
                @am_gender,
                @am_race,
                @am_eye_color,
                @pm_id,
                @pm_age,
                @pm_height,
                @pm_weight,
                @pm_gender,
                @pm_race,
                @pm_eye_color;
        end
    close all_possibilities_cursor;
    deallocate all_possibilities_cursor;

    -- process unique pm matches
    update PostMortems
    set ante_mortem_id = am_id,
        status         = 'potential match'
    from @pair_table
    where post_mortem_id in (
        select pm_id
        from @pair_table
        where pm_id in (select pm_id from @pair_table group by pm_id having count(*) = 1)
          and am_id in (select am_id from @pair_table group by am_id having count(*) = 1)
    )

    -- process unique am matches
    update AnteMortems
    set status = 'potential match'
    where ante_mortem_id in (
        select am_id
        from @pair_table
        where pm_id in (select pm_id from @pair_table group by pm_id having count(*) = 1)
          and am_id in (select am_id from @pair_table group by am_id having count(*) = 1)
    );

    -- process multiple post mortem matches
    update PostMortems
    set status = 'multiple matches'
    where post_mortem_id in (
        select pm_id
        from @pair_table
        group by pm_id
        having count(*) > 1
    );

    -- process multiple ante mortem matches
    update AnteMortems
    set status = 'multiple matches'
    where ante_mortem_id in (
        select am_id
        from @pair_table
        group by am_id
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