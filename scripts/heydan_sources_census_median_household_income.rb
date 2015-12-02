class HeydanSourcesCensusMedianHouseholdIncome < HeyDan::Script
  
  def type
    'dataset'
  end

  def build
    api_key = 'c752f1c125b9e278df02dd84e54868ee767f67b0'
    geos = ['place', 'state', 'county']
    @transform_data = {}
    geos.each do |geo|
      [2014,2013,2012].each_with_index do |y,i|
        puts "Grabbing American Community Median Household Income for #{geo} in #{y}"
          data = JSON.parse(open("http://api.census.gov/data/#{y}/acs1?key=#{api_key}&get=NAME,B19013G_001E&for=#{geo}:*").read)
          data[1..-1].each do |d|
            next if d[1].nil?
            state = d[2]
            ansi_id = d[3].nil? ? state : state+d[3]
            @transform_data[ansi_id] ||= [0,0,0]
            @transform_data[ansi_id][i] = d[1].to_i
          end
      end
    end

    @data = @transform_data.map { |c| c[1].unshift(c[0])}
    @data.unshift(['ansi_id', 2014, 2013, 2012])
  end
end