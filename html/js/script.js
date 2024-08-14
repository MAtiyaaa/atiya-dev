let commands = [];
let currentCategory = 'all';
let favorites = [];
let isDarkMode = true;
let bonesList = [];
let itemsList = [];
let pedsList = [];

window.addEventListener("message", async (event) => {
    const data = event.data;
    if (data.action === "openMenu") {
        commands = data.commands;
        favorites = Array.isArray(data.favorites) ? data.favorites : [];
        renderMenu();
        document.getElementById('menu').style.display = 'block';
        if (!$("#menu").data("draggable")) {
            initializeDraggable();
        }
        restoreMenuState();
    }
    else if (data.action === "closeMenu") {
        closeMenu();
    }
    else if (data.action === "copy") {
        const el = document.createElement("textarea");
        el.value = data.text;
        document.body.appendChild(el);
        el.select();
        document.execCommand("copy");
        document.body.removeChild(el);
    }
});


function renderMenu(filteredCommands = commands) {
    const menu = document.getElementById('menu');
    menu.classList.toggle('light-mode', !isDarkMode);
    const commandList = document.getElementById('commandList');
    commandList.innerHTML = '';

    filteredCommands.sort((a, b) => a.title.localeCompare(b.title)).forEach(cmd => {
        const cmdElement = document.createElement('div');
        cmdElement.className = 'command';
        cmdElement.innerHTML = `
            <h3>
                <i class="${cmd.icon}"></i> ${cmd.title}
                <span class="favorite-button ${favorites.includes(cmd.name) ? 'active' : ''}" onclick="toggleFavorite('${cmd.name}')">
                    <i class="fas fa-star"></i>
                </span>
            </h3>
            <p>${cmd.description}</p>
            <p><strong>Command:</strong> ${cmd.usage}</p>
            ${cmd.parameters.length > 0 ? 
                cmd.parameters.map(param => renderParameter(cmd.name, param)).join('') + 
                `<button onclick="executeCommand('${cmd.name}')">Confirm</button>`
                : renderNonParameterControl(cmd)
            }
        `;
        commandList.appendChild(cmdElement);
    });
    initParameterFocus();
    $('.searchable-dropdown').select2();
}

function fetchJSONData(filename) {
    return fetch(`nui://${GetParentResourceName()}/html/jsondb/${filename}`)
        .then(response => response.json())
        .catch(error => {
            console.error('Error loading JSON:', error);
            return null;
        });
}

Promise.all([
    fetchJSONData('bones.json'),
    fetchJSONData('itemlist.json'),
    fetchJSONData('peds.json')
]).then(([bonesData, itemsData, pedsData]) => {
    bonesList = Object.values(bonesData || {});
    itemsList = itemsData || [];
    pedsList = pedsData || [];
    renderMenu();
}).catch(error => {
    console.error('Error loading JSON data:', error);
});

function renderNonParameterControl(cmd) {
    switch(cmd.mode) {
        case "toggle":
            return `<button onclick="executeCommand('${cmd.name}')" class="execute-btn">Execute</button>`;
        case "slider1":
        case "slider2":
            return `<label class="switch">
                <input type="checkbox" id="toggle-${cmd.name}" onchange="toggleCommand('${cmd.name}', this.checked, '${cmd.mode}')">
                <span class="slider"></span>
            </label>`;
        default:
            return '';
    }
}

function initParameterFocus() {
    document.querySelectorAll('input[type="text"], select').forEach(element => {
        element.addEventListener('focus', function() {
            fetch(`https://${GetParentResourceName()}/focusOn`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            });
        });
        element.addEventListener('blur', function() {
            fetch(`https://${GetParentResourceName()}/focusOff`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            });
        });
    });
}

function filterCategory(category) {
    currentCategory = category;
    const filteredCommands = category === 'all' ? commands :
        category === 'favorites' ? commands.filter(cmd => favorites.includes(cmd.name)) :
        commands.filter(cmd => cmd.category === category);
    renderMenu(filteredCommands);
    document.querySelectorAll('.category-icon').forEach(icon => {
        icon.classList.toggle('active', icon.dataset.category === category);
    });
}

function toggleFavorite(cmdName) {
    const index = favorites.indexOf(cmdName);
    if (index > -1) {
        favorites.splice(index, 1);
    } else {
        favorites.push(cmdName);
    }
    saveFavorites();
    renderMenu(currentCategory === 'all' ? commands : commands.filter(cmd => cmd.category === currentCategory));
}

function saveFavorites() {
    fetch(`https://${GetParentResourceName()}/saveFavorites`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ favorites: favorites })
    });
}

function executeCommand(name) {
    const command = commands.find(cmd => cmd.name === name);
    const params = command.parameters ? command.parameters.map(param => {
        const element = document.getElementById(`params-${name}-${param.name}`);
        return element ? element.value : '';
    }) : [];
    fetch(`https://${GetParentResourceName()}/executeCommand`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            name: name,
            params: params
        })
    });
}

function saveMenuState() {
    const state = {
        category: currentCategory,
        toggles: getToggleStates(),
        dropdowns: getDropdownStates()
    };
    localStorage.setItem('menuState', JSON.stringify(state));
}

function getToggleStates() {
    const toggles = {};
    document.querySelectorAll('.switch input[type="checkbox"]').forEach(toggle => {
        toggles[toggle.id] = toggle.checked;
    });
    return toggles;
}

function getDropdownStates() {
    const dropdowns = {};
    document.querySelectorAll('.searchable-dropdown').forEach(dropdown => {
        dropdowns[dropdown.id] = dropdown.value;
    });
    return dropdowns;
}

function restoreMenuState() {
    const state = JSON.parse(localStorage.getItem('menuState'));
    if (state) {
        currentCategory = state.category;
        setToggleStates(state.toggles);
        setDropdownStates(state.dropdowns);
        filterCategory(currentCategory);
    }
}

function setToggleStates(toggles) {
    for (const [id, checked] of Object.entries(toggles)) {
        const toggle = document.getElementById(id);
        if (toggle) {
            toggle.checked = checked;
        }
    }
}

function setDropdownStates(dropdowns) {
    for (const [id, value] of Object.entries(dropdowns)) {
        const dropdown = document.getElementById(id);
        if (dropdown) {
            dropdown.value = value;
            $(dropdown).trigger('change');
        }
    }
}

function toggleCommand(name, isEnabled, mode) {
    const command = commands.find(cmd => cmd.name === name);
    if (command) {
        command.enabled = isEnabled;
        if (mode === 'slider1' || (mode === 'slider2' && isEnabled)) {
            executeCommand(name);
        }
    }
}

function closeMenu() {
    saveMenuState();
    document.getElementById('menu').style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
}

function toggleTheme() {
    isDarkMode = !isDarkMode;
    document.getElementById('menu').classList.toggle('light-mode', !isDarkMode);
    document.querySelector('.theme-toggle i').classList.toggle('fa-sun', isDarkMode);
    document.querySelector('.theme-toggle i').classList.toggle('fa-moon', !isDarkMode);
}

document.getElementById('searchBar').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const filteredCommands = commands.filter(cmd => 
        (currentCategory === 'all' || cmd.category === currentCategory || (currentCategory === 'favorites' && favorites.includes(cmd.name))) &&
        (cmd.name.toLowerCase().includes(searchTerm) || 
        cmd.title.toLowerCase().includes(searchTerm) ||
        cmd.description.toLowerCase().includes(searchTerm) ||
        cmd.usage.toLowerCase().includes(searchTerm) ||
        cmd.parameters.some(param => param.name.toLowerCase().includes(searchTerm) || param.help.toLowerCase().includes(searchTerm)))
    );
    renderMenu(filteredCommands);
});

function initializeDraggable() {
    $(".menu").draggable({
        handle: ".menu-drag-handle",
        containment: "window",
        scroll: false,
        start: function(event, ui) {
            $(this).css('left', 'auto');
            $(this).css('right', 'auto');
        },
        drag: function(event, ui) {
            if (ui.position.top < 0) {
                ui.position.top = 0;
            }
        }
    });
}

$(document).ready(function() {
    renderMenu();
    initializeDraggable();
    $('.searchable-dropdown').select2();
});

document.querySelector('.menu-close').addEventListener('click', closeMenu);

document.addEventListener('click', function(event) {
    const menu = document.getElementById('menu');
    const isSelect2Element = event.target.closest('.select2-container') !== null;
    if (menu && !menu.contains(event.target) && !isSelect2Element) {
        fetch(`https://${GetParentResourceName()}/closeMenu`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        });
    }
});

document.addEventListener('keydown', function(event) {
    if (event.key === "Escape" && document.getElementById('menu').style.display !== 'none') {
        closeMenu();
    }
});

function renderParameter(cmdName, param) {
    let paramElement = '';
    switch (param.type) {
        case 'dropdown1':
            paramElement = renderSearchableDropdown(cmdName, param);
            break;
        case 'dropdown2':
            paramElement = renderSimpleDropdown(cmdName, param);
            break;
        case 'text':
        default:
            paramElement = `<input type="text" id="params-${cmdName}-${param.name}" placeholder="Type something...">`;
            break;
    }
    
    return `
        <div class="param-container">
            <label for="params-${cmdName}-${param.name}">${param.help}</label>
            ${paramElement}
        </div>
    `;
}

function renderSearchableDropdown(cmdName, param) {
    let options = [];

    if (param.source === 'bones') {
        options = bonesList.map(bone => ({
            id: bone.BoneId,
            text: `${bone.BoneName} (${bone.BoneId})`
        }));
    } else if (param.source === 'items') {
        options = itemsList.map(item => ({
            id: item.ModNam,
            text: `${item.ModNam} (${item.HashIs})`
        }));
    } else if (param.source === 'peds') {
        options = pedsList.map(ped => ({
            id: ped.Name,
            text: `${ped.Title} (${ped.Name})`
        }));
    } 
    return `
        <select id="params-${cmdName}-${param.name}" class="searchable-dropdown">
            <option value="">Select an Option</option>
            ${options.slice(0, 1000).map(option => `<option value="${option.id}">${option.text}</option>`).join('')}
        </select>
    `;
}

function renderSimpleDropdown(cmdName, param) {
    const options = param.dd2actions.split(',').map(action => action.trim());
    return `
        <select id="params-${cmdName}-${param.name}" class="simple-dropdown">
            <option value="">Select an option</option>
            ${options.map(option => `<option value="${option}">${option}</option>`).join('')}
        </select>
    `;
}

function initializeSelect2() {
    $('.searchable-dropdown').each(function() {
        const $select = $(this);
        const dataSource = $select.data('source');
        
        $select.select2({
            placeholder: 'Select an option',
            allowClear: true,
            width: '100%',
            ajax: {
                transport: function(params, success, failure) {
                    let data = [];
                    const searchTerm = params.data.term ? params.data.term.toLowerCase() : '';
                    
                    if (dataSource === 'bones') {
                        data = filterAndMapData(bonesList, searchTerm, 'BoneName', 'BoneId');
                    } else if (dataSource === 'items') {
                        data = filterAndMapData(itemsList, searchTerm, 'ModNam', 'HashIs');
                    } else if (dataSource === 'peds') {
                        data = filterAndMapData(pedsList, searchTerm, 'Name', 'Title');
                    }
                    success({ results: data });
                },
                processResults: function(data) {
                    return {
                        results: data.results
                    };
                }
            },
            minimumInputLength: 1
        });
    });
}

function filterAndMapData(list, searchTerm, textKey, valueKey) {
    return list.filter(item => {
        const text = valueKey ? `${item[textKey]} (${item[valueKey]})` : item;
        return text.toLowerCase().includes(searchTerm);
    }).slice(0, 100).map(item => {
        const text = valueKey ? `${item[textKey]} (${item[valueKey]})` : item;
        const value = valueKey ? item[valueKey] : item;
        return { id: value, text: text };
    });
}
