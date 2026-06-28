#pragma once

#include <QtGlobal>

class QWindow;

namespace MacSystemWindowChrome {
struct WindowMetrics {
    int topInset = 38;
    int leadingInset = 76;
};

WindowMetrics configureWindow(QWindow* window);
bool startWindowDrag(QWindow* window);
bool performWindowZoom(QWindow* window);
}
