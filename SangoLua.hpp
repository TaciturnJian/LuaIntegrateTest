#ifndef INCLUDE_SANGO_LUA_HPP
#define INCLUDE_SANGO_LUA_HPP

#include <iostream>
#include <lua.hpp>

/****************************************
*	//以后学一学这个glog库
*	#ifdef SANGO_LUA_USE_GLOG
*	#include <glog/logging.h>
*	#endif
*/

namespace Sango {
	namespace LuaTypes {
		typedef const char *String, **StringHeadAddress;
		typedef long long	Integer, *IntegerHeadAddress;
		typedef double		Number,  *NumberHeadAddress;
		typedef int			Boolean, *BooleanHeadAddress;
	}

	enum LuaType {
		Nil = 0,
		Boolean = 1,
		Integer = 2,
		Number = 3,
		String = 4,
		Table = 5
	};

	enum ActionStatus {
		Normal = 0,
		Exceptional = 1
	};

	class LuaEnvironment {
		/*---------- 联合体 LuaValue 的定义 ----------*/
	public:
		typedef union _LuaValue {
			LuaTypes::Boolean mBoolean;
			LuaTypes::String mString;
			LuaTypes::Integer mInteger;
			LuaTypes::Number mNumber;
		} LuaValue;	

		/*---------- 成员变量 ----------*/
	private:
		/// @brief lua库需要的L指针
		lua_State *mLuaState;

	public:
		/// @brief 临时Lua变量
		LuaValue mValue;

		/// @brief 临时Lua变量的类型
		LuaType mType;

		/*---------- 成员函数 ----------*/
	public:
		/*---------- 构造函数 ----------*/

		/// @brief 实例化一个 Lua 环境
		LuaEnvironment();

		/// @brief 销毁 Lua 环境
		~LuaEnvironment();

		/// @brief 赋值拷贝构造函数
		/// @param other 被复制的对象
		LuaEnvironment &operator= (const LuaEnvironment &other);

		/// @brief 获取变量
		LuaValue Get(LuaTypes::String variableName);

		/// @brief 获取变量
		LuaValue Get(int variableKeyCount, LuaTypes::String *variableKeys);

		/// @brief 获取变量
		LuaValue operator[] (LuaTypes::String variableName);

		/// @brief 执行文件
		ActionStatus DoFile(LuaTypes::String filePath);
		
		/// @brief 执行字符串
		ActionStatus DoString(LuaTypes::String str);

		/// @brief 设置一个值 !请提前确定 mType 与 mValue!
		void SetVariable(LuaTypes::String variableName);

		/// @brief 获取错误信息
		LuaTypes::String GetError();

		/// @brief 获取回溯信息
		LuaTypes::String GetTraceback();

		/// @brief 获取错误信息，写入到buffer中
		void GetError(char *buffer, size_t bufferSize);

		/// @brief 获取回溯信息，写入到buffer中
		void GetTraceback(char *buffer, size_t bufferSize);

		/// @brief 向流中写入错误与回溯信息
		void WriteException(std::ostream &stream);

	private:
		/// @brief 保存值 !请提前确定 mType!
		void WriteIntoValue(int index);
	};
}

#endif
