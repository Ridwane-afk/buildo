/** @odoo-module **/

const STORAGE_KEY = "buildo_chantier_chatter_width";
const MIN_WIDTH = 280;

function getSavedWidth() {
    const saved = parseInt(window.localStorage.getItem(STORAGE_KEY), 10);
    return Number.isFinite(saved) ? saved : null;
}

function saveWidth(width) {
    window.localStorage.setItem(STORAGE_KEY, String(width));
}

function maxWidthFor(chatter) {
    return Math.round(window.innerWidth * 0.85);
}

function setupHandle(chatter) {
    if (chatter.querySelector(":scope > .o_buildo_chatter_resize_handle")) {
        return; // already set up
    }

    const savedWidth = getSavedWidth();
    if (savedWidth) {
        chatter.style.width = `${Math.min(savedWidth, maxWidthFor(chatter))}px`;
    }

    const handle = document.createElement("div");
    handle.classList.add("o_buildo_chatter_resize_handle");
    chatter.prepend(handle);

    let startX = 0;
    let startWidth = 0;

    const onMouseMove = (ev) => {
        const delta = startX - ev.clientX;
        const newWidth = Math.max(
            MIN_WIDTH,
            Math.min(startWidth + delta, maxWidthFor(chatter))
        );
        chatter.style.width = `${newWidth}px`;
    };

    const onMouseUp = () => {
        document.removeEventListener("mousemove", onMouseMove);
        document.removeEventListener("mouseup", onMouseUp);
        document.body.classList.remove("o_buildo_chatter_resizing");
        handle.classList.remove("o_buildo_resizing");
        saveWidth(chatter.getBoundingClientRect().width);
    };

    handle.addEventListener("mousedown", (ev) => {
        ev.preventDefault();
        startX = ev.clientX;
        startWidth = chatter.getBoundingClientRect().width;
        document.body.classList.add("o_buildo_chatter_resizing");
        handle.classList.add("o_buildo_resizing");
        document.addEventListener("mousemove", onMouseMove);
        document.addEventListener("mouseup", onMouseUp);
    });
}

function scan(root) {
    root.querySelectorAll(".o_buildo_resizable_chatter .o-mail-Form-chatter.o-aside").forEach(setupHandle);
}

scan(document);

const observer = new MutationObserver((mutations) => {
    for (const mutation of mutations) {
        for (const node of mutation.addedNodes) {
            if (node.nodeType !== Node.ELEMENT_NODE) {
                continue;
            }
            if (node.matches?.(".o_buildo_resizable_chatter .o-mail-Form-chatter.o-aside")) {
                setupHandle(node);
            } else {
                scan(node);
            }
        }
    }
});

observer.observe(document.body, { childList: true, subtree: true });
