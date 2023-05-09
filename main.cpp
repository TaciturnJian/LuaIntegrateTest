#include "SangoLua.hpp"

using namespace std;
using namespace Sango;

int main() {
	Sango::LuaEnvironment lua;

	lua.mType = String;
	lua.mValue.mString = __FILE__;
	lua.SetVariable("PATH_EXE");
	lua.DoString(R"(PATH_DIR = string.match(PATH_EXE, "^.*\\"))");
	lua.DoString(R"(PATH_SCRIPT_DIR = PATH_DIR.."/scripts")");
	lua.DoString(R"(dofile(PATH_SCRIPT_DIR.."/test.lua"))");

	std::cout << lua.Get("tar").mString << std::endl;

	return 0;
}
