import css from "../css/app.css";
import "phoenix_html"
import {LiveSocket, debug} from "phoenix_live_view"
let logger =  function(kind, msg, data) {
  // console.log(`${kind}: ${msg}`, data)
}

let serializeForm = (form) => {
  let formData = new FormData(form)
  let params = new URLSearchParams()
  for(let [key, val] of formData.entries()){ params.append(key, val) }

  return params.toString()
}

let Params = {
  data: {},
  set(namespace, key, val){
    if(!this.data[namespace]){ this.data[namespace] = {}}
    this.data[namespace][key] = val
  },
  get(namespace){ return this.data[namespace] || {} }
}

let Hooks = {}
Hooks.SavedForm = {
  mounted(){
    this.el.addEventListener("input", e => {
      Params.set(this.viewName, "stashed_form", serializeForm(this.el))
    })
  }
}

let liveSocket = new LiveSocket("/live", {hooks: Hooks, params: (view) => {
  console.log("Getting here", view);
  return Params.get(view)
},
})
liveSocket.connect()
window.liveSocket = liveSocket
