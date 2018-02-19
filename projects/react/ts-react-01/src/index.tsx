import * as React from "react";
import * as ReactDOM from "react-dom";
import { Router, Route, browserHistory, IndexRoute } from "react-router"

import routes from "./routes"

ReactDOM.render(
  <Router routes={routes} history={browserHistory} />,
  document.getElementById("app")
);