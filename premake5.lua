workspace "Hazel"		-- sln�ļ���
	architecture "x64"	
	configurations{
		"Debug",
		"Release",
		"Dist"
	}
	-- ������Ŀ
	startproject "Sandbox"

-- https://github.com/premake/premake-core/wiki/Tokens#value-tokens
-- ������Ŀ¼:Debug-windows-x86_64
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- ������Խ��������Ŀ¼
IncludeDir = {}
IncludeDir["GLFW"] = "Hazel/vendor/GLFW/include"
IncludeDir["Glad"] = "Hazel/vendor/Glad/include"
IncludeDir["ImGui"] = "Hazel/vendor/imgui"
IncludeDir["glm"] = "Hazel/vendor/glm"

include "Hazel/vendor/GLFW"
include "Hazel/vendor/Glad"
include "Hazel/vendor/imgui"

project "Hazel"		--Hazel��Ŀ
	location "Hazel"--��sln�����ļ����µ�Hazel�ļ���
	kind "StaticLib"--��̬��
	language "C++"
	cppdialect "C++17"
	-- On:�������ɵ����п�ѡ����MTD,��̬����MSVCRT.lib��;
	-- Off:�������ɵ����п�ѡ����MDD,��̬����MSVCRT.dll��;������exe�ŵ���һ̨�������������dll�ᱨ��
	staticruntime "On"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
	
	-- Ԥ����ͷ 
	pchheader "hzpch.h"
	pchsource "Hazel/src/hzpch.cpp"

	-- ����������h��cpp�ļ�
	files{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		-- ���Բ��ð���hpp�ļ�
		"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.inl"
	}

	defines{
		"_CRT_SECURE_NO_WARNINGS"
	}

	-- ����Ŀ¼
	includedirs{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.glm}"-- ����Ŀ¼
	}
	links { 
		"GLFW",
		"Glad",
		"ImGui",
		"opengl32.lib"
	}

	-- �����windowϵͳ
	filter "system:windows"
		systemversion "10.0.17763.0"	-- windowSDK�汾
		-- Ԥ����������
		defines{
			"HZ_PLATFORM_WINDOWS",
			"HZ_BUILD_DLL",
			"GLFW_INCLUDE_NONE" -- ��GLFW������OpenGL
		}

	-- ��ͬ�����µ�Ԥ���岻ͬ
	filter "configurations:Debug"
		defines "HZ_DEBUG"
		runtime "Debug"
		symbols "On"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		optimize "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		optimize "On"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "On"	

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}
	-- ͬ������spdlogͷ�ļ�
	includedirs{
		"Hazel/vendor/spdlog/include",
		"Hazel/src",
		"%{IncludeDir.glm}"
	}
	-- ����hazel
	links{
		"Hazel"
	}

	filter "system:windows"
		systemversion "10.0.17763.0"

		defines{
			"HZ_PLATFORM_WINDOWS"
		}

	-- ��ͬ�����µ�Ԥ���岻ͬ
	filter "configurations:Debug"
		defines "HZ_DEBUG"
		runtime "Debug"
		symbols "On"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		runtime "Release"
		optimize "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		runtime "Release"
		optimize "On"
