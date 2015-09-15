class HeydanSourcesCensusAnsiId < HeyDan::Script
  
  def type
    'identifier'
  end

  def build
    @data = HeyDan::Helper::get_data_from_url('https://github.com/opencivicdata/ocd-division-ids/blob/master/identifiers/country-us.csv?raw=true')
    @data = @data[1..-1].select { |c| !c[5].nil? }.map { |c| [c[0], c[5].split('-')[-1]]}
    #for some reason it doesn't have the ansi_id for states, weirdness
    data = @data.select { |x| x[0].include?('/state:')}
    states = {}
    data.each { |d| 
      m = d[0].match(/ocd-division\/country:us\/state:[a-z]{2}/)
      next if m.nil?
      next if states[m[0]]
      states[m[0]] = d[1][0..1]
    }
    @data += states.to_a
    @data = @data.unshift(['open_civic_id', 'ansi_id'])
  end
end