function result = assertdouble(input, title, description)
result = str2double(input);
if any(isnan(result))
    throw(MException(title,description));
end
end