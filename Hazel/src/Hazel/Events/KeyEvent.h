#pragma once

#include "Event.h"

#include <sstream>

namespace Hazel {
    class HAZEL_API KeyEvent : public Event {
    public:
        inline int GetKeyCode() const { return m_KeyCode; }

        EVENT_CLASS_CATEGORY(EventCategoryKeyboard | EventCategoryInput)

    protected:
        KeyEvent(int keyCode)
            :m_KeyCode(keyCode) {}

        int m_KeyCode;
    };

    //键盘按键按下事件
    class HAZEL_API KeyPressEvent : public KeyEvent {
    public:
        KeyPressEvent(int keyCode, int repeatCount)
            :KeyEvent(keyCode), m_RepeatCount(repeatCount) {}

        inline int GetRepeatCount() const { return m_RepeatCount; }

        std::string ToString() const override {
            std::stringstream ss;
            ss << "KeyPressEvent: " << m_KeyCode << "(" << m_RepeatCount << " repeats)";
            return ss.str();
        }
        
        EVENT_CLASS_TYPE(KeyPressed)

    private:
        int m_RepeatCount;
    };

    //键盘按键释放事件
    class HAZEL_API KeyReleaseEvent : public KeyEvent {
    public:
        KeyReleaseEvent(int keyCode)
            :KeyEvent(keyCode) {}

        std::string ToString() const override {
            std::stringstream ss;
            ss << "KeyReleaseEvent: " << m_KeyCode;
            return ss.str();
        }

        EVENT_CLASS_TYPE(KeyReleased)
    };
}