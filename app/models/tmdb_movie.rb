class TmdbMovie < RecursiveOpenStruct
  def mpaa
    us_release = releases.countries.detect { |release| release.values.include? "US" }

    us_release["certification"] if us_release
  end
end
