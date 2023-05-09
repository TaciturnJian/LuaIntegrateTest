#include "SangoLua.hpp"

Sango::LuaEnvironment::LuaEnvironment() {
	mLuaState = luaL_newstate();
	luaL_openlibs(mLuaState);
	mValue.mNumber = 0;
	mType = Sango::LuaType::Nil;
}

Sango::LuaEnvironment::~LuaEnvironment() {
	lua_close(mLuaState);
}

Sango::LuaEnvironment &Sango::LuaEnvironment::operator= (const Sango::LuaEnvironment &other) {
	if (this != &other) {
		this->mLuaState = other.mLuaState;
		this->mType = other.mType;
		this->mValue = other.mValue;
	}

	return *this;
}

Sango::LuaEnvironment::LuaValue Sango::LuaEnvironment::Get(Sango::LuaTypes::String variableName) {
	
	mType = (LuaType)lua_getglobal(mLuaState, variableName);
	WriteIntoValue(-1);

	return mValue;
}

Sango::LuaEnvironment::LuaValue Sango::LuaEnvironment::Get(int variableKeyCount, LuaTypes::String *variableKeys) {
	Sango::LuaType type = (Sango::LuaType)lua_getglobal(mLuaState, variableKeys[0]);
	for (int i = 1; i < variableKeyCount && type == Sango::LuaType::Table ; i++) {
		type = (Sango::LuaType)lua_getfield(mLuaState, 1, variableKeys[i]);
	}

	mType = (LuaType)lua_type(mLuaState, -1);
	WriteIntoValue(-1);

	return mValue;
}

Sango::LuaEnvironment::LuaValue Sango::LuaEnvironment::operator[] (LuaTypes::String variableName) {
	return Get(variableName);
}

Sango::ActionStatus Sango::LuaEnvironment::DoFile(Sango::LuaTypes::String filePath) {
	return (ActionStatus)luaL_dofile(mLuaState, filePath);
}

Sango::ActionStatus Sango::LuaEnvironment::DoString(Sango::LuaTypes::String str) {
	return (ActionStatus)luaL_dostring(mLuaState, str);
}

void Sango::LuaEnvironment::SetVariable(Sango::LuaTypes::String variableName) {
	switch (mType) {
	case LuaType::String:
		lua_pushstring(mLuaState, mValue.mString);
		break;

	case LuaType::Number:
		lua_pushnumber(mLuaState, mValue.mNumber);
		break;

	case LuaType::Integer:
		lua_pushinteger(mLuaState, mValue.mInteger);
		break;

	case LuaType::Boolean:
		lua_pushboolean(mLuaState, mValue.mBoolean);
		break;

	default:
		break;
	}

	lua_setglobal(mLuaState, variableName);
}

Sango::LuaTypes::String Sango::LuaEnvironment::GetError() {
	return lua_tostring(mLuaState, -1);
}

Sango::LuaTypes::String Sango::LuaEnvironment::GetTraceback() {
	lua_getglobal(mLuaState, "debug");
	lua_getfield(mLuaState, -1, "traceback");
	lua_pcall(mLuaState, 0, 1, 0);
	return GetError();
}

void Sango::LuaEnvironment::GetError(char *buffer, size_t bufferSize) {
	strcpy_s(buffer, bufferSize, GetError());
}

void Sango::LuaEnvironment::GetTraceback(char *buffer, size_t bufferSize) {
	lua_getglobal(mLuaState, "debug");
	lua_getfield(mLuaState, -1, "traceback");
	lua_pcall(mLuaState, 0, 1, 0);
	GetError(buffer, bufferSize);
}

void Sango::LuaEnvironment::WriteException(std::ostream &stream) {
	stream << "lua exception:\n" << GetError() << '\n';
	stream << GetTraceback() << "\n";
}

void Sango::LuaEnvironment::WriteIntoValue(int index) {
	switch (mType) {
	case LuaType::String:
		mValue.mString = lua_tostring(mLuaState, index);
		break;

	case LuaType::Number:
		mValue.mNumber = lua_tonumber(mLuaState, index);
		break;

	case LuaType::Integer:
		mValue.mInteger = lua_tointeger(mLuaState, index);
		break;

	case LuaType::Boolean:
		mValue.mBoolean = lua_toboolean(mLuaState, index);
		break;

	default:
		mValue.mNumber = 0;
		mType = Sango::LuaType::Nil;
		break;
	}
}
