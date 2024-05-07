// html/js/script.js
window.addEventListener("message", (event) => {
    const data = event.data;
    if (data.action === "copy") {
        const el = document.createElement("textarea");
        el.value = data.text;
        document.body.appendChild(el);
        el.select();
        document.execCommand("copy");
        document.body.removeChild(el);
    }
});
