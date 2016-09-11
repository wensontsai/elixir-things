defmodule Caesar.CipherTest do
  use ExUnit.Case
  doctest Caesar.Cipher

  import Caesar.Cipher

  test "encrypt shift cipher mapping" do
    assert encrypt("abcd", 1) == "zabc"
  end

  test "encrypt handles capital letters" do
    assert encrypt("abCD", 1) == "zaBC"
  end

  test "encrypt handles spaces" do
    assert encrypt("ab cd", 1) == "za bc"
  end

  test "encrypt handles a large shift number" do
    assert encrypt("abcd", 27) == "zabc"
  end

end
