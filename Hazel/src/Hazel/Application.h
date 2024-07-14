#pragma once

#include "Core.h"

#include "Window.h"
#include "Hazel/LayerStack.h"
#include "Hazel/Events/Event.h"
#include "Hazel/Events/ApplicationEvent.h"

#include "Hazel/ImGui/ImGuiLayer.h"

namespace Hazel {
    class HAZEL_API Application
    {
    public:
        Application();
        virtual ~Application();

        void Run();

		void OnEvent(Event& e);

		void PushLayer(Layer* layer);
		void PushOverlay(Layer* layer);

		inline static Application& Get() { return *s_Instance; }
		inline Window& GetWindow() { return *m_Window; }
	private:
		bool OnWindowClose(WindowCloseEvent& e);

		std::unique_ptr<Window> m_Window;
		ImGuiLayer* m_ImGuiLayer; // 拥有ImGuiLayer控制权
		bool m_Running = true;
		LayerStack m_LayerStack;

		static Application* s_Instance;
    };

	// to be defined in client
	/*将 Application* CreateApplication(); 声明在类外面的主要目的是为客户端提供一个创建 Application 实例的扩展点。
	这样可以使库的设计更加灵活，允许用户在不修改库代码的情况下自定义 Application 的行为和初始化过程*/
    Application* CreateApplication();
}

