def hash_compare(h1, h2, deep_compare = false)
  diff = {}
  return diff if h1 == h2

  # find differences between hashes non at level 0
  differences = {}
  h1.each do |key, value|
    next if h1[key].is_a?(Hash) && h2[key].is_a?(Hash)

    differences.merge!(key => h1[key]) if h1[key] != h2[key]
  end
  h2.each do |key, value|
    next if h1[key].is_a?(Hash) && h2[key].is_a?(Hash)

    differences.merge!(key => h2[key]) if h1[key] != h2[key]
  end

  diff.merge! differences

  return diff unless deep_compare

  # check differences on each common hash key
  common_hash_keys = (h1.keys & h2.keys).filter { |key| h1[key].is_a?(Hash) && h2[key].is_a?(Hash) }
  common_hash_keys.each do |key|
    nested_diff = {key => (hash_compare(h1[key], h2[key], deep_compare))}
    diff.merge! nested_diff unless nested_diff[key].empty?
  end

  diff
end

h1 = {a: "1", b: "2", d: {e: {h: 4}, f: 2}, j: {k: 1}}
h2 = {a: "1", c: "2", d: {e: {h: 4, i: 9}, g: 3}, j: {k: 2}}

puts hash_compare(h1, h2, true)
puts hash_compare(h1, h2)
