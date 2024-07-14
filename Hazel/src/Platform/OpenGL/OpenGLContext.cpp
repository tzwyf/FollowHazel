#include "hzpch.h"
#include "OpenGLContext.h"

#include <GLFW/glfw3.h>
#include <glad/glad.h>

namespace Hazel {
	OpenGLContext::OpenGLContext(GLFWwindow * windowHandle)
		:m_WindowHandle(windowHandle)
	{
		HZ_CORE_ASSERT(windowHandle, "windowHandle为空！")
	}
	void OpenGLContext::Init()
	{
		glfwMakeContextCurrent(m_WindowHandle);
		int status = gladLoadGLLoader((GLADloadproc)glfwGetProcAddress);
		HZ_CORE_ASSERT(status, "初始化Glad失败！");

		HZ_CORE_INFO("OpenGL 信息:");
		HZ_CORE_INFO("	Vendor：{0}", (const char*)glGetString(GL_VENDOR));
		HZ_CORE_INFO("	显卡名：{0}", (const char*)glGetString(GL_RENDERER));
		HZ_CORE_INFO("	版本：{0}", (const char*)glGetString(GL_VERSION));

	}
	void OpenGLContext::SwapBuffers()
	{
		glfwSwapBuffers(m_WindowHandle);
	}
}
