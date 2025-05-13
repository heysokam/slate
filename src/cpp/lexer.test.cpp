//:_____________________________________________________________________
//  slate  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_____________________________________________________________________
#include <minitest.hpp>
using namespace unittest;
#include "./lexer.hpp"

int main(void) {
  it("must lex all valid ascii characters without errors", []() {
    auto allChars = std::string();
    for (char ch = 32; ch <= 126; ++ch) allChars += ch;
    auto L = m2v::Lexer(allChars);
    L.process();
    std::cout << L;
    auto result   = L.res.at(0).id;
    auto Expected = slate::lex::Id::exclamation;
    expect(result).toBe(Expected);
  });
}  //:: main

