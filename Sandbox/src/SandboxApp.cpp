#include "hzpch.h"
#include "Hazel.h"

class ExampleLayer : public Hazel::Layer {
public:
	ExampleLayer()
		:Layer("Example") {

	}

	void OnUpdate() override {
		//HZ_INFO("ExampleLayer: Update");

		if (Hazel::Input::IsKeyPressed(HZ_KEY_TAB)) {
			HZ_TRACE("Tap key is pressed (poll)!");
		}
	}

	void OnEvent(Hazel::Event& event) override {
		//HZ_TRACE("{0}", event);
		if (event.GetEventType() == Hazel::EventType::KeyPressed) {
			Hazel::KeyPressedEvent& e = (Hazel::KeyPressedEvent&)event;
			if (e.GetKeyCode() == HZ_KEY_TAB) {
				HZ_TRACE("Tap key is pressed (event)!");
			}

			HZ_TRACE("{}", (char)e.GetKeyCode());
		}
	}
};

class  Sandbox : public Hazel::Application
{
public:
	Sandbox() {
		PushLayer(new ExampleLayer());
		PushOverlay(new Hazel::ImGuiLayer());
	};
	~Sandbox() {};
};

Hazel::Application* Hazel::CreateApplication() {
	return new Sandbox();
}