#include "hzpch.h"
#include "Hazel.h"

#include <glm/vec3.hpp> // glm::vec3
#include <glm/vec4.hpp> // glm::vec4
#include <glm/mat4x4.hpp> // glm::mat4
#include <glm/gtc/matrix_transform.hpp> // glm::translate, glm::rotate, glm::scale, glm::perspective
glm::mat4 camera(float Translate, glm::vec2 const& Rotate)
{
	glm::mat4 Projection = glm::perspective(glm::radians(45.0f), 4.0f / 3.0f, 0.1f, 100.f);
	glm::mat4 View = glm::translate(glm::mat4(1.0f), glm::vec3(0.0f, 0.0f, -Translate));
	View = glm::rotate(View, Rotate.y, glm::vec3(-1.0f, 0.0f, 0.0f));
	View = glm::rotate(View, Rotate.x, glm::vec3(0.0f, 1.0f, 0.0f));
	glm::mat4 Model = glm::scale(glm::mat4(1.0f), glm::vec3(0.5f));
	return Projection * View * Model;
}

class ExampleLayer : public Hazel::Layer {
public:
	ExampleLayer()
		:Layer("Example") {
		//camera(3.0f, { 2.0f, 1.0f });
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
	};
	~Sandbox() {};
};

Hazel::Application* Hazel::CreateApplication() {
	return new Sandbox();
}