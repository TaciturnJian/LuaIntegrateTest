#ifndef INCLUDE_SANGO_LUA_HPP
#define INCLUDE_SANGO_LUA_HPP

#include <iostream>
#include <lua.hpp>

/****************************************
*	//�Ժ�ѧһѧ���glog��
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
		/*---------- ������ LuaValue �Ķ��� ----------*/
	public:
		typedef union _LuaValue {
			LuaTypes::Boolean mBoolean;
			LuaTypes::String mString;
			LuaTypes::Integer mInteger;
			LuaTypes::Number mNumber;
		} LuaValue;	

		/*---------- ��Ա���� ----------*/
	private:
		/// @brief lua����Ҫ��Lָ��
		lua_State *mLuaState;

	public:
		/// @brief ��ʱLua����
		LuaValue mValue;

		/// @brief ��ʱLua����������
		LuaType mType;

		/*---------- ��Ա���� ----------*/
	public:
		/*---------- ���캯�� ----------*/

		/// @brief ʵ����һ�� Lua ����
		LuaEnvironment();

		/// @brief ���� Lua ����
		~LuaEnvironment();

		/// @brief ��ֵ�������캯��
		/// @param other �����ƵĶ���
		LuaEnvironment &operator= (const LuaEnvironment &other);

		/// @brief ��ȡ����
		LuaValue Get(LuaTypes::String variableName);

		/// @brief ��ȡ����
		LuaValue Get(int variableKeyCount, LuaTypes::String *variableKeys);

		/// @brief ��ȡ����
		LuaValue operator[] (LuaTypes::String variableName);

		/// @brief ִ���ļ�
		ActionStatus DoFile(LuaTypes::String filePath);
		
		/// @brief ִ���ַ���
		ActionStatus DoString(LuaTypes::String str);

		/// @brief ����һ��ֵ !����ǰȷ�� mType �� mValue!
		void SetVariable(LuaTypes::String variableName);

		/// @brief ��ȡ������Ϣ
		LuaTypes::String GetError();

		/// @brief ��ȡ������Ϣ
		LuaTypes::String GetTraceback();

		/// @brief ��ȡ������Ϣ��д�뵽buffer��
		void GetError(char *buffer, size_t bufferSize);

		/// @brief ��ȡ������Ϣ��д�뵽buffer��
		void GetTraceback(char *buffer, size_t bufferSize);

		/// @brief ������д������������Ϣ
		void WriteException(std::ostream &stream);

	private:
		/// @brief ����ֵ !����ǰȷ�� mType!
		void WriteIntoValue(int index);
	};
}

#endif
