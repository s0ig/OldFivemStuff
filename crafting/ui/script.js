//https://javascriptobfuscator.com/Javascript-Obfuscator.aspx
var pages = []
var categorys = []
var created = false
var z = 1
var active = false
var crafting = false
var zones
var bigPic = null
var inventory = {}
var player_formulas = {}
var formulas = {}
var lastKeyPress = 0
var playerJob = ""
var resource = ""
var hideLock = false;
var closestObject = [];

function reOrder(currentPage) {
	var i = 0;var f = false;
	var allPages = document.querySelectorAll(".page")
	for (value of allPages) {
		if (value.id == currentPage) {
			f = true;
		};value.style.zIndex = i;
		if (f) {i--} else {i++};
	}
}
function getPercentage(num) {
	
	return ((num * 100 ) / 1920) / 100
}
function scale(){
	var width = screen.width;
	var height = screen.height;
	var wrapper = document.getElementById("wrapper")
	if (width < 1920) {
		var s = getPercentage(width)
		wrapper.style.transform = `scale(${s})`;
		var newLeft = (width - (100*s)) / 1.92
		var newTop = (height - (700*s)) / 2
		wrapper.style.left = newLeft+"px";
		wrapper.style.top = newTop+"px";
		
	} else {
		wrapper.style.transform = "scale(1.0)";
		var newLeft = (width - (100)) / 1.92
		var newTop = (height - (700)) / 2
		wrapper.style.left = newLeft+"px";
		wrapper.style.top = newTop+"px";
	}
}
function changepage(id,ov,clone){

	

	return new Promise(resolve => {
		var lastPage = document.getElementById("wrapper").lastChild.id
		var firstPage = document.getElementById("wrapper").firstElementChild.id
		if (!active) {
			active = true
			var div = document.getElementById(id)
			var front = div.firstElementChild
			var back = div.lastElementChild

			var num = 0

			z++;div.style.zIndex = z



			for (const [key,value] of Object.entries(pages)) {

				if (value == div.id) {
					num = 180
					if (!ov) {
						var myVar = setInterval(function(){
							num++
							div.style.transform = `rotateY(${num}deg)`
							div.style.transformOrigin = "left"
							
							if (num >= 270) {
								front.style.display = "block";
								back.style.display = "none";
							}
							 
							if (num >= 360) {
								clearInterval(myVar);
								removeItem(pages, div.id);
								reOrder(div.id)
								resolve(true)
								active = false

							}
						}, 1);

					} else {

						if (div.id != "page1") {
							var allPages = document.querySelectorAll(".page")
							if (pages[0] != div.id) {
								div.style.transform = `rotateY(${360}deg)`
								div.style.transformOrigin = "left"
								front.style.display = "none";
								back.style.display = "none";
								removeItem(pages, div.id);
								reOrder(div.id)
								resolve(true)
								active = false
							} else {
								var clonePage = document.getElementById("page2").firstElementChild;
								var backUpPage = document.createElement("div");
								backUpPage.innerHTML = div.innerHTML;
								div.firstElementChild.innerHTML = clonePage.innerHTML;
								clonePage.style.display = "none";

								num = 180
								var myVar = setInterval(function(){
									num++
									div.style.transform = `rotateY(${num}deg)`
									div.style.transformOrigin = "left"
									
									if (num >= 270) {
										front.style.display = "block";
										back.style.display = "none";
									}
									 
									if (num >= 360) {

										if (clonePage) {
											div.firstElementChild.innerHTML = backUpPage.firstElementChild.innerHTML
											clonePage.style.display = "block";
											backUpPage.remove();

											for (const [k,v] of Object.entries(allPages)) {
												if (k != 0) {
													v.firstElementChild.style.display = "block";
												}
											}

											div.style.zIndex = z - z + 1
											clonePage = null
										}

										clearInterval(myVar);
										removeItem(pages, div.id);
										pages["page1"]
										reOrder("page1")
										resolve(true)
										active = false

									}
								}, 1);

								resolve(true)
							}
						}

					}
				return
				}
			}


			if (!ov) {

				var clonePage = null
				var backUpPage = null

				if (clone) {
					clonePage = document.getElementById("page2").firstElementChild
					backUpPage = document.createElement("div")
					backUpPage.innerHTML = div.innerHTML
					div.firstElementChild.innerHTML = clonePage.innerHTML
				}

				var myVar = setInterval(function(){
					num++
					div.style.transform = `rotateY(${num}deg)`
					div.style.transformOrigin = "left"
					
					if (num >= 90) {
						front.style.display = "none";
						back.style.display = "block";
						back.style.transform = `rotateY(${180}deg)`

						if (clonePage != null) {
							div.firstElementChild.innerHTML = backUpPage.firstElementChild.innerHTML
							backUpPage.remove();
							clonePage = null
						}

					}
					 
					if (num >= 180) {
						pages.push(div.id)
						reOrder(div.id)
						active = false
						clearInterval(myVar);
						resolve(true)


					}
				}, 1);
			} else {
				if (div.id != "page1") {
					div.style.transform = `rotateY(${180}deg)`
					div.style.transformOrigin = "left"
					front.style.display = "none";
					back.style.display = "block";
					back.style.transform = `rotateY(${180}deg)`
					pages.push(div.id)
					reOrder(div.id)
					active = false
					resolve(true)
				}
			}

		}
	});
}
function getMs() {
	var n = Date.now()
	return n 
}
function canPress() {
	var ms = getMs()
	if (ms - lastKeyPress > 500) {
		lastKeyPress = ms
		return true
	} else {
		return false
	}
}
async function newPage(page,side) {
	if (!active && canPress() && bigPic == null) {
		lastKeyPress = getMs()
		if (side == "back") {
			page = Number(page)
		} else {
			page = Number(page) - 1
		}

		for (var i=2;i<=page;i++) {
			if (i==page) {
				document.getElementById("page1").style.zIndex = z + 1
				if (await changepage("page"+(i),false,true)) {
					document.getElementById("page1").style.zIndex = z - z
				}
			} else {
				changepage("page"+(i),true,false)
			}
		}
	}
}
async function gotoFirstPage() {
	if (!active && pages.length > 1 && canPress()) {
		if (pages.length != 2) {
			var sort = []
			for (var i=0;i<pages.length;i++) {
				sort.unshift(pages[i])
			}
			pages = sort
			for (const [k,v] of Object.entries(pages)) {
				if (v != "page1") {
					if (v != pages[0]) {
						await (changepage(v,true,true))
					}
				} 
			}
			await (changepage(pages[0],true,true))
		} else {
			changepage("page2")
		}
	}
}
function removeItem(array, item){
    for(var i in array){
        if(array[i]==item){
            array.splice(i,1);
            break;
        }
    }
}
function mouseup(event){
	if (!active) {
		if (event.button == 0 && bigPic == null) {
			var parent = event.target.parentElement
			if (parent == null) { return }
			var id = parent.id
			if (id != null && id != undefined) {
				var bool = id.includes("page");
				if (bool && canPress()) {
					changepage(id)
					return
				}
			}
		} else if (event.button == 2) {
			if (bigPic == null) {
				if (event.target.id == "slot") {
					bigPic = document.createElement("div")
					bigPic.id = "bigPic";
					bigPic.setAttribute("data-value",event.target.getAttribute("data-value"));
					var slot = event.target
					var parent = event.target.parentElement
					if (parent.id == "front") {
						img = 'url("img/book/page3.png")'
					} else {
						img = 'url("img/book/page2.png")'
					}
					var clone = slot.cloneNode(true)
					bigPic.append(clone)		
					bigPic.style.background = img;
					bigPic.style.backgroundSize = "cover";
					bigPic.className = "bigPic";
					parent.append(bigPic)
				} 
			} else {
				bigPic.remove()
				bigPic = null
			}
		}
	}
}
function keypress(event){
	if (!active) {
		var key = event.keyCode
		if (key == 32 && bigPic == null) {
			gotoFirstPage()
		}
		if (key == 27) {
			$.post(`http://${resource}/close`, JSON.stringify({}));
		}
	}
}
function isAtZone(zone){
	for (z of zones) {
		if (z == zone) {
			return true
		}
	}
	return false
}
function selectMark(v1,v2) {

	if (v1 >= v2) {return "&#9745;"} else {return "&#9744;"}
}
function stringify(data) {
	var str = ""
	for (value of data) {
		var amount = 0
		if (inventory[value.name]) {
			amount = inventory[value.name].amount
		}
		var label = value.label
		str += `<div id='label'>${label}</div> <div id="marker">${amount} / ${value.amount}  ${(selectMark(amount, value.amount))}</div>`
		str += "</br>"
	}
	return str
}
function formulaOwned(formula) {
	if (formula == "false") {
		return true
	}
	return player_formulas[formula] || false
}
function getPlayerJob(job) {
	if (Array.isArray(job)) {
		var is = false
		for (j of job) {
			if (j == playerJob) {
				is = true
				break
			}
		}
		return is
	}
	if (job == "false") {
		return true
	}
	if (job == playerJob) {
		return true
	}
	return false
}
function createBook() {
	itemCount = 1
	var pages = 1
	var lastCategory = ""
	var currentDiv


	var div = document.createElement("div");
	div.id = "page1";
	div.className = "page";
	div.style.zIndex = 2
	div.innerHTML = `
	<div id="front">
		<img src="img/book/frontpage.png" style="pointer-events: none;"></br>
	</div>
	<div id="back">
	</div>`

	var wrapper = document.getElementById("wrapper")
	wrapper.append(div)


	for (const [k_,v_] of Object.entries(formulas)) {
		if (lastCategory == "") {lastCategory=k_}
		for (const [k,v] of Object.entries(v_)) {

			if (itemCount == 1) {
				pages = pages + 1
				var currentDiv = document.createElement("div");
				currentDiv.id = "page"+pages
				currentDiv.className = "page"
				currentDiv.innerHTML = `<div id="front"></div><div id="back"></div>`
				z--
				currentDiv.style.zIndex = z
				lastCategory = k_

				if (categorys[v.category] == null) {
					categorys[v.category] = {page:pages,side:"front"}
				}
			}

			if (itemCount <= 4 && lastCategory == k_) {
				var front = currentDiv.children.front
				if (itemCount == 1) {
					var head = document.createElement("h2");
					head.innerHTML = v.category
					front.append(head)
				}

				var newItem = document.createElement("div");
				newItem.id = "slot";
				newItem.setAttribute("data-value",JSON.stringify(v));
				v.hasFormula = formulaOwned(v.formula)
				var isJob = getPlayerJob(v.reqjob)
				var button = ""

				v.canCraft = true
				if (v.hasFormula && isJob) {

					for (value of v.materials) {
						if (inventory[value.name]) {
							if (inventory[value.name].amount < value.amount) {
								v.canCraft = false
								break
							}
						} else {
							v.canCraft = false
							break
						}
					}

					

					if (v.canCraft && zones[v.category]) {
						button = `<input type='text' id='amount' name='amount' value='1' placeholder='${translations["amount"]}'><div id="xamount">x${v.amount}</div><button id='button'>${translations["craft"]}</button>`
					} else {
						button = `<input type='text' id='amount' name='amount' value='1' placeholder='${translations["amount"]}'><div id="xamount">x${v.amount}</div><button id='button' disabled><del>${translations["craft"]}</del></button>`
					}

					newItem.innerHTML = `
						<h1>${v.product.label}</h1>
						<img id="item" src=img/items/${v.product.name}.png></br>
						<span id="product" data-value=${JSON.stringify(v.materials)} >${stringify(v.materials)}</span></br>
						${button}
					`

				} else {
					if (!hideLock) {
						newItem.innerHTML = `
							<h1>${v.product.label}</h1>
							<img src="img/book/lock.png" style="margin-top:25px;object-fit:fill;width:150px;max-height:200px;opacity:0.5;">
						`
					}
				}
				front.append(newItem)


				

			} else if ((itemCount > 4 && itemCount <= 8) || lastCategory != k_) {
				if (lastCategory != k_ && currentDiv.children.back.firstElementChild == null) {
					if (categorys[v.category] == null) {
						categorys[v.category] = {page:pages,side:"back"}
					}
					itemCount = 5
				}

				var back = currentDiv.children.back
				if (itemCount == 5) {
					var head = document.createElement("h2");
					head.innerHTML = v.category
					back.append(head)
				}
				var newItem = document.createElement("div");
				newItem.id = "slot";
				newItem.setAttribute("data-value",JSON.stringify(v));
				v.hasFormula = formulaOwned(v.formula)
				var isJob = getPlayerJob(v.reqjob)
				var button = ""
				v.canCraft = true

				if (v.hasFormula && isJob) {

					for (value of v.materials) {
						if (inventory[value.name]) {
							if (inventory[value.name].amount < value.amount) {
								v.canCraft = false
								break
							}
						} else {
							v.canCraft = false
							break
						}
					}

					
					if (v.canCraft && zones[v.category]) {
						button = `<input type='text' id='amount' name='amount' value='1' placeholder='${translations["amount"]}'><div id="xamount">x${v.amount}</div><button id='button'>${translations["craft"]}</button>`
					} else {
						button = `<input type='text' id='amount' name='amount' value='1' placeholder='${translations["amount"]}'><div id="xamount">x${v.amount}</div><button id='button' disabled><del>${translations["craft"]}</del></button>`
					}


					newItem.innerHTML = `
						<h1>${v.product.label}</h1>
						<img id="item" src=img/items/${v.product.name}.png</br>
						<span id="product" data-value=${JSON.stringify(v.materials)} >${stringify(v.materials)}</span></br>
						${button}
					`
				} else {
					if (!hideLock) {
						newItem.innerHTML = `
							<h1>${v.product.label}</h1>
							<img src="img/book/lock.png" style="margin-top:25px;object-fit:fill;width:150px;max-height:200px;opacity:0.5;">
						`
					}
				}
				back.append(newItem)
			}
			itemCount = itemCount + 1
			if  (v_.length-1 == k && (currentDiv.children.back.firstElementChild != null || formulas[Number(k_) + Number(1)] == undefined)) {
				lastCategory=k_
				var wrapper = document.getElementById("wrapper")
				wrapper.append(currentDiv)
				itemCount = 1
			}
			if (itemCount > 8) {
				lastCategory=k_
				var wrapper = document.getElementById("wrapper")
				wrapper.append(currentDiv)
				itemCount = 1
			}
		}
	}

	var firstPageBack = document.getElementById("page1").lastChild
	var container = document.createElement("div")
	container.id = "categorys"
	firstPageBack.append(container)
	for (const [k,v] of Object.entries(categorys)) {
		container.innerHTML += `<p onclick="newPage('${v.page}','${v.side}')">${k}</p>`
	}

	z = 0
}
window.onload = function() {
	window.addEventListener('mouseup',mouseup);
	document.addEventListener('keyup', keypress);	
	window.onresize = function(event){
		scale()
	};
	$(document).on('click', 'button', function(){
		if (!crafting) {
			var parent = this.offsetParent
			if (parent.id == "slot" || parent.id == "bigPic") {
				if (parent.id == "bigPic") {
					var amount = parent.children.slot.children.amount.value
				} else {
					var amount = parent.children.amount.value 
				}
				var data = parent.getAttribute("data-value")
				crafting = true
				$.post(`http://${resource}/craft`, JSON.stringify({
		       		amount : Math.floor(Number(amount)),
		       		formula : data
				}));
			}
		} else {
			
		}
	});
}
function updateInventory(inventory) {
	var slots = document.querySelectorAll("#slot")
	for (const [k,v] of Object.entries(slots)) {
		v.innerHTML = "";
		var data = JSON.parse(v.getAttribute("data-value"))
		data.hasFormula = formulaOwned(data.formula)
		var button = ""
		var isJob = getPlayerJob(data.reqjob)
		data.canCraft = true
		if (data.hasFormula && isJob) {
			for (value of data.materials) {
				if (inventory[value.name]) {
					if (inventory[value.name].amount < value.amount) {
						data.canCraft = false
						break
					}
				} else {
					data.canCraft = false
					break
				}
			}

			if (data.canCraft && ((zones[data.category] && data.reqzone == "true") || data.reqzone == "false") && (closestObjects[data.reqobject] || data.reqobject == "false")) {
				button = `<input type='text' id='amount' name='amount' value='1' placeholder='${translations["amount"]}'><div id="xamount">x${data.amount}</div><button id='button'>${translations["craft"]}</button>`
			} else {
				button = `<input type='text' id='amount' name='amount' value='1' placeholder='${translations["amount"]}'><div id="xamount">x${data.amount}</div><button id='button' disabled><del>${translations["craft"]}</del></button>`
			}

			v.innerHTML = `
				<h1>${data.product.label}</h1>
				<img id="item" src=img/items/${data.product.name}.png></br>
				<span id="product" data-value=${JSON.stringify(data.materials)} >${stringify(data.materials)}</span></br>
				${button}
			`
		} else {
			if (!hideLock) {
				v.innerHTML = `
					<h1>${data.product.label}</h1>
					<img src="img/book/lock.png" style="margin-top:25px;object-fit:fill;width:150px;max-height:200px;opacity:0.5;">
				`
			}
		}
	}
}
function displayWrapper(bool) {
	scale()
	var wrapper = document.getElementById("wrapper")
	if (bool) {
		wrapper.style.display = "block";
	} else {
		wrapper.style.display = "none";
	}
}
function msConversion(millis) {
  let sec = Math.floor(millis / 1000);
  let hrs = Math.floor(sec / 3600);
  sec -= hrs * 3600;
  let min = Math.floor(sec / 60);
  sec -= min * 60;

  sec = '' + sec;
  sec = ('00' + sec).substring(sec.length);

  if (hrs > 0) {
    min = '' + min;
    min = ('00' + min).substring(min.length);
    return hrs + ":" + min + ":" + sec;
  }
  else {
    return min + ":" + sec;
  }
}
function getProgress(time,start) {
	var current = Date.now() - start
	return [(current * 100) / time, current]
}
function runProgressBar(time,text,color) {
	var ms = time * 1000;
	var startTime = Date.now();
	var bar = document.getElementById("progressBar");
	bar.style.color = color;
	bar.style.borderColor = color;
	bar.style.display = `block`;
	bar.innerHTML = text;
	runProg = setInterval(function(){
		var [progress,t] = getProgress(ms,startTime)
		bar.style.background = `linear-gradient(to right, rgba(255,255,255,0.0) ${progress}%, rgba(0,0,0,0.3) 0%)`;
		bar.innerHTML = "<p>"+text+"</p><p>"+msConversion((time*1000-t)+980)+"</p>";
		if (progress >= 100) {
			stopAndResetProgress()
		}
	}, 1);
}
function stopAndResetProgress(){
	var bar = document.getElementById("progressBar")
	bar.style.background = `linear-gradient(to right, gray ${0}%, red 0%)`;
	bar.style.display = `none`;
	clearInterval(runProg)
}
window.addEventListener('message', function(event){
	var eData = event.data

	if (eData.formulas) {formulas = eData.formulas};
	if (eData.closestObjects) {closestObjects = eData.closestObjects};
	if (eData.categorys) {zones = eData.categorys};
	if (eData.inventory) {inventory = eData.inventory};
	if (eData.crafting != null) {crafting = eData.crafting};
	if (eData.hideLock != null) {hideLock = eData.hideLock};
	if (eData.playerJob != null) {playerJob = eData.playerJob};
	if (eData.resource != null) {resource = eData.resource};
	if (eData.player_formulas != null) {
		for (value of eData.player_formulas) {
			player_formulas[value] = true
		}
	};
	if (!created) {createBook();created = true};
	if (eData.updateInv) {updateInventory(eData.inventory)};
	if (eData.menuOpen) {displayWrapper(true)
	} else { if (eData.menuOpen == false) {
	displayWrapper(false)}};
	if (eData.progressbar) {runProgressBar(eData.progressbarTime,eData.progressbarText,eData.progressbarColor)
	} else {if (eData.progressbar == false) {stopAndResetProgress()}};
});
