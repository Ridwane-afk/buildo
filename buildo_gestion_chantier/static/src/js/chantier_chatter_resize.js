/** @odoo-module **/

import { Chatter } from "@mail/chatter/web_portal/chatter";
import { onMounted, onPatched } from "@odoo/owl";
import { patch } from "@web/core/utils/patch";

const STORAGE_KEY = "buildo_chantier_chatter_width";
const MIN_WIDTH = 280;
const HANDLE_ZONE = 12;

function getSavedWidth() {
    const saved = parseInt(window.localStorage.getItem(STORAGE_KEY), 10);
    return Number.isFinite(saved) ? saved : null;
}

function saveWidth(width) {
    window.localStorage.setItem(STORAGE_KEY, String(width));
}

function maxWidthFor() {
    return Math.round(window.innerWidth * 0.85);
}

// Containers that already have their resize listener attached. A plain
// WeakSet guard is required because onPatched fires repeatedly.
const attached = new WeakSet();

function attachResize(container) {
    if (attached.has(container)) {
        return;
    }
    attached.add(container);
    container.classList.add("o_buildo_chatter_resizable");

    const savedWidth = getSavedWidth();
    if (savedWidth) {
        container.style.width = `${Math.min(savedWidth, maxWidthFor())}px`;
    }

    let dragging = false;
    let startX = 0;
    let startWidth = 0;

    const onMouseMove = (ev) => {
        const delta = startX - ev.clientX;
        const newWidth = Math.max(MIN_WIDTH, Math.min(startWidth + delta, maxWidthFor()));
        container.style.width = `${newWidth}px`;
    };

    const onMouseUp = () => {
        dragging = false;
        document.body.classList.remove("o_buildo_chatter_resizing");
        document.removeEventListener("mousemove", onMouseMove);
        document.removeEventListener("mouseup", onMouseUp);
        saveWidth(container.getBoundingClientRect().width);
    };

    // No extra DOM node is created inside the container: Owl actively
    // re-renders it (reactive t-attf-class binding) and reconciling against
    // an unexpected child it didn't create breaks the chatter entirely
    // (confirmed: with a prepended handle <div>, the chatter's thread never
    // finishes rendering). The resize handle is drawn as a CSS ::before
    // pseudo-element instead, and this single listener resolves clicks
    // against it by comparing the cursor position to the container's edge.
    container.addEventListener("mousedown", (ev) => {
        const rect = container.getBoundingClientRect();
        if (ev.clientX - rect.left > HANDLE_ZONE) {
            return;
        }
        ev.preventDefault();
        dragging = true;
        startX = ev.clientX;
        startWidth = rect.width;
        document.body.classList.add("o_buildo_chatter_resizing");
        document.addEventListener("mousemove", onMouseMove);
        document.addEventListener("mouseup", onMouseUp);
    });
}

// Attach the resize behaviour from the Chatter component's own lifecycle
// when it displays a chantier.chantier record. A plain `class` attribute
// on the form view's root <form> node is stripped by Odoo's view
// validation and never reaches the DOM, so the model is checked here via
// `threadModel` (already provided by form_compiler.js) instead. Both
// onMounted and onPatched are needed because the chatter's root only
// exists once its thread has finished loading (t-if="state.thread").
patch(Chatter.prototype, {
    setup() {
        super.setup();
        const setupIfNeeded = () => {
            if (this.props.threadModel !== "chantier.chantier") {
                return;
            }
            const container = this.rootRef.el?.closest(".o-mail-Form-chatter.o-aside");
            if (container) {
                attachResize(container);
            }
        };
        onMounted(setupIfNeeded);
        onPatched(setupIfNeeded);
    },
});
