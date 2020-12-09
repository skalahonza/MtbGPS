function result = assertdouble(input, title, description)
% ASSERTDOUBLE Asserts that all strings in the input vector are convertible
% to double. Throws exception otherwise. The exception contains a given 
% title and description.
% result = assertdouble(input, title, description)
% title and description are strings
% result is the vector of doubles

result = str2double(input);
if any(isnan(result))
    throw(MException(title,description));
end
end