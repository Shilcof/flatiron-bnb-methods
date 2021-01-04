module Reservable
    extend ActiveSupport::Concerns

    module ClassMethods
        def highest_ratio_res_to_listings
            all.max_by(&:ratio_reservations_to_listings)
        end

        def most_res
            all.max_by{|x| x.reservations.size}
        end
    end

    module InstanceMethods
        def availabilities(start_date, end_date)
            listings.select{ |l| l.available?(start_date, end_date) }
        end

        def ratio_reservations_to_listings
            if listings.count > 0
                reservations.count.to_f / listings.count.to_f
            else
                0.0
            end
        end
    end
end