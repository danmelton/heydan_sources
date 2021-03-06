class HeydanSourcesDecennialCensusTotalPopulation < HeyDan::Script

  def type
    'dataset'
  end

  def build
    api_key = 'c752f1c125b9e278df02dd84e54868ee767f67b0'
    geos = ['place', 'state', 'county']
    @transform_data = {}
    geos.each do |geo|
      [['2010','P0010001'], ['2000','P001001'], ['1990','P0010001']].each do |y|
        puts "Grabbing Census data for #{geo} in #{y[0]}"
          data = JSON.parse(open("http://api.census.gov/data/#{y[0]}/sf1?key=#{api_key}&get=#{y[1]}&for=#{geo}:*").read)
          data[1..-1].each do |d|
            state = d[1].size==1 ? "0#{d[1]}" : d[1]
            ansi_id = d[2].nil? ? state : state+d[2]
            @transform_data[ansi_id] ||= []
            @transform_data[ansi_id] << d[0].to_i
          end
      end
    end
    @data = @transform_data.map { |c| c[1].unshift(c[0])}
    @data.unshift(['ansi_id', 2010, 2000, 1990])
  end

end