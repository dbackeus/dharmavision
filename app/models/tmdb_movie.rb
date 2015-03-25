class TmdbMovie < RecursiveOpenStruct
  def mpaa
    return nil if tv_series?

    us_release = releases.countries.detect { |release| release.values.include? "US" }

    us_release["certification"] if us_release
  end

  private

  def tv_series?
    number_of_seasons.present?
  end
end
