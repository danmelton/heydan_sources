class HeydanSourcesCensusAnsiId < HeyDan::Script
  
  def type
    'identifier'
  end

  def build
    @data = HeyDan::Helper::get_data_from_url('https://github.com/opencivicdata/ocd-division-ids/blob/master/identifiers/country-us.csv?raw=true')
    @data = @data[1..-1].select { |c| !c[5].nil? }.map { |c| [c[0], c[5].split('-')[-1]]}
    @data = @data.unshift(['open_civic_id', 'ansi_id'])
  end
end