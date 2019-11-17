function Initialize()
    json = dofile(SKIN:MakePathAbsolute('Scripts/lib/json.lua'))
end

function Update()

    -- Fetch meter options
    n_output   = SELF:GetOption('NumOutput',            0)
    name_field = SELF:GetOption('NameField',           'name')
    name_fmt   = SELF:GetOption('NameVariableFormat',  'Category%i_Name')
    time_field = SELF:GetOption('TimeField',           'digital')
    time_fmt   = SELF:GetOption('TimeVariableFormat',  'Category%i_Time')
    status_var = SELF:GetOption('StatusVariable',      'Status')

    -- Parse JSON
    jsondata = SELF:GetOption('Data', '{}')
    data = json.decode(jsondata)

    -- Handle error
    if data['error'] then
        SKIN:Bang('!SetVariable', status_var, 'API Error: ' .. data['error'])
        return 'API Error: ' .. data['error']
    end
    if not data['data'] or not data['data'][1] or not data['data'][1]['categories'] then
        SKIN:Bang('!SetVariable', status_var, 'API Error')
        return 'API Error'
    end

    -- Unpack category data
    categories = data['data'][1]['categories']

    -- Output to variables
    for i = 1, math.min(n_output, table.getn(categories)) do
        SKIN:Bang('!SetVariable', string.format(name_fmt, i), categories[i][name_field])
        SKIN:Bang('!SetVariable', string.format(time_fmt, i), categories[i][time_field])
    end

    SKIN:Bang('!SetVariable', status_var, '')
    return 'OK'
end
