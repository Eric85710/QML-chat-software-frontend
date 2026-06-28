#include "MacSystemWindowChrome_p.h"

#if defined(Q_OS_MACOS) || defined(Q_OS_MAC)

#import <AppKit/AppKit.h>

#include <QWindow>

namespace {
constexpr CGFloat kFallbackTitlebarInset = 38.0;
constexpr CGFloat kFallbackLeadingInset = 76.0;

NSView* qtViewForWindow(QWindow* window)
{
    if (!window) {
        return nil;
    }

    window->winId();
    return reinterpret_cast<NSView*>(window->winId());
}

NSWindow* nativeWindowForWindow(QWindow* window, NSView** qtViewOut = nullptr)
{
    NSView* qtView = qtViewForWindow(window);
    if (qtViewOut) {
        *qtViewOut = qtView;
    }

    return qtView ? qtView.window : nil;
}

CGFloat titlebarInset(NSWindow* window)
{
    if (!window || !window.contentView) {
        return kFallbackTitlebarInset;
    }

    CGFloat inset = 0.0;
    if (@available(macOS 10.10, *)) {
        const NSRect bounds = window.contentView.bounds;
        const NSRect layoutRect = window.contentLayoutRect;
        inset = NSMaxY(bounds) - NSMaxY(layoutRect);
    }

    if (inset <= 1.0) {
        NSButton* closeButton = [window standardWindowButton:NSWindowCloseButton];
        if (closeButton) {
            inset = NSHeight(closeButton.frame) + 18.0;
        }
    }

    return MAX(kFallbackTitlebarInset, ceil(inset));
}

CGFloat leadingInset(NSWindow* window)
{
    if (!window) {
        return kFallbackLeadingInset;
    }

    CGFloat rightEdge = 0.0;
    const NSWindowButton buttonTypes[] = {
        NSWindowCloseButton,
        NSWindowMiniaturizeButton,
        NSWindowZoomButton
    };

    for (NSWindowButton buttonType : buttonTypes) {
        NSButton* button = [window standardWindowButton:buttonType];
        if (button && !button.hidden) {
            rightEdge = MAX(rightEdge, NSMaxX(button.frame));
        }
    }

    return rightEdge > 0.0 ? ceil(rightEdge + 12.0) : kFallbackLeadingInset;
}
} // namespace

namespace MacSystemWindowChrome {

WindowMetrics configureWindow(QWindow* quickWindow)
{
    NSView* qtView = nil;
    NSWindow* window = nativeWindowForWindow(quickWindow, &qtView);
    if (!window || !qtView) {
        return {};
    }

    NSWindowStyleMask styleMask = window.styleMask;
    styleMask |= NSWindowStyleMaskTitled
                 | NSWindowStyleMaskClosable
                 | NSWindowStyleMaskMiniaturizable
                 | NSWindowStyleMaskResizable
                 | NSWindowStyleMaskFullSizeContentView;
    [window setStyleMask:styleMask];
    [window setTitleVisibility:NSWindowTitleHidden];
    [window setTitlebarAppearsTransparent:YES];
    [window setShowsToolbarButton:NO];
    [window setCollectionBehavior:([window collectionBehavior]
                                   | NSWindowCollectionBehaviorFullScreenPrimary)];

    return {
        static_cast<int>(titlebarInset(window)),
        static_cast<int>(leadingInset(window))
    };
}

bool startWindowDrag(QWindow* quickWindow)
{
    NSWindow* window = nativeWindowForWindow(quickWindow);
    if (!window) {
        return false;
    }

    NSEvent* currentEvent = NSApp.currentEvent;
    if (!currentEvent || currentEvent.type != NSEventTypeLeftMouseDown) {
        return false;
    }

    [window performWindowDragWithEvent:currentEvent];
    return true;
}

bool performWindowZoom(QWindow* quickWindow)
{
    NSWindow* window = nativeWindowForWindow(quickWindow);
    if (!window) {
        return false;
    }

    if ([window respondsToSelector:@selector(performZoom:)]) {
        [window performZoom:nil];
    } else {
        [window zoom:nil];
    }
    return true;
}

} // namespace MacSystemWindowChrome

#endif
