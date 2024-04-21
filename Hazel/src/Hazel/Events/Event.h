#pragma once

#include "Hazel/Core.h"

#include <string>
#include <functional>

namespace Hazel {

    //定义一个事件类型的枚举
    enum class EventType {
        None = 0,
        WindowClose, WindowResize, WindowFocus, WindowLastFocus, WindowMoved,
        AppTick, AppUpdate, AppRender,
        KeyPressed, KeyReleased,
        MouseButtonPressed, MouseButtonReleased, MouseMoved, MouseScrolled
    };

    //将事件分成多个分类，用于过滤事件
    enum EventCategory
    {
        None = 0,
        EventCategoryApplication    = BIT(0),
        EventCategoryInput          = BIT(1),
        EventCategoryKeyboard       = BIT(2),
        EventCategoryMouse          = BIT(3),
        EventCategoryMouseButton    = BIT(4),
    };

#define EVENT_CLASS_TYPE(type) static EventType GetStaticType(){return EventType::##type;}\
                                virtual EventType GetEventType() const override {return GetStaticType();}\
                                virtual const char* GetName() const override {return #type;}

#define EVENT_CLASS_CATEGORY(category) virtual int GetCategoryFlags() const override {return category;}

    //事件基类
    class HAZEL_API Event {
        friend class EventDispatcher;

    public:
        virtual EventType GetEventType() const = 0;
        virtual const char* GetName() const = 0;
        virtual int GetCategoryFlags() const = 0;
        virtual std::string ToString() const { return GetName(); }

        inline bool IsInCategory(EventCategory category) {
            return GetCategoryFlags() & category;
        }

    protected:
        bool m_Handled = false;
    };

    //事件调度类
    class EventDispatcher {
        // 使用模板别名定义 EventFn
        template<typename T>
        using EventFn = std::function<bool(T&)>;

    public:
        EventDispatcher(Event& event)
            :m_Event(event){}

        // 事件调度函数
        template<typename T>
        bool Dispatch(EventFn<T> func) {
            // 检查事件类型是否匹配
            if (m_Event.GetEventType() == T::GetStaticType()) {
                // 如果匹配，将事件转换为对应的类型并执行传入的函数
                m_Event.m_Handled = func(*(T*)&m_Event);
                return true;
            }
            return false;
        }

    private:
        Event& m_Event;
    };

    inline std::ostream& operator<<(std::ostream& os, const Event& e) {
        return os << e.ToString();
    }
}
